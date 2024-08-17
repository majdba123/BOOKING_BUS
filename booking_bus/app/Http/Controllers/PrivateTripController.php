<?php

namespace App\Http\Controllers;

use App\Models\Private_trip;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

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
        $validator = Validator::make($request->all(), [
            'from' => 'required',
            'to' => 'required',
            'date' => 'required',
            'start_time' => 'required',
        ]);
        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        $user = Auth::user();

        $private = new Private_trip();
        $private->user_id = $user->id;
        $private->from = $request->input('from');
        $private->to = $request->input('to');
        $private->date = $request->input('date');
        $private->start_time = $request->input('start_time');
        $private->save();

        return response()->json(['message' => 'Private trip created successfully'], 201);
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
        return response()->json($privateTrip);
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
