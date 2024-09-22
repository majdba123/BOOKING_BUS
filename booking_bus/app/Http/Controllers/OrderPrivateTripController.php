<?php

namespace App\Http\Controllers;

use App\Events\PrivateNotification;
use App\Models\CappingPricingModel;
use App\Models\DecreasingProportionalModel;
use App\Models\FixedPricingModel;
use App\Models\Order_Private_trip;
use App\Models\Private_trip;
use App\Models\ProportionalPricingModel;
use App\Models\UserNotification;
use Exception;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class OrderPrivateTripController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($private_trip_id)
    {
        $orderPrivateTrips = Order_Private_trip::where('private_trip_id', $private_trip_id)
            ->where('status', 'pending')
            ->get();
        if ($orderPrivateTrips->isEmpty()) {
            return response()->json([
                'message' => 'No companies have accepted the order yet.'
            ],); // You can choose a different status code if needed
        }
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
        if ($user->point < $orderPrivate->pricing->cost) {
            return response()->json(['error' => 'You do not have enough points'], 403);
        }

        // Calculate the points to be deducted from the user
        $pointsToDeduct = $orderPrivate->pricing->cost;
        $user->point -= $pointsToDeduct;
        $user->save();

        $companyUser = $orderPrivate->company->user;
        // Add points to the company user
        $companyUser->point += $pointsToDeduct;
        $companyUser->save();


        $massage = " User accept your for its  private trip  your order private $orderPrivate->id ";
        event(new PrivateNotification($companyUser->id, $massage));
        UserNotification::create([
            'user_id' => $companyUser->id,
            'notification' => $massage,
        ]);
        // Check if there's a discount


        // Get the company user

        // Update the order private trip status
        $orderPrivate->status = 'accepted';
        $orderPrivate->private_trip->status = 'completed';
        $orderPrivate->save();
        $orderPrivate->private_trip->save();
        $otherOrderPrivates = Order_Private_trip::where('private_trip_id', $orderPrivate->private_trip_id)
            ->where('status', 'pending')
            ->get();
        // Cancel all other order privates with status "pending"
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
        DB::beginTransaction();

        try {
            $validatedData = $request->validate([

                'pricing_type' => 'required|string',
            ]);

            $company_id = Auth::user()->Company->id;

            if (Order_Private_trip::where('company_id', $company_id)
                ->where('private_trip_id', $private_trip_id)
                ->exists()
            ) {
                DB::rollBack();
                return response()->json(['error' => 'Company has already accepted this private trip'], 422);
            }

            $privateTrip = Private_trip::findOrFail($private_trip_id);

            $order = new Order_Private_trip();
            $order->private_trip_id = $privateTrip->id;
            $order->company_id = $company_id;
            $pricingModelInstance = $this->createPricingModel($request->input('pricing_type'), $request);
            $order->pricing()->associate($pricingModelInstance); //polymorphic reation   hamza
            $order->save();
            // $order->price = $request->input('price');

            $company_name = Auth::user()->Company;
            $massage = " company $company_name->name accept your private trip ";
            event(new PrivateNotification($privateTrip->user->id, $massage));
            UserNotification::create([
                'user_id' => $privateTrip->user->id,
                'notification' => $massage,
            ]);
            $order->save();

            DB::commit();

            return response()->json($order);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'An error occurred while storing order'], 500);
        }
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
    public function createPricingModel($pricingType, Request $request)
    {
        switch ($pricingType) {
            case 'fixed':
                // Create FixedPricingModel
                return FixedPricingModel::create([
                    'cost' => $request->input('cost'),
                ]);

            case 'proportional':
                // Create ProportionalPricingModel
                return ProportionalPricingModel::create([
                    'RatePerKm' => $request->input('rate_of_km'),
                    'cost' => $request->input('cost'),
                ]);

            case 'decreasing':
                // Create DecreasingProportionalModel
                return DecreasingProportionalModel::create([
                    'number_of_station' => $request->input('number_of_station'),
                    'Rate_of_Km' => $request->input('rate_of_km'),
                    'min_price_for_Km' => $request->input('min_price_for_km'),
                    'cost' => $request->input('cost'),
                ]);

            case 'capping':
                // Create CappingPricingModel
                return CappingPricingModel::create([
                    'number_of_station' => $request->input('number_of_station'),
                    'Rate_of_Km' => $request->input('rate_of_km'),
                    'max_price_for_Km' => $request->input('max_price_for_km'),
                    'cost' => $request->input('cost'),
                ]);

            default:
                throw new Exception("Invalid pricing type");
        }
    }
}
