<?php

namespace App\Http\Controllers;

use App\Models\Address;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class AddressController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $user = Auth::user()->id;
        $addresses = Address::where('user_id', $user)->get();
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
        $user =Auth::user()->id;
        $validator = Validator::make($request->all(), [
            'city' => 'required|string|max:255', // validate city is a string with max length 255
            'area' => 'required|string|max:255', // validate area is a string with max length 255
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        $address = New  Address();
        $address->user_id = $user;
        $address->city = $request->input('city');
        $address->area = $request->input('area');
        $address->save();


        return response()->json([
            'message' => "address saved"
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
        $address = Address::find($id);

        if (!$address) {
            return response()->json(['error' => 'Address not found'], 404);
        }

        // Check if the user updating the address is the same user who owns the address
        if ($address->user_id !== $user) {
            return response()->json(['error' => 'You are not authorized to update this address'], 403);
        }

        // Only validate and update fields that are present in the request
        if ($request->has('city')) {
            $validator = Validator::make(['city' => $request->input('city')], [
                'city' => 'string|max:255',
            ]);

            if ($validator->fails()) {
                $errors = $validator->errors()->first();
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
                return response()->json(['error' => $errors], 422);
            }

            $address->area = $request->input('area');
        }

        $address->save();

        return response()->json($address);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Address $address)
    {
        //
    }
}
