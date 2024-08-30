<?php

namespace App\Http\Controllers;

use App\Models\Geolocation;
use App\Models\Private_trip;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PrivateTripController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $privateTrips = Private_trip::where('status', 'padding')->get();

        return response()->json($privateTrips);
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
        try {
            DB::beginTransaction();
    
            $validator = Validator::make($request->all(), [
                'from' => 'required',
                'to' => 'required',
                'date' => 'required',
                'start_time' => 'required',
                'lat_from' => ['required', 'regex:/^[-]?(([0-8]?[0-9])\.(\d+))|(90(\.0+)?)$/'],
                'long_from' => ['required', 'regex:/^[-]?((((1[0-7][0-9])|([0-9]?[0-9]))\.(\d+))|180(\.0+)?)$/'],
                'lat_to' => ['required', 'regex:/^[-]?(([0-8]?[0-9])\.(\d+))|(90(\.0+)?)$/'],
                'long_to' => ['required', 'regex:/^[-]?((((1[0-7][0-9])|([0-9]?[0-9]))\.(\d+))|180(\.0+)?)$/'],
                'Distance' => 'required|numeric',
            ]);
    
            if ($validator->fails()) {
                $errors = $validator->errors()->first();
                return response()->json(['error' => $errors], 422);
            }
    
            $user = Auth::user();
            $lat_from = $request->input('lat_from');
            $long_from = $request->input('long_from');
            $lat_to = $request->input('lat_to');
            $long_to = $request->input('long_to');
    
            $fromLocation = geolocation::create([
                'latitude' => $lat_from,
                'longitude' => $long_from
            ]);
    
            $toLocation = geolocation::create([
                'latitude' => $lat_to,
                'longitude' => $long_to
            ]);
    
            $private = new Private_trip();
            $private->user_id = $user->id;
            $private->from = $request->input('from');
            $private->to = $request->input('to');
            $private->from_location = $fromLocation->id;
            $private->to_location = $toLocation->id;
            $private->date = $request->input('date');
            $private->start_time = $request->input('start_time');
            $private->Distance = $request->input('Distance');
            $private->save();
    
            DB::commit();
    
            return response()->json(['message' => 'Private trip created successfully'], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Failed to create private trip'], 500);
        }
    }
    /**
     * Display the specified resource.
     */
    public function show(Private_trip $private_trip)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Private_trip $private_trip)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        try {
            DB::beginTransaction();
    
            $privateTrip = Private_trip::findOrfail($id);
    
            // Check if the authenticated user is the owner of the private trip
            if ($privateTrip->user_id !== Auth::user()->id) {
                return response()->json(['error' => 'You are not authorized to update this private trip'], 403);
            }
    
            $validator = Validator::make($request->all(), [
                'from' => 'sometimes|required',
                'to' => 'sometimes|required',
                'date' => 'sometimes|required',
                'start_time' => 'sometimes|required',
            ]);
    
            if ($validator->fails()) {
                $errors = $validator->errors()->first();
                return response()->json(['error' => $errors], 422);
            }
    
            if ($request->has('from')) {
                $privateTrip->from = $request->input('from');
            }
            if ($request->has('to')) {
                $privateTrip->to = $request->input('to');
            }
            if ($request->has('date')) {
                $privateTrip->date = $request->input('date');
            }
            if ($request->has('start_time')) {
                $privateTrip->start_time = $request->input('start_time');
            }
    
            $privateTrip->save();
    
            DB::commit();
            return response()->json($privateTrip);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Failed to update private trip'], 500);
        }
    }
    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $private_trip = Private_trip::findOrfail($id);
        $user = Auth::user();
        if ($private_trip->user_id !== $user->id) {
            return response()->json(['error' => 'you are not owner of this trip'], 401);
        }
        $private_trip->delete();
        return response()->json(['message' => 'Private trip deleted successfully'], 200);
    }

    public function getPrivateTripsByStatus(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'status' => 'required|in:completed,padding',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        $user = Auth::user();
        $privateTrips = Private_trip::where('user_id', $user->id)
            ->where('status', $request->input('status'))
            ->get();
        return response()->json($privateTrips);
    }
}
