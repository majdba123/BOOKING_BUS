<?php

namespace App\Http\Controllers;

use App\Events\PrivateNotification;
use App\Models\Rate_Trips;
use App\Models\Trip;
use App\Models\User;
use App\Models\UserNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
class RateTripsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $company = Auth::user()->Company;
        $company->load('trip.rate_trip');

        $rateTrips = $company->trip->flatMap->rate_trip;

        return response()->json($rateTrips);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function rate_trip__by_id($tripId)
    {
        $company = Auth::user()->Company;

        $trip = $company->trip()->where('id', $tripId)->first();

        if (!$trip) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }
        $trip->load('rate_trip');
        $rateTrips = $trip->rate_trip;
        return response()->json($rateTrips);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request ,$trip_id)
    {
        $user = auth()->user();
        // Get the rating value from the request (1-5)
        $rating = $request->input('num');
        // Validate the rating value
        if (!in_array($rating, range(1, 5))) {
            return response()->json(['error' => 'Invalid rating value'], 400);
        }
        $trip =Trip::findOrfail($trip_id);
        // Get the trip ID from the request
        // Create a new rating instance
        $ratingInstance = new Rate_Trips();
        // Set the rating value, user ID, and trip ID
        $ratingInstance->rating = $rating;
        $ratingInstance->user_id = $user->id;
        $ratingInstance->trip_id = $trip_id;
        // Save the rating instance
        $ratingInstance->save();
        // Return a success response
        $massage = "Rating submited successfully  :  $rating  user_id : $user->id ";
        event(new PrivateNotification( $user->id , $massage));
        UserNotification::create([
            'user_id' =>  $user->id,
            'notification' => $massage,
        ]);

        $massage = " user rate trip   :  $rating   user_id : $user->id ";
        event(new PrivateNotification(  $trip->company->user->id , $massage));
        UserNotification::create([
            'user_id' =>  $user->id,
            'notification' => $massage,
        ]);



        return response()->json(['message' => 'Rating submited successfully']);
    }

    /**
     * Display the specified resource.
     */
    public function show(Rate_Trips $rate_Trips)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Rate_Trips $rate_Trips)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Rate_Trips $rate_Trips)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Rate_Trips $rate_Trips)
    {
        //
    }
}
