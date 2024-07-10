<?php

namespace App\Http\Controllers;

use App\Models\Charge_Balance;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
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
            $imagePath = Storage::disk('public')->url($chargeBalance->image);
            $data[] = [
                'id' => $chargeBalance->id,
                'user_id' => $chargeBalance->user_id,
                'point' => $chargeBalance->point,
                'image' => $imagePath,
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
            $imagePath = Storage::disk('public')->url($chargeBalance->image);
            $data[] = [
                'id' => $chargeBalance->id,
                'user_id' => $chargeBalance->user_id,
                'point' => $chargeBalance->point,
                'image' => $imagePath,
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
            $imageName = Str::random(32).".".$request->image->getClientOriginalExtension();
            $imageUrl = asset('storage/order_balance' . $imageName);
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
            ],200);
        } catch (\Exception $e) {
            // Return Json Response
            return response()->json([
                'message' => "Something went really wrong!"
            ],500);
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

        $imagePath = Storage::disk('public')->url($chargeBalance->image);

        $data = [
            'id' => $chargeBalance->id,
            'user_id' => $chargeBalance->user_id,
            'point' => $chargeBalance->point,
            'image' => $imagePath,
            'status' => $chargeBalance->status,
        ];

        return response()->json($data, 200);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Charge_Balance $charge_Balance)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Charge_Balance $charge_Balance)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function accepted($id)
    {
        $chargeBalance = Charge_Balance::find($id);
        if (!$chargeBalance) {
            return response()->json(['error' => 'Not found'], 404);
        }
        $chargeBalance->status = 'completed';
        $chargeBalance->save();
        return response()->json(['message' => 'Charge balance status updated to completed'], 200);
    }

    public function cancelled($id)
    {
        $chargeBalance = Charge_Balance::find($id);
        if (!$chargeBalance) {
            return response()->json(['error' => 'Not found'], 404);
        }
        $chargeBalance->status = 'cancelled';
        $chargeBalance->save();
        return response()->json(['message' => 'Charge balance status updated to cancelled'], 200);

    }
}
