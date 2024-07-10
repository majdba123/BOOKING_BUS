<?php

namespace App\Http\Controllers;

use App\Models\Profile;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\RedirectResponse;

class ProfileController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $user = auth()->user()->load(['profile', 'address']);

        return response()->json($user);
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
            $imageUrl = asset('storage/profile_image/' . $imageName);
            // Create Profile
            $profile = Profile::create([
                'user_id' => $user->id,
                'image' => $imageUrl,
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
            'image' => 'required|image',
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|email|max:255',
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
                // Delete old image
                if ($profile->image) {
                    Storage::delete('public/profile_image/'. $profile->image);
                }

                $imageName = Str::random(32). '.'. $request->image->getClientOriginalExtension();
                $request->image->storeAs('public/profile_image', $imageName);
                $profile->image = $imageName; // Store the filename instead of the URL
            }
            if ($request->input('name')) {
                $user->name = $request->input('name');
            }
            if ($request->input('email')) {
                $user->email = $request->input('email');
            }
            if ($request->input('phone')) {
                $profile->phone = $request->input('phone');
            }

            $user->save();
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


    public function update_password(Request $request)
    {
        $user = Auth::user();

        $validatedData = Validator::make($request->all(), [
            'current_password' => ['required', function ($attribute, $value, $fail) use ($user) {
                if (!Hash::check($value, $user->password)) {
                    $fail(__('The current password is incorrect.'));
                }
            }],
            'new_password' => ['required', 'min:8', 'confirmed'],
        ]);

        if ($validatedData->fails()) {
            return response()->json(['error' => $validatedData->messages()], 422);
        }

        $user->password = Hash::make($request->new_password);
        $user->save();

        return response()->json(['message' => 'Password updated successfully'], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Profile $profile)
    {
        //
    }
}
