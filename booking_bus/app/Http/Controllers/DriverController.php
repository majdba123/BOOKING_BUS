<?php

namespace App\Http\Controllers;

use App\Models\Driver;
use Illuminate\Http\Request;
use App\Models\Company;
use App\Models\Pivoit;
use App\Models\Bus_Driver;
use App\Models\Reservation;
use App\Models\Bus_Trip;
use App\Models\user;
use App\Events\BreakTripEvent;
use App\Events\CompanyNotification;
use Exception;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
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
        $notification = "new Driver Regiseter $drivaer_name ";
        event(new CompanyNotification($company_id, $notification));

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
        $user_driver = $driver->user;
        $user_driver->delete();

        return response()->json([
            'message' => 'driver_deleted',
        ]);
    }

    public function my_bus()
    {
        $driver = Auth::user()->Driver;

        $bus = Bus_Driver::where('driver_id', $driver->id)->first();

        $info = $bus->bus;
        $data = [
            // 'id_bus' => $info->id,
            // 'company_id' => $info->company_id,
            'company_name' => $info->company->name_company,
            'number_bus' => $info->number_bus,
            'number_passenger' => $info->number_passenger,
            // 'status' => $info->status,
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

            $fromTime = new \DateTime($trip->from_time);
            $toTime = new \DateTime($trip->to_time);
            $interval = $fromTime->diff($toTime);
            $tripDuration = $interval->format('%H:%I');
            $response[] = [
                'id' => $trip->id,
                'bus_id' => $trip->bus_id,
                'from' => $trip->trip->path->from ?? null,
                'to' => $trip->trip->path->to ?? null,
                'from_time' => $trip->from_time,
                'to_time' => $trip->to_time,
                'date' => $trip->date,
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
        $trips = Bus_Trip::where('status', 'pending')
            ->where('bus_id', $bus->bus_id)
            ->get();

        if ($trips->isEmpty()) {
            return response()->json(['error' => 'No pending trips found for the bus'], 404);
        }

        $response = [];

        foreach ($trips as $trip) {
            // Load related data for each trip
            $trip->load(['trip.path', 'Pivoit.Reservation.user']);

            $fromTime = new \DateTime($trip->from_time);
            $toTime = new \DateTime($trip->to_time);
            $interval = $fromTime->diff($toTime);
            $tripDuration = $interval->format('%H:%I');
            $response[] = [
                'id' => $trip->id,
                'bus_id' => $trip->bus_id,
                'from' => $trip->trip->path->from ?? null,
                'to' => $trip->trip->path->to ?? null,
                'from_time' => $trip->from_time,
                'to_time' => $trip->to_time,
                'date' => $trip->date,
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
        $trip = Bus_Trip::where('status', 'pending')
            ->where('id', $bus_trip_id)
            // ->where('bus_id', $bus->bus_id)
            ->first();

        if (!$trip) {
            return response()->json(['error' => 'No pending trip found for the bus'], 404);
        }
        // print($trip);
        $pivotData = [];
        foreach ($trip->Pivoit as $pivoit) {
            $break = $pivoit->break_trip->break;
            $reservations = $pivoit->Reservation;

            $formattedReservations = $reservations->map(function ($reservation) {
                return
                    // 'reservation_id' => $reservation->id,
                    // 'user_id' => $reservation->user_id,
                    $reservation->user ? $reservation->user->name : 'Unknown';

                // 'price' => $reservation->price,
                // 'status' => $reservation->status,

            })->toArray();

            $pivotData[] = [
                'break_id' => $break->id,
                'break_name' => $break->name,
                // 'status' => $pivoit->status,
                'latitude' => doubleval($break->latitude),
                'longitude' => doubleval($break->longitude),
                'passengers_count' => $pivoit->Reservation->count(),
                'pivoit_id' => $pivoit->id,
                // 'reservations' => $formattedReservations,
            ];
        }

        $fromTime = new \DateTime($trip->from_time);
        $toTime = new \DateTime($trip->to_time);
        $interval = $fromTime->diff($toTime);
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
            $bus = Bus_Driver::where('status', 'padding')
                ->where('driver_id', $driver->id)
                ->first();

            $bus_trip = Bus_Trip::where('status', 'padding')
                ->where('bus_id', $bus->bus_id)
                ->first();

            $name_breaks = $bus_trip->Pivot->where('status', 'padding')->pluck('break_trip.break.name');

            if ($name_breaks->first() === "start") {
                $bus_trip->event = $name_breaks->first();
                $bus_trip->save();
                $pivoit_id = $bus_trip->Pivot->first();

                event(new BreakTripEvent($bus_trip, $pivoit_id));

                $notification = "your bus_trip $bus_trip->id  is started  ";
                event(new CompanyNotification($bus_trip->company, $notification));

                $reservations = Reservation::where('status', 'pending')
                    ->where('pivoit_id', $pivoit_id)
                    ->where('type', 1)
                    ->get()
                    ->map(function ($reservation) {
                        return [
                            'id' => $reservation->id,
                            'user_name' => $reservation->user->name,
                            'price' => $reservation->price,
                            'bus__trip_id ' => $reservation->bus__trip_id,
                            'type' => $reservation->type,
                            'status' => $reservation->status,
                            'seat' => $reservation->seat_reservation->pluck('seat.id')->all(),
                        ];
                    });

                DB::commit();
                return response()->json($reservations);
            } else {
                DB::rollBack();
                return response()->json($name_breaks->first());
            }
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'An error occurred while starting the trip'], 500);
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

        try {
            if ($pivoit->status == 'pending') {
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
                        ->where('status', 'padding')
                        ->where('type', $type_reservation)
                        ->get();

                    foreach ($reservations as $reservation) {
                        $reservation->status = 'out';
                        $reservation->save();
                        foreach ($reservation->seat_reservation as $seat_reservation) {
                            $seat_reservation->status = 'out';
                            $seat_reservation->save();
                            if ($seat_reservation->seat->status == 3) {
                                if ($reservation->type == 1) {
                                    $seat_reservation->seat->status = 2;
                                } elseif ($reservation->type == 2) {
                                    $seat_reservation->seat->status = 1;
                                }
                            } elseif ($seat_reservation->seat->status == 2) {
                                if ($reservation->type == 2) {
                                    $seat_reservation->seat->status = 0;
                                } else {
                                    return response()->json([
                                        'massage' => 'there is wrong'
                                    ]);
                                }
                            } elseif ($seat_reservation->seat->status == 1) {
                                if ($reservation->type == 1) {
                                    $seat_reservation->seat->status = 0;
                                } else {
                                    return response()->json([
                                        'massage' => 'there is wrong'
                                    ]);
                                }
                            }
                            $seat_reservation->seat->save(); // Save the seat object
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
                        ->where('status', 'padding')
                        ->where('type', $type_reservation)
                        ->get();

                    foreach ($reservations as $reservation) {
                        $reservation->status = 'out';
                        $reservation->save();
                        foreach ($reservation->seat_reservation as $seat_reservation) {
                            $seat_reservation->status = 'out';
                            $seat_reservation->save();
                            if ($seat_reservation->seat->status == 3) {
                                if ($reservation->type == 1) {
                                    $seat_reservation->seat->status = 2;
                                } elseif ($reservation->type == 2) {
                                    $seat_reservation->seat->status = 1;
                                }
                            } elseif ($seat_reservation->seat->status == 2) {
                                if ($reservation->type == 2) {
                                    $seat_reservation->seat->status = 0;
                                } else {
                                    return response()->json([
                                        'massage' => 'there is wrong'
                                    ]);
                                }
                            } elseif ($seat_reservation->seat->status == 1) {
                                if ($reservation->type == 1) {
                                    $seat_reservation->seat->status = 0;
                                } else {
                                    return response()->json([
                                        'massage' => 'there is wrong'
                                    ]);
                                }
                            }
                            $seat_reservation->seat->save(); // Save the seat object
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
                        ->where('status', 'padding')
                        ->where('type', $type_reservation)
                        ->get();

                    foreach ($reservations as $reservation) {
                        $reservation->status = 'out';
                        $reservation->save();
                        foreach ($reservation->seat_reservation as $seat_reservation) {
                            $seat_reservation->status = 'out';
                            $seat_reservation->save();
                            if ($seat_reservation->seat->status == 3) {
                                if ($reservation->type == 1) {
                                    $seat_reservation->seat->status = 2;
                                } elseif ($reservation->type == 2) {
                                    $seat_reservation->seat->status = 1;
                                }
                            } elseif ($seat_reservation->seat->status == 2) {
                                if ($reservation->type == 2) {
                                    $seat_reservation->seat->status = 0;
                                } else {
                                    return response()->json([
                                        'massage' => 'there is wrong'
                                    ]);
                                }
                            } elseif ($seat_reservation->seat->status == 1) {
                                if ($reservation->type == 1) {
                                    $seat_reservation->seat->status = 0;
                                } else {
                                    return response()->json([
                                        'massage' => 'there is wrong'
                                    ]);
                                }
                            }
                            $seat_reservation->seat->save(); // Save the seat object
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
                    event(new BreakTripEvent($bus_trip, $pivoit));
                    if ($bus_trip->status == 'pending') {
                        $type_reservation = 1;
                    } else {
                        $type_reservation = 2;
                    }
                    $reservations = Reservation::where('pivoit_id', $pivoit_id)
                        ->where('status', 'padding')
                        ->where('type', $type_reservation)
                        ->get();

                    foreach ($reservations as $reservation) {
                        $reservation->status = 'out';
                        $reservation->save();
                        foreach ($reservation->seat_reservation as $seat_reservation) {
                            $seat_reservation->status = 'out';
                            $seat_reservation->save();
                            if ($seat_reservation->seat->status == 3) {
                                if ($reservation->type == 1) {
                                    $seat_reservation->seat->status = 2;
                                } elseif ($reservation->type == 2) {
                                    $seat_reservation->seat->status = 1;
                                }
                            } elseif ($seat_reservation->seat->status == 2) {
                                if ($reservation->type == 2) {
                                    $seat_reservation->seat->status = 0;
                                } else {
                                    return response()->json([
                                        'massage' => 'there is wrong'
                                    ]);
                                }
                            } elseif ($seat_reservation->seat->status == 1) {
                                if ($reservation->type == 1) {
                                    $seat_reservation->seat->status = 0;
                                } else {
                                    return response()->json([
                                        'massage' => 'there is wrong'
                                    ]);
                                }
                            }
                            $seat_reservation->seat->save(); // Save the seat object
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
                        ->where('status', 'padding')
                        ->where('type', $type_reservation)
                        ->get();

                    foreach ($reservations as $reservation) {
                        $reservation->status = 'out';
                        $reservation->save();
                        foreach ($reservation->seat_reservation as $seat_reservation) {
                            $seat_reservation->status = 'out';
                            $seat_reservation->save();
                            if ($seat_reservation->seat->status == 3) {
                                if ($reservation->type == 1) {
                                    $seat_reservation->seat->status = 2;
                                } elseif ($reservation->type == 2) {
                                    $seat_reservation->seat->status = 1;
                                }
                            } elseif ($seat_reservation->seat->status == 2) {
                                if ($reservation->type == 2) {
                                    $seat_reservation->seat->status = 0;
                                } else {
                                    return response()->json([
                                        'massage' => 'there is wrong'
                                    ]);
                                }
                            } elseif ($seat_reservation->seat->status == 1) {
                                if ($reservation->type == 1) {
                                    $seat_reservation->seat->status = 0;
                                } else {
                                    return response()->json([
                                        'massage' => 'there is wrong'
                                    ]);
                                }
                            }
                            $seat_reservation->seat->save(); // Save the seat object
                        }
                    }
                    return response()->json([
                        'massage' => 'break_done'
                    ]);
                }
            } elseif ($pivoit->status == 'done2') {
                return response()->json([
                    'massage' => 'break already finished going and trip '
                ]);
            } else {
                return response()->json([
                    'massage' => 'something get wrong'
                ]);
            }
        } catch (Exception $e) {
            return response()->json([
                'error' => $e->getMessage()
            ], 500);
        }
    }




    public function access_break($pivoit_id)
    {
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
                    $atLeastOneFinishedGoing = $bus_trip->trip->bus_trip()
                        ->where('status', 'finished_going')
                        ->first();
                    $allFinished = $bus_trip->trip->bus_trip->whereIn('status', ['finished_going', 'finished'])->count() === $bus_trip->trip->bus_trip->count();
                    if ($atLeastOneFinishedGoing && $allFinished) {
                        $bus_trip->trip->status = "finished_going";
                        $bus_trip->trip->save(); // <--- Add this line

                    }
                    $reservations = Reservation::where('status', 'padding')
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
                    return response()->json($reservations);
                } elseif ($previous_pivoit->status == "done1" && $next_pivoit->status == "pending") {
                    $bus_trip->event = $pivoit->break_trip->break->name;
                    $bus_trip->save();
                    $reservations = Reservation::where('status', 'padding')
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
                    return response()->json($reservations);
                }
            } elseif ($pivoit->status == 'done1') {
                if ($pivoit->break_trip->break->name == "start" && $next_pivoit->status == "done2") {
                    $bus_trip->event = $pivoit->break_trip->break->name;
                    $bus_trip->status = "finished";
                    $pivoit->status == 'done2';
                    $pivoit->save();
                    $notification = "your bus_trip $bus_trip->id  is finished  ";
                    event(new CompanyNotification($company, $notification));
                    $bus_trip->bus->status = "available";
                    $driver->status = "available";
                    $driver->save();
                    $bus->bus->status = "available";
                    $bus->bus->save();
                    $bus_trip->save();
                    event(new BreakTripEvent($bus_trip, $pivoit));
                    $seats = $bus->bus->seat; // assuming you have a 'eats' relationship in your Bus model
                    foreach ($seats as $seat) {
                        $seat->status = 0;
                        $seat->save();
                    }
                    $allFinished = $bus_trip->trip->bus_trip->where('status', 'finished')->count() === $bus_trip->trip->bus_trip->count();
                    if ($allFinished) {
                        $bus_trip->trip->status = "finished";
                        $bus_trip->trip->save();
                    }
                    return response()->json([
                        'massage' => 'trip_finished going and trip'
                    ]);
                } elseif ($next_pivoit->status == "done2" && $previous_pivoit->status == "done1") {
                    $bus_trip->event = $pivoit->break_trip->break->name;
                    $bus_trip->save();
                    $reservations = Reservation::where('status', 'padding')
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
                    return response()->json($reservations);
                }
            } elseif ($pivoit->status == 'done2') {
                return response()->json([
                    'massage' => 'break already finished going and trip '
                ]);
            } else {
                return response()->json([
                    'massage' => 'something get wrong'
                ]);
            }
        } catch (Exception $e) {
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
            $reservation->seat_reservation()->update(['status' => 'completed']);
            $reservation->save();



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
                'from_time' => $trip->from_time,
                'to_time' => $trip->to_time,
                'date' => $trip->date,
                'type' => $trip->type,
                'event' => $trip->event,
                'status' => $trip->status,
                'breaks_data' => $pivotData,
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
                    'from_time' => $trip->from_time,
                    'to_time' => $trip->to_time,
                    'date' => $trip->date,
                    'type' => $trip->type,
                    'event' => $trip->event,
                    'status' => $trip->status,
                    'breaks_data' => $pivotData,
                ];
            }
            DB::commit();
            return response()->json($response);
        } catch (\Exception $e) {
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
