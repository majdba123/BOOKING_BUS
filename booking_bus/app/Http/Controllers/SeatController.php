<?php

namespace App\Http\Controllers;

use App\Models\Seat;
use Illuminate\Http\Request;
use App\Models\Bus;
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

        if ($company_id!== $auth_company_id) {
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

        if ($company_id!== $auth_company_id) {

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
            'bus_id'  => 'required|integer'
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        $seat = Seat::where('bus_id' , $request->input('bus_id'))->find($seat_id);
        if (!$seat) {
            return response()->json(['error' => 'Seat not found.'], 404);
        }
        $bus = $seat->bus;
        if (!$bus) {
            return response()->json(['error' => 'Bus not found.'], 404);
        }
        $company_id = $bus->company->id;
        $auth_company_id = auth()->user()->Company->id;

        if ($company_id!== $auth_company_id) {
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
    public function destroy($seat_id)
    {
        $validator = Validator::make($request->all(), [
            'bus_id'  => 'required|integer'
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        $seat = Seat::where('bus_id' , $request->input('bus_id'))->find($seat_id);
        if (!$seat) {
            return response()->json(['error' => 'Seat not found.'], 404);
        }

        $bus = $seat->bus;
        if (!$bus) {
            return response()->json(['error' => 'Bus not found.'], 404);
        }

        $company_id = $bus->Company->id;
        $auth_company_id = auth()->user()->company->id;

        if ($company_id!== $auth_company_id) {
            return response()->json(['error' => 'You are not authorized to delete this seat.'], 403);
        }

        $seat->delete();

        return response()->json([
            'message' => 'Seat deleted successfully',
        ]);
    }
}
