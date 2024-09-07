<?php

namespace App\Http\Controllers;

use App\Models\Charge_Balance;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use App\Events\PrivateNotification;
use App\Models\UserNotification;

class ChargeBalanceController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $chargeBalances = Charge_Balance::where('status', 'padding')->get();

        $data = [];
        foreach ($chargeBalances as $chargeBalance) {
            $data[] = [
                'id' => $chargeBalance->id,
                'user_id' => $chargeBalance->user_id,
                'point' => $chargeBalance->point,
                'image' => $chargeBalance->image,
                'status' => $chargeBalance->status,
            ];
        }

        return response()->json($data, 200);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function index1(Request $request)
    {
        $status = $request->query('status');
        $chargeBalances = Charge_Balance::where('status', $status)->get();
        $data = [];
        foreach ($chargeBalances as $chargeBalance) {
            $data[] = [
                'id' => $chargeBalance->id,
                'user_id' => $chargeBalance->user_id,
                'point' => $chargeBalance->point,
                'image' => $chargeBalance->image,
                'status' => $chargeBalance->status,
            ];
        }
        return response()->json($data, 200);
    }
    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'image' => 'required|image',
            'point' => 'required',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        try {
            $imageName = Str::random(32) . "." . $request->image->getClientOriginalExtension();
            $imageUrl = asset('storage/order_balance/' . $imageName);
            $user = auth()->user();
            // Create Post
            Charge_Balance::create([
                'user_id' => $user->id,
                'image' => $imageUrl,
                'point' => $request->point
            ]);

            // Save Image in Storage folder
            $request->image->storeAs('public/order_balance', $imageName);

            // Return Json Response
            return response()->json([
                'message' => "Post successfully created."
            ], 200);
        } catch (\Exception $e) {
            // Return Json Response
            return response()->json([
                'message' => "Something went really wrong!"
            ], 500);
        }
    }
    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $chargeBalance = Charge_Balance::find($id);

        if (!$chargeBalance) {
            return response()->json(['error' => 'Not found'], 404);
        }

        $data = [
            'id' => $chargeBalance->id,
            'user_id' => $chargeBalance->user_id,
            'point' => $chargeBalance->point,
            'image' => $chargeBalance->image,
            'status' => $chargeBalance->status,
        ];

        return response()->json($data, 200);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function all_my_charge_balance()
    {
        $user = Auth::user();

        $chargeBalance = Charge_Balance::where('user_id', $user->id)->get();
        if (!$chargeBalance) {
            return response()->json(['error' => 'Not found'], 404);
        }

        return response()->json($chargeBalance);
    }

    public function all_my_charge_balance_by_status(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|in:padding,completed',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        $user = Auth::user();

        $chargeBalance = Charge_Balance::where('user_id', $user->id)
            ->where('status', $request->input('status'))
            ->get();
        if (!$chargeBalance) {
            return response()->json(['error' => 'Not found'], 404);
        }

        return response()->json($chargeBalance);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Charge_Balance $charge_Balance) {}

    /**
     * Remove the specified resource from storage.
     */
    public function accepted($id)
    {
        $chargeBalance = Charge_Balance::find($id);
        if (!$chargeBalance) {
            return response()->json(['error' => 'Not found'], 404);
        }
        if ($chargeBalance->status != 'padding') {
            return response()->json(['error' => 'not padding'], 404);
        }
        $chargeBalance->status = 'completed';
        $chargeBalance->save();

        $user = $chargeBalance->user; // assuming you have a user relationship in Charge_Balance model
        $points = $chargeBalance->point; // assuming you have a points attribute in Charge_Balance model

        $user->point += $points; // add the points to the user's points
        $user->save();
        $user_id = $user->id;
        $massage = "your status of charage balance update to  : $chargeBalance->status";

        event(new PrivateNotification($user_id, $massage));
        UserNotification::create([
            'user_id' =>$user_id,
            'notification' => $massage,
        ]);
        return response()->json(['message' => 'Charge balance status updated to completed and points added to user'], 200);
    }

    public function cancelled($id)
    {
        $chargeBalance = Charge_Balance::find($id);
        if (!$chargeBalance) {
            return response()->json(['error' => 'Not found'], 404);
        }
        if ($chargeBalance->status != 'padding') {
            return response()->json(['error' => 'not padding'], 404);
        }
        $user = $chargeBalance->user; // assuming you have a user relationship in Charge_Balance model

        $chargeBalance->status = 'cancelled';
        $chargeBalance->save();
        $user_id = $user->id;
        $massage = "your status of charage balance update to  : $chargeBalance->status";
        event(new PrivateNotification($user_id, $massage));
        UserNotification::create([
            'user_id' =>$user_id,
            'notification' => $massage,
        ]);
        return response()->json(['message' => 'Charge balance status updated to cancelled'], 200);
    }
}
