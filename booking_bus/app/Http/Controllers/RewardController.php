<?php

namespace App\Http\Controllers;

use App\Models\Policy\Reward\Reward;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class RewardController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $rewards = Reward::all();
        return response()->json($rewards);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
{
    // Validate input
    $validator = Validator::make($request->all(), [
        'Reservation_Costs' => 'required|numeric|min:0',
        'reward_percentage' => 'required|numeric|min:0|max:100',
    ]);

    if ($validator->fails()) {
        return response()->json(['error' => $validator->errors()], 422);
    }

    // Get company_id from authenticated user
    $user = auth()->user();
    // print($user);
    $companyId = $user->company->id;

    // Create a new reward
    $reward = Reward::create([
        'company_id' => $companyId,
        'Reservation_Costs' => $request->input('Reservation_Costs'),
        'reward_percentage' => $request->input('reward_percentage'),
    ]);

    return response()->json(['message' => 'Reward created successfully'], 200);
}

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $reward = Reward::find($id);
        if (!$reward) {
            return response()->json(['message' => 'Reward not found'], 404);
        }
        return response()->json($reward);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {

    $reward = Reward::find($id);
    if (!$reward) {
        return response()->json(['message' => 'Reward not found'], 404);
    }

    $user = auth()->user();
    // print($user);
    $companyId = $user->company->id;


    $validator = Validator::make($request->all(), [
        'Reservation_Costs' => 'required|numeric|min:0',
        'reward_percentage' => 'required|numeric|min:0|max:100',
    ]);

    if ($validator->fails()) {
        return response()->json(['error' => $validator->errors()], 422);
    }

    if ($reward->company_id !== $companyId) {
        return response()->json(['message' => 'Unauthorized to update this reward'], 403);
    }


    $reward->update($request->all());

    return response()->json(['message' => 'Reward updated successfully']);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $reward = Reward::find($id);
        if (!$reward) {
            return response()->json(['message' => 'Reward not found'], 404);
        }

        $reward->delete();
        return response()->json(['message' => 'Reward deleted successfully']);
    }
}
