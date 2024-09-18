<?php

namespace App\Http\Controllers;

use App\Events\PrivateNotification;
use App\Models\Profile;
use App\Models\Reservation;
use App\Models\UserNotification;
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
        $user = Auth::with(['profile', 'address'])->user();
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


    /**
     * Show the form for creating a new resource.
     */
    public function my_reserva()
    {
        $user = Auth::user();
        $reservations = Reservation::where('user_id', $user->id)
            ->get();
        $data = [];

        foreach ($reservations as $reservation) {
            $busTrip = $reservation->pivoit->bus_trip; // Try to load the bus_trip relationship
            if ($busTrip) { // Check if the relationship is loaded successfully
                $seats = [];
                foreach ($reservation->seat_reservation as $seatReservation) {
                    $seats[] = [
                        'id' => $seatReservation->seat->id,
                        'status' => $seatReservation->seat->status
                    ];
                }
                $data[] = [
                    'id' => $reservation->id,
                    'price' => $reservation->price,
                    'type' => $reservation->type,
                    'status' => $reservation->status,
                    'break' => $reservation->pivoit->break_trip->break->name,
                    'from' => $busTrip->trip->path->from,
                    'to' => $busTrip->trip->path->to,
                    'seats' => $seats // array of seat names or properties
                ];
            } else {
                return response()->json([
                    'message' => 'bus_trip not found'
                ]);
            }
        }

        return response()->json($data);
    }

    public function my_reserva_by_status(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|in:pending,finished,out',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        $user = Auth::user();
        $reservations = Reservation::where('user_id', $user->id)
            ->where('status', $request->input('status'))
            ->get();
        $data = [];

        foreach ($reservations as $reservation) {
            $busTrip = $reservation->pivoit->bus_trip; // Try to load the bus_trip relationship
            if ($busTrip) { // Check if the relationship is loaded successfully
                $seats = [];
                foreach ($reservation->seat_reservation as $seatReservation) {
                    $seats[] = [
                        'id' => $seatReservation->seat->id,
                        'status' => $seatReservation->seat->status
                    ];
                }
                $typeTrip =  $reservation->type == 1 ? "going" : "outgoing";
                $start_time = new \DateTime($reservation->type == 1 ? $reservation->bus_trip->from_time_going : $reservation->bus_trip->from_time_return);
                $end_time =  new \DateTime($reservation->type == 1 ? $reservation->bus_trip->to_time_going : $reservation->bus_trip->to_time_return);
                $Date =  $reservation->type == 1 ? $reservation->bus_trip->date_start : $reservation->bus_trip->date_end;
                $startformattedTime = $start_time->format('H:i');
                $endformattedTime =  $end_time->format('H:i');
                $interval = $start_time->diff($end_time);
                $tripDuration = $interval->format('%H:%I');

                $data[] = [
                    'id' => $reservation->id,
                    'price' =>  $reservation->price,
                    'type' => $typeTrip,
                    'bustrip_id' => $busTrip->id,
                    'company_name' => $busTrip->trip->path->Company->user->name,
                    'Pickup_Point' => $reservation->pivoit->break_trip->break->name,
                    'from' => $busTrip->trip->path->from,
                    'to' => $busTrip->trip->path->to,
                    'Distance' => $busTrip->trip->path->Distance,
                    'start_time' => $startformattedTime,
                    'end_time' => $endformattedTime,
                    'trip_Duration' => $tripDuration,
                    'Date' => $Date,
                    'seats' => count($seats) // array of seat names or properties
                ];
            } else {
                return response()->json([
                    'message' => 'bus_trip not found'
                ]);
            }
        }

        return response()->json($data);
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

            $massage = "you added your profile:  $profile  user_id : $user->id ";
            event(new PrivateNotification($user->id, $massage));
            UserNotification::create([
                'user_id' =>  $user->id,
                'notification' => $massage,
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
            'image' => 'nullable|image',
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
                    Storage::delete('public/profile_image/' . $profile->image);
                }

                $imageName = Str::random(32) . '.' . $request->image->getClientOriginalExtension();
                $imageUrl = asset('storage/profile_image/' . $imageName);
                $request->image->storeAs('public/profile_image', $imageName);
                $profile->image = $imageUrl;
            }

            if ($request->filled('name')) {
                if ($user->Company) {
                    $user->Company->name_company = $request->input('name');
                }
                $user->name = $request->input('name');
            }
            if ($request->filled('email')) {
                $user->email = $request->input('email');
            }
            if ($request->filled('phone')) {
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



    //hamza
    public function getLocationOfSpecifcReservation($id)
    {

        $user = Auth::user();
        $reservation = Reservation::where('user_id', $user->id)
            ->where('id', $id)
            ->first();

        $locations = $reservation->bus_trip->trip->path->breaks->map(function ($brack) {
            return collect($brack->toArray())
                ->only(['name', 'latitude', 'longitude'])
                ->all();
        });
        return response()->json($locations);
    }
}
