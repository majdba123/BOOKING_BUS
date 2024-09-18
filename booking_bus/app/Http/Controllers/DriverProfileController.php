<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Str;
use App\Models\Profile;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Storage;

class DriverProfileController extends Controller
{
    public function index()
    {
        $user = auth()->user()->load(['profile', 'address']);
        $profileImage = $user->profile ? $user->profile->image : null;
        $phoneNumber = $user->profile ? $user->profile->phone : null;

        // Construct the response
        $response = [
            'id' => $user->id,
            'name' => $user->name,
            // 'type' => $user->type,
            'email' => $user->email,
            'point' => $user->point,
            'profile_image' => $profileImage,
            'phoneNumber' => $phoneNumber,
            // 'address' => $user->address
        ];
        return response()->json($response);
    }
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
            $imageName = Str::random(32) . '.' . $request->image->getClientOriginalExtension();
            $user = auth()->user();
            if ($user->profile) {
                return response()->json([
                    'message' => "Sorry, you already have a profile."
                ], 403);
            }
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


    public function update(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'image' => 'required|image',
            'phone' => 'sometimes|required',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        try {
            $user = auth()->user();
            $profile = $user->profile;

            if ($request->hasFile('image')) {
                $imageName = Str::random(32) . '.' . $request->image->getClientOriginalExtension();
                $imageUrl = asset('storage/profile_image/' . $imageName);

                // Delete existing image
                if ($profile->image && file_exists(public_path($profile->image))) {
                    unlink(public_path($profile->image));
                }

                // Create Profile
                $profile->update([
                    'image' => $imageUrl,
                    'phone' => $request->phone
                ]);

                // Store Image in public/profile_image directory
                $request->image->move(public_path('profile_image'), $imageName);
            } else {
                $profile->update([
                    'phone' => $request->phone
                ]);
            }
            Cache::forget('user_data_' . auth()->id());
            // Return Json Response
            return response()->json([
                'message' => "Profile successfully updated."
            ], 200);
        } catch (\Exception $e) {
            // Return Json Response
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
        Cache::forget('user_data_' . auth()->id());
        return response()->json(['message' => 'Password updated successfully'], 200);
    }
}
