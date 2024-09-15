<?php

namespace App\Http\Controllers;

use App\Models\Address;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

class AddressController extends Controller
{
    /**
     * Display a listing of the resource.
     */
 /*   public function index()
    {
        $user = Auth::user()->id;
        $addresses = Address::where('user_id', $user)->get();
        return response()->json($addresses);
    }*/
    public function index()
    {
        $user = Auth::user()->id;
        $key = 'user_addresses_' . $user; // Create a unique cache key for each user
        // Check if the data is already cached
        if (Cache::has($key)) {
            $addresses = Cache::get($key);
        } else {
            // If not, retrieve the data from the database and cache it
            $addresses = Address::where('user_id', $user)->get();
            Cache::put($key, $addresses, now()->addMinutes(30)); // Cache for 30 minutes
        }
        if ($addresses->isEmpty()) {
            return response()->json(['message' => 'No addresses found'], 404);
        }
        return response()->json($addresses);
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
            'city' => 'required|string|max:255',
            'area' => 'required|string|max:255',
        ]);
        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        $address = new Address();
        $address->user_id = Auth::user()->id;
        $address->city = $request->input('city');
        $address->area = $request->input('area');
        $address->save();
        $key = 'user_addresses_' . Auth::user()->id;
        Cache::put($key, $address, now()->addMinutes(30)); // Cache for 30 minutes

        return response()->json([
            'message' => "Address saved",
            'address' => $address,
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(Address $address)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Address $address)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $user = Auth::user()->id;
        $key = 'user_addresses_' . $user;
        $address = Address::with('user')->find($id);
        if (!$address) {
            return response()->json(['error' => 'Address not found'], 404);
        }
        // Check if the user updating the address is the same user who owns the address
        if ($address->user_id !== $user) {
            return response()->json(['error' => 'You are not authorized to update this address'], 403);
        }
        DB::beginTransaction();
        try {
            if ($request->has('city')) {
                $validator = Validator::make(['city' => $request->input('city')], [
                    'city' => 'string|max:255',
                ]);
                if ($validator->fails()) {
                    $errors = $validator->errors()->first();
                    DB::rollBack();
                    return response()->json(['error' => $errors], 422);
                }
                $address->city = $request->input('city');
            }
            if ($request->has('area')) {
                $validator = Validator::make(['area' => $request->input('area')], [
                    'area' => 'string|max:255',
                ]);
                if ($validator->fails()) {
                    $errors = $validator->errors()->first();
                    DB::rollBack();
                    return response()->json(['error' => $errors], 422);
                }
                $address->area = $request->input('area');
            }
            $address->save();
            if (Cache::has($key)) {
                $addresses = Cache::get($key);
                $addresses = $addresses->map(function ($item) use ($address) {
                    if ($item->id === $address->id) {
                        return $address;
                    }
                    return $item;
                });
                Cache::put($key, $addresses, now()->addMinutes(30)); // Cache for 30 minutes
                Cache::forget('user_data_' . auth()->id());
            }
            DB::commit();
            return response()->json($address);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'An error occurred while updating the address'], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Address $address)
    {
        //
    }
}
/**
 * , I've used eager loading in the update method to load the user relationship with the Address model
 */
