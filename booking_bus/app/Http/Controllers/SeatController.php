<?php

namespace App\Http\Controllers;

use App\Models\Seat;
use Illuminate\Http\Request;
use App\Models\Bus;
use App\Models\Bus_Trip;
use App\Models\Reservation;
use App\Models\Seat_Reservation;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class SeatController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($bus_id)
    {
        $bus = Bus::find($bus_id);
        if (!$bus) {
            return response()->json(['error' => 'Bus not found.'], 404);
        }

        $company_id = $bus->company->id;
        $auth_company_id = auth()->user()->Company->id;

        if ($company_id !== $auth_company_id) {
            return response()->json(['error' => 'You are not authorized to view seats for this bus.'], 403);
        }

        $seats = Seat::where('bus_id', $bus_id)->get();

        return response()->json($seats);
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
    public function store(Request $request, $bus_id)
    {
        $bus = Bus::find($bus_id);
        if (!$bus) {

            return response()->json(['error' => 'Bus not found.'], 404);
        }

        $company_id = $bus->company->id;

        $auth_company_id = auth()->user()->Company->id;

        if ($company_id !== $auth_company_id) {

            return response()->json(['error' => 'You are not authorized to create a seat for this bus.'], 403);
        }
        $number_passenger = $bus->number_passenger;

        $existing_seats = Seat::where('bus_id', $bus_id)->count();

        $validator = Validator::make($request->all(), [
            'number_seat' => 'sometimes|integer',
            'location_seat' => 'sometimes|string',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        if ($existing_seats >= $number_passenger) {
            return response()->json(['error' => 'This bus cannot accommodate more seats.'], 422);
        }

        $seat = new Seat();
        $seat->bus_id = $bus_id;
        $seat->number_seat = $request->input('number_seat');
        $seat->location_seat = $request->input('location_seat');

        $seat->save();

        return response()->json([
            'message' => 'Seat created successfully',
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(Seat $seat)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Seat $seat)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $seat_id)
    {
        $validator = Validator::make($request->all(), [

            'number_seat' => 'sometimes|integer',
            'location_seat' => 'sometimes|string',
            'bus_id'  => 'required|exists:buses,id,deleted_at,NULL'
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        $seat = Seat::where('bus_id', $request->input('bus_id'))->find($seat_id);
        if (!$seat) {
            return response()->json(['error' => 'Seat not found.'], 404);
        }
        $bus = $seat->bus;
        if (!$bus) {
            return response()->json(['error' => 'Bus not found.'], 404);
        }
        $company_id = $bus->company->id;
        $auth_company_id = auth()->user()->Company->id;

        if ($company_id !== $auth_company_id) {
            return response()->json(['error' => 'You are not authorized to update this seat.'], 403);
        }

        $seat->number_seat = $request->input('number_seat', $seat->number_seat);
        $seat->location_seat = $request->input('location_seat', $seat->location_seat);
        $seat->save();

        return response()->json([
            'message' => 'Seat updated successfully',
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Request $request, $seat_id)
    {
        $validator = Validator::make($request->all(), [
            'bus_id'  => 'required|exists:buses,id,deleted_at,NULL'
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        $seat = Seat::where('bus_id', $request->input('bus_id'))->find($seat_id);
        if (!$seat) {
            return response()->json(['error' => 'Seat not found.'], 404);
        }

        $bus = $seat->bus;
        if (!$bus) {
            return response()->json(['error' => 'Bus not found.'], 404);
        }

        $company_id = $bus->Company->id;
        $auth_company_id = auth()->user()->company->id;

        if ($company_id !== $auth_company_id) {
            return response()->json(['error' => 'You are not authorized to delete this seat.'], 403);
        }

        $seat->delete();

        return response()->json([
            'message' => 'Seat deleted successfully',
        ]);
    }


    //hamza

    /*public function seatOfBus($bus_id)
    {
        $bus = Bus::find($bus_id);
        if (!$bus) {
            return response()->json(['error' => 'Bus not found.'], 404);
        }

        $seats = Seat::where('bus_id', $bus_id)->get(['id', 'status']);

        return response()->json($seats);
    }*/

    public function seatOfBus($bus_trip_id)
    {
        $bus_trip = Bus_Trip::findOrfail($bus_trip_id);
        $bus_seats = $bus_trip->bus->seat->pluck('id')->all();
        $result = [];

        foreach ($bus_seats as $seat_id) {
            $seat_reservations = seat_reservation::whereHas('reservation', function ($query) use ($bus_trip_id) {
                $query->where('bus__trip_id', $bus_trip_id);
            })->where('seat_id', $seat_id)->get();

            if ($seat_reservations->count() > 1) {
                $statuses = $seat_reservations->pluck('status')->all();
                if (in_array(1, $statuses) && in_array(2, $statuses)) {
                    $result[] = [
                        'seat_id' => $seat_id,
                        'status' => 3,
                    ];
                    continue;
                }
            }

            $seat_reservation = $seat_reservations->first();

            if ($seat_reservation) {
                $result[] = [
                    'seat_id' => $seat_id,
                    'status' => (int)$seat_reservation->status,
                ];
            } else {
                $result[] = [
                    'seat_id' => $seat_id,
                    'status' => (int) Seat::find($seat_id)->status
                ];
            }
        }

        return $result;
    }
}
