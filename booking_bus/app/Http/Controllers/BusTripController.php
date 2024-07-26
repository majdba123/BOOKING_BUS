<?php

namespace App\Http\Controllers;

use App\Models\Bus_Trip;
use App\Models\Trip;
use App\Models\Breaks_trip;
use App\Models\Bus_Driver;
use App\Models\Pivoit;
use App\Models\Bus;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class BusTripController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(Bus_Trip $bus_Trip)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Bus_Trip $bus_Trip)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Bus_Trip $bus_Trip)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function getBusTripsByTripId($tripId)
    {
        $companyId = Auth::user()->company->id;
        if($companyId){
            $trip = Trip::where('company_id' , $companyId)->find($tripId);
            if (!$trip) {
                // Return an error or a default response if the trip is not found
                return response()->json(['error' => 'Trip not found'], 404);
            }
        }else{
            $trip = Trip::find($tripId);
            if (!$trip) {
                // Return an error or a default response if the trip is not found
                return response()->json(['error' => 'Trip not found'], 404);
            }
        }

        $busTrips = $trip->bus_trip;


        $busTripsData = [];
        foreach ($busTrips as $busTrip) {
            $busTripData = [
                'bus_id' => $busTrip->bus_id,
                'from' => $trip->path->from,
                'to' => $trip->path->to,
                'from_time' => $busTrip->from_time,
                'to_time' => $busTrip->to_time,
                'type' => $busTrip->type,
                'event' => $busTrip->event,
            ];

            $breaksData = [];
            foreach ($busTrip->Pivoit as $pivot) {
                $breakData = [
                    'id' => $pivot->id,
                    'government' => $pivot->break_trip->break->area->name,
                    'name_break' => $pivot->break_trip->break->name,
                    'status' => $pivot->status,
                ];
                $breaksData[] = $breakData;
            }

            $busTripData['breaks'] = $breaksData;

            $seats = $busTrip->bus->seat;
            $seatsData = [];
            foreach ($seats as $seat) {
                $seatsData[] = [
                    'status' => $seat->status,
                    // Add any other columns you want to include from the seats table
                ];
            }
            $busTripData['seats'] = $seatsData;

            $busTripsData[] = $busTripData;
        }

        return response()->json($busTripsData);
    }


    public function getBusTripsByFillter(Request $request)
    {
        $fromTime = $request->input('from_time');
        $toTime = $request->input('to_time');
        $type = $request->input('type');
        $from = $request->input('from');
        $to = $request->input('to');

        $busTrips = Bus_Trip::query();

        if ($fromTime) {
            $busTrips->where('from_time', $fromTime);
        }

        if ($toTime) {
            $busTrips->where('to_time', $toTime);
        }

        if ($type) {
            $busTrips->where('type', $type);
        }

        if ($from) {

            $busTrips->whereHas('trip.path', function ($query) use ($from) {

                $query->where('from', $from);

            });

        }


        if ($to) {

            $busTrips->whereHas('trip.path', function ($query) use ($to) {

                $query->where('to', $to);

            });

        }

        $busTrips = $busTrips->get();

        $busTripsData = [];
        foreach ($busTrips as $busTrip) {
            $busTripData = [
                'bus_id' => $busTrip->bus_id,
                'from_time' => $busTrip->from_time,
                'to_time' => $busTrip->to_time,
                'type' => $busTrip->type,
                'event' => $busTrip->event,
            ];

            $breaksData = [];
            foreach ($busTrip->Pivoit as $pivot) {
                $breakData = [
                    'id' => $pivot->id,
                    'government' => $pivot->break_trip->break->area->name,
                    'name_break' => $pivot->break_trip->break->name,
                    'status' => $pivot->status,
                ];
                $breaksData[] = $breakData;
            }

            $busTripData['breaks'] = $breaksData;

            $seats = $busTrip->bus->seat;
            $seatsData = [];
            foreach ($seats as $seat) {
                $seatsData[] = [
                    'status' => $seat->status,
                    // Add any other columns you want to include from the seats table
                ];
            }
            $busTripData['seats'] = $seatsData;

            $busTripsData[] = $busTripData;
        }

        return response()->json($busTripsData);
    }

    public function get_fillter_bus_trip(Request $request)
    {
        $company = Auth::user()->Company->id;

        $validator = Validator::make($request->all(), [
            'from_time' => 'sometimes|string',
            'to_time' => 'sometimes|string',
            'type' => 'sometimes|string',
            'from' => 'sometimes|string',
            'to' => 'sometimes|string',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        $fromTime = $request->input('from_time');
        $toTime = $request->input('to_time');
        $type = $request->input('type');
        $from = $request->input('from');
        $to = $request->input('to');
        $busTrips = Bus_Trip::whereHas('bus', function ($query) use ($company) {
            $query->where('company_id', $company);
        });
        if ($fromTime) {
            $busTrips->where('from_time', $fromTime);
        }
        if ($toTime) {
            $busTrips->where('to_time', $toTime);
        }
        if ($type) {
            $busTrips->where('type', $type);
        }
        if ($from) {
            $busTrips->whereHas('trip.path', function ($query) use ($from) {
                $query->where('from', $from);
            });
        }
        if ($to) {
            $busTrips->whereHas('trip.path', function ($query) use ($to) {
                $query->where('to', $to);
            });
        }
        $busTrips = $busTrips->get();
        $busTripsData = [];
        foreach ($busTrips as $busTrip) {
            $busTripData = [
                'bus_id' => $busTrip->bus_id,
                'from_time' => $busTrip->from_time,
                'to_time' => $busTrip->to_time,
                'type' => $busTrip->type,
                'event' => $busTrip->event,
            ];

            $breaksData = [];
            foreach ($busTrip->Pivoit as $pivot) {
                $breakData = [
                    'id' => $pivot->id,
                    'government' => $pivot->break_trip->break->area->name,
                    'name_break' => $pivot->break_trip->break->name,
                    'status' => $pivot->status,
                ];
                $breaksData[] = $breakData;
            }
            $busTripData['breaks'] = $breaksData;
            $seats = $busTrip->bus->seat;
            $seatsData = [];
            foreach ($seats as $seat) {
                $seatsData[] = [
                    'status' => $seat->status,
                    // Add any other columns you want to include from the seats table
                ];
            }
            $busTripData['seats'] = $seatsData;
            $busTripsData[] = $busTripData;
        }
        return response()->json($busTripsData);
    }
}
