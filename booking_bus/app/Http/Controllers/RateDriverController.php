<?php

namespace App\Http\Controllers;

use App\Models\Rate_Driver;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
class RateDriverController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $company = Auth::user()->Company;
        $company->load('driver.rate_driver');

        $rateTrips = $company->driver->flatMap->rate_driver;

        return response()->json($rateTrips);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function rate_driver__by_id($tripId)
    {
        $company = Auth::user()->Company;

        $trip = $company->driver()->where('id', $tripId)->first();

        if (!$trip) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }
        $trip->load('rate_driver');
        $rateTrips = $trip->rate_driver;
        return response()->json($rateTrips);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request ,$driver_id)
    {
        $user = auth()->user();
        // Get the rating value from the request (1-5)
        $rating = $request->input('num');
        // Validate the rating value
        if (!in_array($rating, range(1, 5))) {
            return response()->json(['error' => 'Invalid rating value'], 400);
        }
        // Get the trip ID from the request
        // Create a new rating instance
        $ratingInstance = new Rate_Driver();
        // Set the rating value, user ID, and trip ID
        $ratingInstance->rating = $rating;
        $ratingInstance->user_id = $user->id;
        $ratingInstance->driver_id = $driver_id;
        // Save the rating instance
        $ratingInstance->save();
        // Return a success response
        return response()->json(['message' => 'Rating submited successfully']);
    }

    /**
     * Display the specified resource.
     */
    public function show(Rate_Driver $rate_Driver)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function all_my_rate()
    {
        $driver =Auth::user()->Driver;

        $rating = Rate_Driver::where('driver_id',  $driver->id)
                        ->all();

        return response()->json($rating);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Rate_Driver $rate_Driver)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Rate_Driver $rate_Driver)
    {
        //
    }
}
