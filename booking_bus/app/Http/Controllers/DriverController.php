<?php

namespace App\Http\Controllers;

use App\Models\Driver;
use Illuminate\Http\Request;
use App\Models\Pivoit;
use App\Models\Bus_Driver;
use App\Models\Reservation;
use App\Models\Bus_Trip;
use App\Models\user;
use App\Events\BreakTripEvent;
use App\Events\PrivateNotification;
use App\Models\Trip;
use App\Models\UserNotification;
use Exception;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;


class DriverController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $company = Auth::user()->Company->id;

        $drivers = Driver::where('company_id', $company)->get();
        $info = [];
        foreach ($drivers as $driver) {
            $data = [
                'name' => $driver->user->name,
                'user_id' => $driver->user->id,
                'driver_id' => $driver->id,
                'company_id' => $driver->company->id,
                'status' =>  $driver->status,
                'email_driver' => $driver->user->email,
            ];
            $info[] = $data;
        }
        return response()->json($info, 200);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function register_driver(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'name' => ['required', 'string'],
            'email' => ['required', 'string', 'email', 'unique:users'],
            'password' => ['required', 'min:8'],
        ], [
            'name.required' => 'Name is required',
            'email.required' => 'Email is required',
            'email.email' => 'Email is invalid',
            'email.unique' => 'Email has already been taken',
            'password.required' => 'Password is required',
            'password.min' => 'Password must be at least 8 characters long',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->messages()], 422);
        }

        $user = User::create([
            'name' => $request->input('name'),
            'email' => $request->input('email'),
            'password' => Hash::make($request->input('password')),
        ]);

        $id = $user->id;
        $company_id = Auth::user()->Company;

        #return response()->json($id);

        $driver = Driver::create([
            'user_id' => $id,
            'company_id' => $company_id->id,
        ]);
        $drivaer_name = $driver->user->name;


        $massage = "Oh great, another driver registered: $drivaer_name";
        event(new PrivateNotification($company_id->user->id, $massage));
        UserNotification::create([
            'user_id' => $company_id->user->id,
            'notification' => $massage,
        ]);

        $admins = User::where('type', 1)->get();
        foreach ($admins as $admin) {
            $admin_id = $admin->id;
            // Send the message to each admin using the $admin_id
            $massage = "  REGISTERD NEW DRIVER   : $driver->id  by company: $company_id->id ";
            event(new PrivateNotification($admin_id, $massage));
            UserNotification::create([
                'user_id' => $admin_id,
                'notification' => $massage,
            ]);
        }

        return response()->json([
            'message' => 'driver Created ',
        ]);
    }
    /**
     * Store a newly created resource in storage.
     */
    public function get_driver_by_status(Request $request)
    {
        $company = Auth::user()->Company->id;
        $drivers = Driver::where('company_id', $company)
            ->where('status', $request->input('status'))
            ->get();

        $customData = $drivers->map(function ($driver) {
            return [
                'name' => $driver->user->name,
                'user_id' => $driver->user->id,
                'driver_id' => $driver->id,
                'company_id' => $driver->company->id,
                'status' =>  $driver->status,
                'email_driver' => $driver->user->email,
            ];
        });

        return response()->json($customData, 200);
    }

    /**
     * Display the specified resource.
     */
    public function show(Driver $driver)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Driver $driver)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Driver $driver)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $company = Auth::user()->Company->id;

        $driver = Driver::find($id);
        // Check if the bus belongs to the same company as the authenticated user
        if ($driver->company_id !== $company) {
            return response()->json(['error' => 'Unauthorized to delete driver'], 403);
        }
        $pendingBusDrivers = Bus_Driver::where('driver_id', $id)
            ->where('status', 'pending')
            ->first();
        if ($pendingBusDrivers) {
            $pendingBusDrivers->status = 'cancelled';
            $pendingBusDrivers->save();
            $bus = $pendingBusDrivers->bus;
            $bus->status = 'available';
            $bus->save();
            $user_driver = $driver->user;
            $user_driver->delete();
        } else {
            $user_driver = $driver->user;
            $user_driver->delete();
        }


        return response()->json([
            'message' => 'driver_deleted',
        ]);
    }

    public function my_bus()
    {
        $driver = Auth::user()->Driver;

        $bus = Bus_Driver::where('status', 'pending')
            ->where('driver_id', $driver->id)->first();

        $info = $bus->bus;
        $data = [
            'id_bus' => $info->id,
            'company_id' => $info->company_id,
            'company_name' => $info->company->name_company,
            'number_bus' => $info->number_bus,
            'number_passenger' => $info->number_passenger,
            'status' => $info->status,
        ];
        return response()->json($data);
    }

    public function history()
    {
        $driver = Auth::user()->Driver;

        if (!$driver) {
            return response()->json(['error' => 'Driver not found'], 404);
        }

        $bus = Bus_Driver::where('driver_id', $driver->id)
            ->first();
        if (!$bus) {
            return response()->json(['error' => 'No Trpis found for the you'], 404);
        }
        // print($bus);
        $trips = Bus_Trip::where('status', '<>', 'pending')
            ->where('bus_id', $bus->bus_id)
            ->get();

        if ($trips->isEmpty()) {
            return response()->json(['error' => 'No  history was found for You'], 404);
        }

        $response = [];

        foreach ($trips as $trip) {
            // Load related data for each trip
            $trip->load(['trip.path', 'Pivoit.Reservation.user']);

            $fromTime = new \DateTime($trip->from_time_going);
            $toTime = new \DateTime($trip->to_time_return);
            $interval = $fromTime->diff($toTime);
            $tripDuration = $interval->format('%H:%I');
            $response[] = [
                'id' => $trip->id,
                'bus_id' => $trip->bus_id,
                'from' => $trip->trip->path->from ?? null,
                'to' => $trip->trip->path->to ?? null,
                'from_time_going' => $trip->from_time_going,
                'to_time_going' => $trip->to_time_going,
                'from_time_return' => $trip->from_time_return,
                'to_time_return' => $trip->to_time_return,
                'date_end' => $trip->date_end,
                'date_start' => $trip->date_start,

                // 'distance' => $trip->trip->path->Distance ?? null,
                // 'from_lat' => $trip->trip->path->from_latitude ?? null,
                // 'from_long' => $trip->trip->path->from_longitude ?? null,
                // 'to_lat' => $trip->trip->path->to_latitude ?? null,
                // 'to_long' => $trip->trip->path->to_longitude ?? null,
                // 'number_of_seat_in_bus' => $trip->bus->number_passenger,
                'Passengers' => $trip->bus->getNumberOfReservationsAttribute(),
                'Stops' => $trip->Pivoit->count(),
                'trip_duration' => $tripDuration,
                // 'event' => $trip->event,
                'status' => $trip->status,
                // 'breaks_data' => $pivotData,
            ];
        }

        return response()->json($response);
    }
    public function my_pending_trip()
    {
        $driver = Auth::user()->Driver;

        if (!$driver) {
            return response()->json(['error' => 'Driver not found'], 404);
        }

        $bus = Bus_Driver::where('status', 'pending')
            ->where('driver_id', $driver->id)
            ->first();

        if (!$bus) {
            return response()->json(['error' => 'No pending bus found for the driver'], 404);
        }
        // print($bus);
        $trips = Bus_Trip::where('bus_id', $bus->bus_id)
            // where('status', 'pending')
            // ->
            ->get();

        if ($trips->isEmpty()) {
            return response()->json(['error' => 'No pending trips found for the bus'], 404);
        }

        $response = [];

        foreach ($trips as $trip) {
            // Load related data for each trip
            $trip->load(['trip.path', 'Pivoit.Reservation.user']);
            $fromTime = new \DateTime($trip->from_time_going);
            $toTime = new \DateTime($trip->to_time_return);

            $goingfromTime = new \DateTime($trip->from_time_going);
            $goingtoTime = new \DateTime($trip->to_time_going);
            $ReturnfromTime = new \DateTime($trip->from_time_return);
            $ReturntoTime = new \DateTime($trip->to_time_return);
            $GoingformattedFromTime = $goingfromTime->format('H:i');
            $GoingformattedToTime =  $goingtoTime->format('H:i');
            $RetuenformattedFromTime = $ReturnfromTime->format('H:i');
            $RetuenformattedToTime =  $ReturntoTime->format('H:i');
            $interval = $goingfromTime->diff($goingtoTime);
            $tripDuration = $interval->format('%H:%I');
            $response[] = [
                'id' => $trip->id,
                'bus_id' => $trip->bus_id,
                'from' => $trip->trip->path->from ?? null,
                'to' => $trip->trip->path->to ?? null,
                'goingfromTime' => $GoingformattedFromTime,
                'goingtoTime' => $GoingformattedToTime,
                'ReturnfromTime' => $RetuenformattedFromTime,
                'ReturntoTime' => $RetuenformattedToTime,
                'date_start' => $trip->date_start,
                'date_end' => $trip->date_end,
                'Distance' => $trip->trip->path->Distance ?? null,
                // 'from_lat' => $trip->trip->path->from_latitude ?? null,
                // 'from_long' => $trip->trip->path->from_longitude ?? null,
                // 'to_lat' => $trip->trip->path->to_latitude ?? null,
                // 'to_long' => $trip->trip->path->to_longitude ?? null,
                // 'number_of_seat_in_bus' => $trip->bus->number_passenger,
                'Passengers' => $trip->bus->getNumberOfReservationsAttribute(),
                'Stops' => $trip->Pivoit->count(),
                'trip_duration' => $tripDuration,
                // 'event' => $trip->event,
                'status' => $trip->status,
                // 'breaks_data' => $pivotData,
            ];
        }

        return response()->json($response);
    }
    public function specificPendingTrip($bus_trip_id)
    {
        $driver = Auth::user()->Driver;

        if (!$driver) {
            return response()->json(['error' => 'Driver not found'], 404);
        }

        $bus = Bus_Driver::where('status', 'pending')
            ->where('driver_id', $driver->id)
            ->first();

        if (!$bus) {
            return response()->json(['error' => 'No pending bus found for the driver'], 404);
        }
        // print($bus);
        $trip = Bus_Trip::where('id', $bus_trip_id)
            ->first();

        if (!$trip) {
            return response()->json(['error' => 'No pending trip found for the bus'], 404);
        }
        // print($trip);
        $pivotData = [];
        foreach ($trip->Pivoit as $pivoit) {
            $break = $pivoit->break_trip->break;
            // $reservations = $pivoit->Reservation;

            // $formattedReservations = $reservations->map(function ($reservation) {
            // return
            //         // 'reservation_id' => $reservation->id,
            //         // 'user_id' => $reservation->user_id,
            // $reservation->user ? $reservation->user->name : 'Unknown';

            //     // 'price' => $reservation->price,
            //     // 'status' => $reservation->status,

            // })->toArray();

            $pivotData[] = [
                'break_id' => (int)$break->id,
                'break_name' => $break->name,
                // 'status' => $pivoit->status,
                'latitude' => doubleval($break->latitude),
                'longitude' => doubleval($break->longitude),
                'passengers_count' => $pivoit->Reservation->count(),
                'pivoit_id' => $pivoit->id,
                // 'reservations' => $formattedReservations,
            ];
        }

        $goingfromTime = new \DateTime($trip->from_time_going);
        $goingtoTime = new \DateTime($trip->to_time_going);
        $ReturnfromTime = new \DateTime($trip->from_time_return);
        $ReturntoTime = new \DateTime($trip->to_time_return);
        $GoingformattedFromTime = $goingfromTime->format('H:i');
        $GoingformattedToTime =  $goingtoTime->format('H:i');
        $RetuenformattedFromTime = $ReturnfromTime->format('H:i');
        $RetuenformattedToTime =  $ReturntoTime->format('H:i');
        $interval = $goingfromTime->diff($goingtoTime);
        $tripDuration = $interval->format('%H:%I');
        $trip->load(['trip.path']);
        // $trip->load(['Bus_Trip.bus']);
        $response = [
            'bus_trip_id' => $trip->id,
            'bus_id' => $trip->bus_id,
            // 'from' => $trip->trip->path->from ?? null,
            // 'to' => $trip->trip->path->to ?? null,
            // 'from_time' => $trip->from_time,
            // 'to_time' => $trip->to_time,
            // 'date' => $trip->date,
            // 'Distance' => $trip->trip->path->Distance ?? null,
            'from_lat' =>  doubleval($trip->trip->path->from_latitude) ?? null,
            'from_long' => doubleval($trip->trip->path->from_longitude) ?? null,
            'to_lat' => doubleval($trip->trip->path->to_latitude) ?? null,
            'to_long' => doubleval($trip->trip->path->to_longitude) ?? null,
            // 'tripDuration' => $tripDuration,
            // 'number_of_seat_in_bus' => $trip->bus->number_passenger,
            // 'Stops' => $trip->Pivoit()->count(),
            // 'Passengers' =>  $trip->bus->getNumberOfReservationsAttribute(),
            // 'event' => $trip->event,
            // 'status' => $trip->status,
            'breaks_data' => $pivotData,


        ];

        return response()->json($response);
    }


    public function start_trip()
    {
        DB::beginTransaction();
        try {
            $driver = Auth::user()->Driver;

            $bus = Bus_Driver::where('status', 'pending')
                ->where('driver_id', $driver->id)
                ->first();



            $bus_trip22 = Bus_Trip::where('status', 'finished_going')
                ->where('bus_id', $bus->bus_id)
                ->first();

            if ($bus_trip22) {
                return response()->json(['error' => 'An error occurred while starting the trip because you are in trip already'], 500);
            }

            $bus_trip = Bus_Trip::where('status', 'pending')
                ->where('bus_id', $bus->bus_id)
                ->first();

            $name_breaks = $bus_trip->Pivoit->where('status', 'pending')->pluck('break_trip.break.name');

            if ($name_breaks->first() === "start") {
                $bus_trip->event = $name_breaks->first();
                $bus_trip->save();
                $pivoit_id = $bus_trip->Pivoit->first();

                event(new BreakTripEvent($bus_trip, $pivoit_id));


                $massage =  "trip has started $bus_trip->id ";

                event(new PrivateNotification($bus_trip->bus->company->user->id, $massage));
                UserNotification::create([
                    'user_id' => $bus_trip->bus->company->user->id,
                    'notification' => $massage,
                ]);

                $reservations = Reservation::where('status', 'pending')
                    ->where('pivoit_id', $pivoit_id->id)
                    ->where('type', 1)
                    ->get()
                    ->map(function ($reservation) {
                        return [
                            'user_id' => $reservation->user->id,
                            'id' => $reservation->id,
                            'user_name' => $reservation->user->name,
                            'price' => $reservation->price,
                            'bus__trip_id' => $reservation->bus__trip_id,
                            'type' => $reservation->type,
                            'status' => $reservation->status,
                            'seat' => $reservation->seat_reservation->pluck('seat.id')->all(),
                        ];
                    });

                foreach ($reservations as $reservation) {
                    $user_id = $reservation['user_id'];
                    $bus_tripw = $reservation['bus__trip_id'];
                    $massage = "Trip  started  $bus_tripw ";
                    event(new PrivateNotification($user_id, $massage));
                    UserNotification::create([
                        'user_id' => $user_id,
                        'notification' => $massage,
                    ]);
                }
                $trip_id = $bus_trip->trip_id;
                $key = 'trip_' . $trip_id;
                // Check if the trip is already cached
                if (Cache::has($key)) {
                    // If it is, retrieve the cached trip and update it
                    // Update the trip information here (e.g., $trip1->status = 'updated')
                    Cache::forget($key); // Remove the old cache entry
                }
                $trip1 = Trip::where('id', $trip_id)
                    ->with(['bus_trip.Pivoit', 'breaks_trip.break', 'path'])
                    ->first();
                // Cache the updated trip information
                Cache::put($key, $trip1, now()->addMinutes(30));

                DB::commit();
                return response()->json($reservations);
            } else {
                DB::rollBack();
                return response()->json($name_breaks->first());
            }
        } catch (Exception $e) {
            DB::rollBack();
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
    public function finish_breaks($pivoit_id)
    {
        $driver = Auth::user()->Driver;
        $bus = Bus_Driver::where('status', 'pending')
            ->where('driver_id', $driver->id)
            ->first();

        $bus_trip = Bus_Trip::where('bus_id', $bus->bus_id)
            ->whereIn('status', ['pending', 'finished_going'])
            ->first();

        if (!$bus_trip) {
            return response()->json([
                'massage' => 'already done'
            ]);
        }
        $pivoit = Pivoit::where('bus__trip_id', $bus_trip->id)
            ->find($pivoit_id);



        $previous_pivoit = Pivoit::where('bus__trip_id', $bus_trip->id)
            ->where('id', $pivoit_id - 1)
            ->first();

        $next_pivoit = Pivoit::where('bus__trip_id', $bus_trip->id)
            ->where('id', $pivoit_id + 1)
            ->first();
        DB::beginTransaction();
        try {

            if ($pivoit->status == 'pending') {
                $na = $pivoit->break_trip->break->name;
                if ($na != "start" && $previous_pivoit->status == "pending") {
                    DB::rollBack();
                    return response()->json([
                        'massage' => 'Can not you have break you did not finished it '
                    ]);
                } elseif ($pivoit->status == 'done2') {
                    DB::rollBack();
                    return response()->json([
                        'massage' => 'break already finished going and trip '
                    ]);
                }



                if ($pivoit->break_trip->break->name == "start" && $next_pivoit->status == "pending") {
                    $pivoit->status = 'done1';
                    $pivoit->save();
                    $bus_trip->event = 'running';
                    $bus_trip->save();
                    event(new BreakTripEvent($bus_trip, $pivoit));
                    if ($bus_trip->status == 'pending') {
                        $type_reservation = 1;
                    } else {
                        $type_reservation = 2;
                    }
                    $reservations = Reservation::where('pivoit_id', $pivoit_id)
                        ->where('status', 'pending')
                        ->where('type', $type_reservation)
                        ->get();

                    foreach ($reservations as $reservation) {
                        $reservation->status = 'out';
                        $reservation->save();
                        $user_id = $reservation->user_id;
                        $massage = "you are out of this trip $reservation->bus__trip_id ";
                        event(new PrivateNotification($user_id, $massage));
                        UserNotification::create([
                            'user_id' => $user_id,
                            'notification' => $massage,
                        ]);
                        foreach ($reservation->seat_reservation as $seat_reservation) {

                            $seat_reservation->status = 'out' . $type_reservation;
                            $seat_reservation->save();
                            // Save the seat object
                        }
                    }
                    return response()->json([
                        'massage' => 'break_done1'
                    ]);
                } elseif ($pivoit->break_trip->break->name == "end" && $previous_pivoit->status == "done1") {
                    $pivoit->status = 'done2';
                    $pivoit->save();
                    $bus_trip->event = 'running';
                    $bus_trip->save();
                    event(new BreakTripEvent($bus_trip, $pivoit));
                    if ($bus_trip->status == 'pending') {
                        $type_reservation = 1;
                    } else {
                        $type_reservation = 2;
                    }
                    $reservations = Reservation::where('pivoit_id', $pivoit_id)
                        ->where('status', 'pending')
                        ->where('type', $type_reservation)
                        ->get();

                    foreach ($reservations as $reservation) {
                        $reservation->status = 'out';
                        $reservation->save();
                        $user_id = $reservation->user_id;
                        $massage = "you are out of this trip $reservation->bus__trip_id ";
                        event(new PrivateNotification($user_id, $massage));
                        UserNotification::create([
                            'user_id' => $user_id,
                            'notification' => $massage,
                        ]);
                        foreach ($reservation->seat_reservation as $seat_reservation) {
                            $seat_reservation->status = 'out' . $type_reservation;
                            $seat_reservation->save();
                        }
                    }
                    return response()->json([
                        'massage' => 'break_done2'
                    ]);
                } elseif ($previous_pivoit->status == "done1" && $next_pivoit->status == "pending") {
                    $pivoit->status = 'done1';
                    $pivoit->save();
                    $bus_trip->event = 'running';
                    $bus_trip->save();
                    event(new BreakTripEvent($bus_trip, $pivoit));
                    if ($bus_trip->status == 'pending') {
                        $type_reservation = 1;
                    } else {
                        $type_reservation = 2;
                    }
                    $reservations = Reservation::where('pivoit_id', $pivoit_id)
                        ->where('status', 'pending')
                        ->where('type', $type_reservation)
                        ->get();

                    foreach ($reservations as $reservation) {
                        $reservation->status = 'out';
                        $reservation->save();
                        $user_id = $reservation->user_id;
                        $massage = "you are out of this trip $reservation->bus__trip_id ";
                        event(new PrivateNotification($user_id, $massage));
                        UserNotification::create([
                            'user_id' => $user_id,
                            'notification' => $massage,
                        ]);
                        foreach ($reservation->seat_reservation as $seat_reservation) {

                            $seat_reservation->status = 'out' . $type_reservation;
                            $seat_reservation->save();
                        }
                    }
                    return response()->json([
                        'massage' => 'break_done3'
                    ]);
                }
            } elseif ($pivoit->status == 'done1') {
                if ($pivoit->break_trip->break->name == "start" && $next_pivoit->status == "done2") {
                    $pivoit->status = 'done2';
                    $pivoit->save();
                    $bus_trip->event = 'finished_trip';
                    $bus_trip->status = 'finished';
                    $bus_trip->save();

                    $B_T = Bus_Trip::where('bus_id', $bus_trip->bus_id)
                        ->where('status', 'pending')->first();

                    if (!$B_T) {
                        $bus_trip->bus->status = "available";
                        $bus_trip->bus->save();
                        $bus_driver = Bus_Driver::where('bus_id',  $bus_trip->bus->id)
                            ->where('status', 'pending')->first();
                        $bus_driver->driver->status = "available";
                        $bus_driver->driver->save();
                    }
                    /**
                     *
                     *
                     *
                     */
                    event(new BreakTripEvent($bus_trip, $pivoit));
                    if ($bus_trip->status == 'pending') {
                        $type_reservation = 1;
                    } else {
                        $type_reservation = 2;
                    }
                    $reservations = Reservation::where('pivoit_id', $pivoit_id)
                        ->where('status', 'pending')
                        ->where('type', $type_reservation)
                        ->get();

                    foreach ($reservations as $reservation) {
                        $reservation->status = 'out';
                        $reservation->save();
                        $user_id = $reservation->user_id;
                        $massage = "you are out of this trip $reservation->bus__trip_id ";
                        event(new PrivateNotification($user_id, $massage));
                        UserNotification::create([
                            'user_id' => $user_id,
                            'notification' => $massage,
                        ]);
                        foreach ($reservation->seat_reservation as $seat_reservation) {
                            $seat_reservation->status = 'out' . $type_reservation;
                            $seat_reservation->save();
                        }
                    }
                    return response()->json($next_pivoit);
                } elseif ($previous_pivoit->status == "done1" && $next_pivoit->status == "done2") {
                    $pivoit->status = 'done2';
                    $pivoit->save();
                    $bus_trip->event = 'runing';
                    $bus_trip->save();
                    event(new BreakTripEvent($bus_trip, $pivoit));
                    if ($bus_trip->status == 'pending') {
                        $type_reservation = 1;
                    } else {
                        $type_reservation = 2;
                    }
                    $reservations = Reservation::where('pivoit_id', $pivoit_id)
                        ->where('status', 'pending')
                        ->where('type', $type_reservation)
                        ->get();

                    foreach ($reservations as $reservation) {
                        $reservation->status = 'out';
                        $reservation->save();
                        $user_id = $reservation->user_id;
                        $massage = "you are out of this trip $reservation->bus__trip_id ";
                        event(new PrivateNotification($user_id, $massage));
                        UserNotification::create([
                            'user_id' => $user_id,
                            'notification' => $massage,
                        ]);
                        foreach ($reservation->seat_reservation as $seat_reservation) {
                            $seat_reservation->status = 'out' . $type_reservation;
                            $seat_reservation->save();
                        }
                    }
                    return response()->json([
                        'massage' => 'break_done'
                    ]);
                }
            } else {
                DB::rollBack();
                return response()->json([
                    'massage' => 'something get wrong'
                ]);
            }
            $trip_id = $bus_trip->trip_id;
            $key = 'trip_' . $trip_id;
            // Check if the trip is already cached
            if (Cache::has($key)) {
                // If it is, retrieve the cached trip and update it
                // Update the trip information here (e.g., $trip1->status = 'updated')
                Cache::forget($key); // Remove the old cache entry
            }
            $trip1 = Trip::where('id', $trip_id)
                ->with(['bus_trip.Pivoit', 'breaks_trip.break', 'path'])
                ->first();
            // Cache the updated trip information
            Cache::put($key, $trip1, now()->addMinutes(30));
            DB::commit();
        } catch (Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => $e->getMessage()
            ], 500);
        }
    }
    public function access_break($pivoit_id)
    {
        DB::beginTransaction();
        try {

            $driver = Auth::user()->Driver;
            $company = $driver->company;

            $bus = Bus_Driver::where('status', 'pending')
                ->where('driver_id', $driver->id)
                ->first();

            $bus_trip = Bus_Trip::where('bus_id', $bus->bus_id)
                ->whereIn('status', ['pending', 'finished_going'])
                ->first();

            $pivoit = Pivoit::where('bus__trip_id', $bus_trip->id)
                ->find($pivoit_id);


            $previous_pivoit = Pivoit::where('bus__trip_id', $bus_trip->id)
                ->where('id', $pivoit_id - 1)
                ->first();

            $next_pivoit = Pivoit::where('bus__trip_id', $bus_trip->id)
                ->where('id', $pivoit_id + 1)
                ->first();

            if ($pivoit->status == 'pending') {

                if ($pivoit->break_trip->break->name == "end" && $previous_pivoit->status == "done1") {
                    $bus_trip->event = $pivoit->break_trip->break->name;
                    $bus_trip->status = "finished_going";
                    $bus_trip->save();
                    event(new BreakTripEvent($bus_trip, $pivoit));
                    $company_id1 = $bus_trip->bus->company->user->id;
                    $massage = " your trip finished going  $bus_trip->id ";
                    event(new PrivateNotification($company_id1, $massage));
                    UserNotification::create([
                        'user_id' => $company_id1,
                        'notification' => $massage,
                    ]);
                    $allFinished = $bus_trip->trip->bus_trip
                        ->whereIn('status', 'finished_going')
                        ->count() === $bus_trip->trip->bus_trip->count();

                    if ($allFinished) {
                        $bus_trip->trip->status = "finished_going";
                        $bus_trip->trip->save();
                    }

                    $reservations = Reservation::where('status', 'pending')
                        ->where('pivoit_id', $pivoit_id)
                        ->where('type', 2)
                        ->get()
                        ->map(function ($reservation) {
                            return [
                                'id' => $reservation->id,
                                'user_id' => $reservation->user->id,
                                'user_name' => $reservation->user->name,
                                'price' => $reservation->price,
                                'bus_trip_id' => $reservation->bus_trip_id,
                                'type' => $reservation->type,
                                'bus_trip_id' => $reservation->bus__trip_id,
                                'status' => $reservation->status,
                                'seat' => $reservation->seat_reservation->pluck('seat.id')->all(),
                            ];
                        });
                    foreach ($reservations as $reservation) {
                        $c = $reservation['bus_trip_id'];
                        $user1 = $reservation['user_id'];
                        $massage = " your bus arrived  : $c ";
                        event(new PrivateNotification($reservation->user_id, $massage));
                        UserNotification::create([
                            'user_id' => $user1,
                            'notification' => $massage,
                        ]);
                    }
                    return response()->json($reservations);
                } elseif ($previous_pivoit->status == "done1" && $next_pivoit->status == "pending") {
                    $bus_trip->event = $pivoit->break_trip->break->name;
                    $bus_trip->save();
                    $reservations = Reservation::where('status', 'pending')
                        ->where('pivoit_id', $pivoit_id)
                        ->where('type', 1)
                        ->get()
                        ->map(function ($reservation) {
                            return [
                                'id' => $reservation->id,
                                'user_name' => $reservation->user->name,
                                'price' => $reservation->price,
                                'bus_trip_id' => $reservation->bus_trip_id,
                                'type' => $reservation->type,
                                'bus_trip_id' => $reservation->bus__trip_id,
                                'status' => $reservation->status,
                                'seat' => $reservation->seat_reservation->pluck('seat.id')->all(),
                            ];
                        });
                    foreach ($reservations as $reservation) {
                        $massage = " your bus arrived  : $reservation->bus__trip_id  ";
                        event(new PrivateNotification($reservation->user_id, $massage));
                        UserNotification::create([
                            'user_id' => $reservation->user_id,
                            'notification' => $massage,
                        ]);
                    }
                    return response()->json($reservations);
                }
            } elseif ($pivoit->status == 'done1') {

                if ($pivoit->break_trip->break->name == "start" && $next_pivoit->status == "done2") {

                    $bus_trip->event = "finished_trip";
                    $bus_trip->status = "finished";
                    $bus_trip->save();
                    $pivoit->status = 'done2';
                    $pivoit->save();
                    $company_id1 = $bus_trip->bus->company->user->id;

                    $massage = " your trip finished  $bus_trip->id ";
                    event(new PrivateNotification($company_id1, $massage));
                    UserNotification::create([
                        'user_id' => $company_id1,
                        'notification' => $massage,
                    ]);
                    $allFinished = $bus_trip->trip->bus_trip
                        ->whereIn('status', 'finished')
                        ->count() === $bus_trip->trip->bus_trip->count();
                    print($allFinished);
                    if ($allFinished) {
                        $bus_trip->trip->status = "finished";
                        $bus_trip->trip->save();
                        $v = $bus_trip->trip->id;
                        $massage = " all bus trip of this trip finished  $v   ";
                        event(new PrivateNotification($company_id1, $massage));
                        UserNotification::create([
                            'user_id' => $company_id1,
                            'notification' => $massage,
                        ]);
                    }

                    $B_T = Bus_Trip::where('bus_id', $bus_trip->bus_id)
                        ->where('status', 'pending')->first();

                    if (!$B_T) {
                        $bus_trip->bus->status = "available";
                        $bus_trip->bus->save();
                        $bus_driver = Bus_Driver::where('bus_id',  $bus_trip->bus->id)
                            ->where('status', 'pending')->first();
                        $bus_driver->driver->status = "available";
                        $bus_driver->driver->save();
                    }

                    event(new BreakTripEvent($bus_trip, $pivoit));
                } elseif ($next_pivoit->status == "done2" && $previous_pivoit->status == "done1") {
                    $bus_trip->event = $pivoit->break_trip->break->name;
                    $bus_trip->save();
                    $reservations = Reservation::where('status', 'pending')
                        ->where('pivoit_id', $pivoit_id)
                        ->where('type', 2)
                        ->get()
                        ->map(function ($reservation) {
                            return [
                                'id' => $reservation->id,
                                'user_name' => $reservation->user->name,
                                'price' => $reservation->price,
                                'bus_trip_id' => $reservation->bus_trip_id,
                                'type' => $reservation->type,
                                'bus_trip_id' => $reservation->bus__trip_id,
                                'status' => $reservation->status,
                                'seat' => $reservation->seat_reservation->pluck('seat.id')->all(),
                            ];
                        });
                    foreach ($reservations as $reservation) {
                        $massage = " your bus arrived  : $reservation->bus__trip_id  ";
                        event(new PrivateNotification($reservation->user_id, $massage));
                        UserNotification::create([
                            'user_id' => $reservation->user_id,
                            'notification' => $massage,
                        ]);
                    }
                    return response()->json($reservations);
                }
            } elseif ($pivoit->status == 'done2') {
                DB::rollBack();
                return response()->json([
                    'massage' => 'break already finished going and trip '
                ]);
            } else {
                DB::rollBack();
                return response()->json([

                    'massage' => 'something get wrong'
                ]);
            }
            $trip_id = $bus_trip->trip_id;
            $key = 'trip_' . $trip_id;
            // Check if the trip is already cached
            if (Cache::has($key)) {
                // If it is, retrieve the cached trip and update it
                // Update the trip information here (e.g., $trip1->status = 'updated')
                Cache::forget($key); // Remove the old cache entry
            }
            $trip1 = Trip::where('id', $trip_id)
                ->with(['bus_trip.Pivoit', 'breaks_trip.break', 'path'])
                ->first();
            // Cache the updated trip information
            Cache::put($key, $trip1, now()->addMinutes(30));
            DB::commit();
        } catch (Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => $e->getMessage()
            ], 500);
        }
    }



    public function check_reservation($reservation_id)
    {
        $driver = Auth::user()->Driver;

        $bus = Bus_Driver::where('status', 'pending')
            ->where('driver_id', $driver->id)
            ->first();

        if (!$bus) {
            return response()->json(['error' => 'No pending bus found for the driver'], 404);
        }

        $bus_trip = Bus_Trip::where('bus_id', $bus->bus_id)
            ->first();

        if (!$bus_trip) {
            return response()->json(['error' => 'No bus trip found for the bus'], 404);
        }

        $reservation = Reservation::find($reservation_id);

        if (!$reservation) {
            return response()->json(['error' => 'Reservation not found'], 404);
        }

        if ($reservation->bus__trip_id == $bus_trip->id) {
            $reservation->status = 'completed';
            $reservation->save();

            $massage = "  YOUR BOOKED COMPLETED  : $reservation->id  ";
            event(new PrivateNotification($reservation->user_id, $massage));
            UserNotification::create([
                'user_id' => $reservation->user_id,
                'notification' => $massage,
            ]);


            return response()->json(['message' => 'Reservation status updated to completed']);
        } else {
            return response()->json(['error' => 'Reservation is not for this bus trip'], 400);
        }
    }


    public function my_finished_going_trip()
    {
        $driver = Auth::user()->Driver;

        if (!$driver) {
            return response()->json(['error' => 'Driver not found'], 404);
        }

        $bus = Bus_Driver::where('status', 'finished_going')
            ->where('driver_id', $driver->id)
            ->first();

        if (!$bus) {
            return response()->json(['error' => 'No pending bus found for the driver'], 404);
        }

        $trips = Bus_Trip::where('status', 'finished_going')
            ->where('bus_id', $bus->bus_id)
            ->get();

        if ($trips->isEmpty()) {
            return response()->json(['error' => 'No pending trip found for the bus'], 404);
        }

        $response = [];
        foreach ($trips as $trip) {
            $pivotData = [];
            foreach ($trip->Pivoit as $pivoit) {
                $pivotData[] = [
                    'id' => $pivoit->id,
                    'bus_trip_id' => $pivoit->bus__trip_id,
                    'break_name' => $pivoit->break_trip->break->name,
                    'status' => $pivoit->status,
                ];
            }

            $response[] = [
                'bus_trip_id' => $trip->id,
                'bus_id' => $trip->bus_id,
                'type' => $trip->type,
                'event' => $trip->event,
                'status' => $trip->status,
                'breaks_data' => $pivotData,
                'from_time_going' => $trip->from_time_going,
                'to_time_going' => $trip->to_time_going,
                'from_time_return' => $trip->from_time_return,
                'to_time_return' => $trip->to_time_return,
                'date_end' => $trip->date_end,
                'date_start' => $trip->date_start,
            ];
        }

        return response()->json($response);
    }





    public function my_finished_trip()
    {
        DB::beginTransaction();
        try {
            $driver = Auth::user()->Driver;
            if (!$driver) {
                DB::rollBack();
                return response()->json(['error' => 'Driver not found'], 404);
            }
            $bus = Bus_Driver::where('status', 'finished')
                ->where('driver_id', $driver->id)
                ->first();
            if (!$bus) {
                DB::rollBack();
                return response()->json(['error' => 'No pending bus found for the driver'], 404);
            }
            $trips = Bus_Trip::where('status', 'finished_going')
                ->where('bus_id', $bus->bus_id)
                ->get();
            if ($trips->isEmpty()) {
                DB::rollBack();
                return response()->json(['error' => 'No pending trip found for the bus'], 404);
            }
            $response = [];
            foreach ($trips as $trip) {
                $pivotData = [];
                foreach ($trip->Pivoit as $pivoit) {
                    $pivotData[] = [
                        'id' => $pivoit->id,
                        'bus_trip_id' => $pivoit->bus__trip_id,
                        'break_name' => $pivoit->break_trip->break->name,
                        'status' => $pivoit->status,
                    ];
                }
                $response[] = [
                    'bus_trip_id' => $trip->id,
                    'bus_id' => $trip->bus_id,
                    'type' => $trip->type,
                    'event' => $trip->event,
                    'status' => $trip->status,
                    'breaks_data' => $pivotData,
                    'from_time_going' => $trip->from_time_going,
                    'to_time_going' => $trip->to_time_going,
                    'from_time_return' => $trip->from_time_return,
                    'to_time_return' => $trip->to_time_return,
                    'date_end' => $trip->date_end,
                    'date_start' => $trip->date_start,
                ];
            }
            DB::commit();
            return response()->json($response);
        } catch (Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'An error occurred while retrieving finished trips'], 500);
        }
    }






    public function getPassenegerAtPivoit($bus_trip_id, $pivot_id)
    {
        $driver = Auth::user()->Driver;

        if (!$driver) {
            return response()->json(['error' => 'Driver not found'], 404);
        }
        $trip = Bus_Trip::where('id', $bus_trip_id)
            ->first();

        if (!$trip) {
            return response()->json(['error' => 'No  trip found for the bus'], 404);
        }
        $pivoit = $trip->Pivoit()->where('id', $pivot_id)->first();
        if (!$pivoit) {
            return response()->json(['error' => 'No specific pivot found for the trip'], 404);
        }

        $reservations = $pivoit->Reservation;

        $formattedReservations = $reservations->map(function ($reservation) {
            return

                $reservation->user ? $reservation->user->name : 'Unknown';
        })->toArray();




        return response()->json(['reservations' => $formattedReservations]);
    }
}
