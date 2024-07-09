<?php

namespace App\Http\Controllers;

use App\Models\Profile;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class ProfileController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
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
            'image' => 'required|image',
            'phone' => 'required',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        try {
            $imageName = Str::random(32). '.'. $request->image->getClientOriginalExtension();
            $user = auth()->user();

            // Create Profile
            $profile = Profile::create([
                'user_id' => $user->id,
                'image' => $imageName,
                'phone' => $request->phone
            ]);

            // Save Image in Storage folder
            $request->image->storeAs('public/profile_image', $imageName);

            // Return Json Response
            return response()->json([
                'message' => "Image successfully set."
            ], 201);
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
    public function show(Profile $profile)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Profile $profile)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'image' => 'image',
            'phone' => 'required',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        try {
            $user = auth()->user();
            $profile = $user->profile;

            if (!$profile) {
                return response()->json(['error' => 'Profile not found'], 404);
            }

            if ($request->hasFile('image')) {
                $imageName = Str::random(32). '.'. $request->image->getClientOriginalExtension();
                $request->image->storeAs('public/profile_image', $imageName);
                $profile->image = $imageName;
            }

            $profile->phone = $request->phone;
            $profile->save();

            return response()->json([
                'message' => "Profile successfully updated."
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => "Something went really wrong!"
            ], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Profile $profile)
    {
        //
    }
}
