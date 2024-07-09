<?php

namespace App\Http\Controllers;

use App\Models\Bus;
use Illuminate\Http\Request;
use App\Models\Seat;

use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
class BusController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $company=Auth::user()->Company->id;
        $bus = Bus::where('company_id', $company )->get();
        return response()->json($bus, 200);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function get_bus_by_status(Request $request)
    {
        $company=Auth::user()->Company->id;

        $bus = Bus::where('company_id', $company )
               ->where('status' , $request->input('status'))
               ->get();

        return response()->json($bus, 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
       $company =Auth::user()->Company->id;

        $validator = Validator::make($request->all(), [
            'number_bus' => 'required|string',
            'number_passenger' => 'required|string',
        ]);
        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        $bus = new Bus();
        $bus->number_bus = $request->input('number_bus');
        $bus->number_passenger = $request->input('number_passenger');
        $bus->company_id = $company;
        $bus->save();

        $number_passenger = $bus->number_passenger;


        // Create seats equal to the number of passengers

        for ($i = 0; $i < $number_passenger; $i++) {
            $seat = new Seat();
            $seat->bus_id = $bus->id;
            $seat->save();
        }
        return response()->json([
            'message' => 'bus Created ',
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(Bus $bus)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Bus $bus)
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
            'number_bus' => 'sometimes|string',
            'number_passenger' => 'sometimes|string',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        $bus = Bus::find($id);

        // Check if the bus belongs to the same company as the authenticated user
        if ($bus->company_id!== $company) {
            return response()->json(['error' => 'Unauthorized to update bus'], 403);
        }

        $bus->number_bus = $request->input('number_bus')?? $bus->number_bus;
        $bus->number_passenger = $request->input('number_passenger')?? $bus->number_passenger;
        $bus->save();

        return response()->json($bus);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $company = Auth::user()->Company->id;

        $bus = Bus::find($id);

        // Check if the bus belongs to the same company as the authenticated user
        if ($bus->company_id !== $company) {
            return response()->json(['error' => 'Unauthorized to delete bus'], 403);
        }

        $bus->delete();

        return response()->json([
            'message' => 'bus deleted',
        ]);
    }
}
