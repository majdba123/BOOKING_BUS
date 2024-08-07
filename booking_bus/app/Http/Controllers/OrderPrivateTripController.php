<?php

namespace App\Http\Controllers;

use App\Models\Order_Private_trip;
use App\Models\Private_trip;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class OrderPrivateTripController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($private_trip_id)
    {
        $orderPrivateTrips = Order_Private_trip::where('private_trip_id', $private_trip_id)
                                              ->where('status', 'padding')
                                              ->get();

        return response()->json($orderPrivateTrips);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function accept($order_private_id)
    {
        // Get the Order_Private_trip model
        $orderPrivate = Order_Private_trip::find($order_private_id);

        // Check if the order private trip exists
        if (!$orderPrivate) {
            return response()->json(['error' => 'Order private trip not found'], 404);
        }

        // Get the authenticated user
        $user = Auth::user();
            // Check if the user is the same as the owner of the private trip

        if ($user->id != $orderPrivate->private_trip->user->id) {
            return response()->json(['error' => 'You cannot accept your own private trip'], 403);
        }

        // Check if the user has enough points
        if ($user->point < $orderPrivate->price) {
            return response()->json(['error' => 'You do not have enough points'], 403);
        }

        // Calculate the points to be deducted from the user
        $pointsToDeduct = $orderPrivate->price;
        $user->point -= $pointsToDeduct;
        $user->save();

        $companyUser = $orderPrivate->company->user;
        // Add points to the company user
        $companyUser->point += $pointsToDeduct;
        $companyUser->save();
        // Check if there's a discount


        // Get the company user

        // Update the order private trip status
        $orderPrivate->status = 'accepted';
        $orderPrivate->private_trip->status = 'completed';
        $orderPrivate->save();
        $orderPrivate->private_trip->save();
        $otherOrderPrivates = Order_Private_trip::where('private_trip_id', $orderPrivate->private_trip_id)
        ->where('status', 'padding')
        ->get();
    // Cancel all other order privates with status "padding"
        foreach ($otherOrderPrivates as $otherOrderPrivate) {
            $otherOrderPrivate->status = 'cancelled';
            $otherOrderPrivate->save();
        }

        return response()->json(['message' => 'Order private trip accepted successfully']);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request, $private_trip_id)
    {
        $validatedData = $request->validate([

            'price' => 'required|numeric',

        ]);
        $company_id = Auth::user()->Company->id;
        if (Order_Private_trip::where('company_id', $company_id)
        ->where('private_trip_id', $private_trip_id)
        ->exists()) {
        return response()->json(['error' => 'Company has already accepted this private trip'], 422);
        }

        $privateTrip = Private_trip::findOrFail($private_trip_id);

        $order = New Order_Private_trip();
        $order->private_trip_id = $privateTrip->id;
        $order->company_id = $company_id;
        $order->price = $request->input('price');

        $order->save();

        return response()->json($order);
    }
    /**
     * Display the specified resource.
     */
    public function show(Order_Private_trip $order_Private_trip)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function my_orders()
    {
        $company_id = Auth::user()->Company->id;
        $orders = Order_Private_trip::whereHas('company', function ($query) use ($company_id) {
            $query->where('id', $company_id);
        })->with('private_trip')->get();
        return $orders;
    }
    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Order_Private_trip $order_Private_trip)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Order_Private_trip $order_Private_trip)
    {
        //
    }
}
