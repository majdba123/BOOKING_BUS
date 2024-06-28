<?php

namespace App\Http\Controllers;

use App\Models\Trip;
use App\Models\Breaks_trip;
use App\Models\Bus_Driver;
use App\Models\Bus_Trip;
use App\Models\Pivoit;
use App\Models\Bus;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class TripController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $company_id = Auth::user()->Company->id;
        $trips=Trip::where('company_id' ,$company_id)->with(['bus_trip.Pivoit','breaks_trip.break.area','path_id'])->get();
        return response()->json($trips);
    }


    /**
     * Show the form for creating a new resource.
     */
    public function index_status(Request $request)
    {
        $company_id = Auth::user()->Company->id;
        $trips=Trip::where('company_id' ,$company_id)
                    ->where('status',$request->input('status'))
                    ->with(['bus_trip.Pivoit','breaks_trip.break.area','path_id'])->get();
        return response()->json($trips);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $company =Auth::user()->Company->id;
        $validator = Validator::make($request->all(), [
            'path_id' => 'required|exists:paths,id',
            'price' => 'sometimes|required|string|max:255',
            'breaks_ids' => 'required|array',
            'breaks_ids.*' => 'integer',
            'bus_ids' => 'required|array',
            'bus_ids.*.bus_id' => 'integer',
            'bus_ids.*.type' => 'string|required',
            'bus_ids.*.start_time' => 'nullable|date_format:H:i',
            'bus_ids.*.end_time' => 'nullable|date_format:H:i',
          ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        $trip =New Trip();
        $trip->path_id = $request->input('path_id');
        $trip->company_id= $company;
        $trip->price= $request->input('price');
        $trip->save();

        $breakIds = $request->input('breaks_ids');

        foreach ($breakIds as $breakId) {
            $breakTrip = new Breaks_trip();
            $breakTrip->trip_id = $trip->id;
            $breakTrip->breaks_id = $breakId;
            $breakTrip->save();
        }


        $busIds = $request->input('bus_ids');
        foreach ($busIds as $busId) {
            $bus = Bus::find($busId['bus_id']);
            if ($bus && $bus->status == 'available') {
                $busTrip = new Bus_Trip();
                $busTrip->trip_id = $trip->id;
                $busTrip->bus_id = $busId['bus_id'];
                $busTrip->type = $busId['type'];
                $busTrip->from_time = $busId['start_time']; // optional
                $busTrip->to_time = $busId['end_time']; // optional
                $busTrip->save();
                $bus->status ='completed';
                $bus->bus_driver->pluck('driver')->each->update(['status' => 'completed']);
                $bus->save();

                $breakTrips = Breaks_trip::where('trip_id', $trip->id)->get();
                foreach ($breakTrips as $breakTrip) {
                    $pivoit = New Pivoit();
                    $pivoit->bus__trip_id = $busTrip->id;
                    $pivoit->breaks_trip_id = $breakTrip->id;
                    $pivoit->save();
                }

            } else {
                // You can return an error message or log an error if the bus is not available
                return response()->json([
                    'message' => 'bus not  available',
                ]);
            }
        }

        return response()->json([
            'message' => 'trip Created ',
        ]);


    }

    /**
     * Display the specified resource.
     */
    public function show($trip)
    {
        $company_id = Auth::user()->Company->id;
        $trips=Trip::where('company_id' ,$company_id )
                    ->where('id',$trip)
                    ->with(['bus_trip.Pivoit.break_trip','breaks_trip.break.area','path_id'])->get();
        return response()->json($trips);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Trip $trip)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $company = Auth::user()->Company->id;
        $validator = Validator::make($request->all(), [
            'path_id' => 'exists:paths,id',
            'price' => 'sometimes|string|max:255',
            'breaks_ids' => 'required_with:bus_ids|array',
            'breaks_ids.*' => 'integer',
            'bus_ids' => 'required_with:breaks_ids|array',
            'bus_ids.*.bus_id' => 'integer',
            'bus_ids.*.type' => 'string',
            'bus_ids.*.start_time' => 'nullable|date_format:H:i',
            'bus_ids.*.end_time' => 'nullable|date_format:H:i',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        $trip = Trip::find($id);

        if (!$trip) {

            return response()->json(['error' => 'Trip not found'], 404);
        }
        if ($request->has('path_id')) {
            $trip->path_id = $request->input('path_id');
            $trip->save();
        }
        if ($request->has('price')) {
            $trip->price = $request->input('price');
            $trip->save();
        }

        if ($request->has('breaks_ids') && $request->has('bus_ids'))
        {
            $bus_trips = Bus_Trip::where('trip_id',$trip->id)->get();
            if ($bus_trips->count() > 0) {
                foreach($bus_trips as $bus_trip)
                {
                    $bus = $bus_trip->bus;
                    if ($bus) {
                        $bus->status ='available';
                        $bus->save();
                        $drivers = Bus_Driver::where('bus_id',$bus->id)
                                           ->where('status', 'pending')
                                            ->get();
                        if ($drivers->count() > 0) {
                            foreach($drivers as $driverr)
                            {
                                $x = $driverr->driver;
                                $x->status ='available';
                                $x->save();

                            }
                        }
                    }
                }
                $trip->bus_trip()->delete();
                $trip->breaks_trip()->delete();

                $breakIds = $request->input('breaks_ids');
                foreach ($breakIds as $breakId) {
                        $breakTrip = new Breaks_trip();
                        $breakTrip->trip_id = $trip->id;
                        $breakTrip->breaks_id = $breakId;
                        $breakTrip->save();
                    }
                    $busIds = $request->input('bus_ids');

                    foreach ($busIds as $busId) {
                        $bus = Bus::find($busId['bus_id']);
                        if ($bus && $bus->status == 'available') {
                            $busTrip = new Bus_Trip();
                            $busTrip->trip_id = $trip->id;
                            $busTrip->bus_id = $busId['bus_id'];
                            $busTrip->type = $busId['type'];
                            $busTrip->from_time = $busId['start_time']; // optional
                            $busTrip->to_time = $busId['end_time']; // optional
                            $busTrip->save();
                            $bus->status = 'completed';
                            $bus->bus_driver->pluck('driver')->each->update(['status' => 'completed']);
                            $bus->save();

                            $breakTrips = Breaks_trip::where('trip_id', $trip->id)->get();
                            foreach ($breakTrips as $breakTrip) {
                                $pivoit = New Pivoit();
                                $pivoit->bus__trip_id = $busTrip->id;
                                $pivoit->breaks_trip_id = $breakTrip->id;
                                $pivoit->save();
                            }


                        } else {
                            // You can return an error message or log an error if the bus is not available
                            return response()->json([
                                'message' => 'Bus not available',
                            ]);
                        }
                    }
                }
        }
        return response()->json([
            'message' => 'Trip updated successfully',
        ]);

    }
    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $trip = Trip::find($id);
        if (!$trip) {

            return response()->json(['error' => 'Trip not found'], 404);
        }
        $bus_trips = Bus_Trip::where('trip_id',$trip->id)->get();
        if ($bus_trips->count() > 0) {
            foreach($bus_trips as $bus_trip)
            {
                $bus = $bus_trip->bus;
                if ($bus) {
                    $bus->status ='available';
                    $bus->save();
                    $drivers = Bus_Driver::where('bus_id',$bus->id)
                                       ->where('status', 'pending')
                                        ->get();
                    if ($drivers->count() > 0) {
                        foreach($drivers as $driverr)
                        {
                            $x = $driverr->driver;
                            $x->status ='available';
                            $x->save();

                        }
                    }
                }
            }
        }
        $trip->delete();
        return response()->json([
            'message' => 'Trip deleted successfully',
        ]);
    }
}
