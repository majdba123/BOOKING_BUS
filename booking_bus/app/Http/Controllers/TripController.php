<?php

namespace App\Http\Controllers;

use App\Models\Policy\CancelTrip\CanceledTrip;
use App\Models\Policy\CancelTrip\CancellationReason;
use App\Models\Seat_Reservation;
use App\Models\Trip;
use App\Models\Breaks_trip;
use App\Models\Bus_Driver;
use App\Models\Bus_Trip;
use App\Models\Breaks;
use App\Models\Pivoit;
use App\Models\Bus;
use App\Events\NewTrip;
use App\Events\PrivateNotification;
use App\Models\Policy\SatisfactionRate\SatisfactionRate;
use App\Models\Policy\SatisfactionRate\UserSatisfactionRate;
use App\Models\Reservation;
use App\Models\User;
use App\Models\UserNotification;
use Exception;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

class TripController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $company_id = Auth::user()->Company->id;
        $trips = [];
        // Loop through each trip and cache it individually
        foreach (Trip::where('company_id', $company_id)->pluck('id') as $trip_id) {
            $key = 'trip_' . $trip_id; // Create a unique cache key for each trip
            // Check if the trip is already cached
            if (Cache::has($key)) {
                $trips[] = Cache::get($key);
            } else {
                // If not, retrieve the trip from the database and cache it
                $trip = Trip::where('id', $trip_id)
                    ->with(['bus_trip.Pivoit', 'breaks_trip.break', 'path'])
                    ->first();
                $trips[] = $trip;
                Cache::put($key, $trip, now()->addMinutes(30)); // Cache for 30 minutes
            }
        }
        return response()->json($trips);
    }

    /**public function index()
    {
        $company_id = Auth::user()->Company->id;
        $trips = [];
        // Loop through each trip and cache it individually
        foreach (Trip::where('company_id', $company_id)->pluck('id') as $trip_id) {
            $key = 'trip_' . $trip_id; // Create a unique cache key for each trip
            // Check if the trip is already cached
            if (Cache::has($key)) {
                $trips[] = Cache::get($key);
            } else {
                // If not, retrieve the trip from the database and cache it
                $trip = Trip::where('id', $trip_id)
                    ->with(['bus_trip.Pivoit', 'breaks_trip.break', 'path'])
                    ->first();
                $trips[] = $trip;
                Cache::put($key, $trip, now()->addMinutes(30)); // Cache for 30 minutes
            }
        }
        return response()->json($trips);
    } */


/**
 *
 *  Cache::forget('trip_' . $trip->id);
 *
 *
 */

 /*    $key = 'trip_' . $trip->id;

    Cache::put($key, $trip, now()->addMinutes(30)); */


    /**
     * Show the form for creating a new resource.
     */
    public function index_status(Request $request)
    {
        $company_id = Auth::user()->Company->id;
        $trips = Trip::where('company_id', $company_id)
            ->where('status', $request->input('status'))
            ->with(['bus_trip.Pivoit', 'breaks_trip.break', 'path'])->get();
        return response()->json($trips);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $company = Auth::user()->Company->id;
        $validator = Validator::make($request->all(), [
            'path_id' => 'required|exists:paths,id,deleted_at,NULL',
            'price' => 'sometimes|required|string|max:255',
           /* 'breaks_ids' => 'required|array',
            'breaks_ids.*' => 'integer',*/
            'bus_ids' => 'required|array',
            'bus_ids.*.bus_id' => 'required',
            'bus_ids.*.type' => 'string|required',
            'bus_ids.*.from_time_going' => 'required|date_format:H:i',
            'bus_ids.*.to_time_going' => 'required|date_format:H:i',
            'bus_ids.*.from_time_return' => 'required|date_format:H:i',
            'bus_ids.*.to_time_return' => 'required|date_format:H:i',
            'bus_ids.*.date_start' => 'required|date',
            'bus_ids.*.date_end' => 'required|date',
        ]);

        $validator->after(function ($validator) use ($request) {
            foreach ($request->input('bus_ids') as $busId) {
                if (strtotime($busId['to_time_going']) <= strtotime($busId['from_time_going'])) {
                    $validator->errors()->add('bus_ids.*.to_time_going', 'To time going must be after from time going');
                }
                if (strtotime($busId['to_time_return']) <= strtotime($busId['from_time_return'])) {
                    $validator->errors()->add('bus_ids.*.to_time_return', 'To time return must be after from time return');
                }if (strtotime($busId['date_start']) > strtotime($busId['date_end'])) {
                    $validator->errors()->add('bus_ids.*.to_time_return', 'date_start time return must be befor from time date_end');
                }

            }
        });

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        DB::beginTransaction();
        try {
            $busIds = $request->input('bus_ids');
            $availableBuses = [];
            // Check if buses are available
            foreach ($busIds as $busId) {
             //   var_dump($busId);
                $bus = Bus::find($busId['bus_id']);

                if ($bus && $bus->status == 'available') {
                    $availableBuses[] = $busId;
                    //var_dump($availableBuses);
                }elseif($bus && $bus->status == 'completed') {
                    $existingTrip1 = Bus_Trip::where('bus_id', $bus->id)
                    ->where('date_start', $busId['date_start'])
                    ->whereNotIn('status', ['finished'])
                    ->exists();

                    $existingTrip2 = Bus_Trip::where('bus_id', $bus->id)
                    ->where('date_end', $busId['date_start'])
                    ->whereNotIn('status', ['finished'])
                    ->exists();

                    if ($existingTrip1) {
                        return response()->json([
                            'message' => "Bus is already scheduled for a trip on  at the same time.",
                        ], 422);
                    }elseif($existingTrip2)
                    {
                        return response()->json([
                            'message' => "Bus is already scheduled for a trip on  at the same time.",
                        ], 422);
                    }
                    $availableBuses[] = $busId;

                }
            }

            if (count($availableBuses) == 0) {
                return response()->json([
                    'message' => 'no buses available',
                ]);
            }

            $trip = new Trip();
            $trip->path_id = $request->input('path_id');
            $trip->company_id = $company;
            $trip->price = $request->input('price');
            $trip->save();
            $user_id =Auth::user()->id;

            $massage = " you created new trip  : $trip->id ";
            event(new PrivateNotification($user_id, $massage));
            UserNotification::create([
                'user_id' => Auth::user()->id,
                'notification' => $massage,
            ]);
            $admins = User::where('type', 1)->get();

            foreach ($admins as $admin) {
                $admin_id = $admin->id;
                // Send the message to each admin using the $admin_id
                $massage = "  created new trip  : $trip->id  by company: $company ";
                event(new PrivateNotification($admin_id, $massage));
                UserNotification::create([
                    'user_id' => $admin_id,
                    'notification' => $massage,
                ]);
            }


         //   $breakIds = $request->input('breaks_ids');
            $breakIds = Breaks::where('path_id',$request->input('path_id'))->get();
            foreach ($breakIds as $breakId) {
                $FIND = Breaks::find($breakId->id);
                if (!$FIND) {
                    return response()->json([
                        'message' => 'break not found',
                    ]);
                }

                $breakTrip = new Breaks_trip();
                $breakTrip->trip_id = $trip->id;
                $breakTrip->breaks_id = $breakId->id;
                $breakTrip->save();
            }



            foreach ($availableBuses as $busId) {
                $bus = Bus::find($busId['bus_id']);
                if ($bus
                    // && $bus->status == 'available'

                ) {
                    $busTrip = new Bus_Trip();
                    $busTrip->trip_id = $trip->id;
                    $busTrip->bus_id = $busId['bus_id'];
                    $busTrip->type = $busId['type'];
                    $busTrip->from_time_going = $busId['from_time_going']; // optional
                    $busTrip->to_time_going = $busId['to_time_going']; // optional
                    $busTrip->from_time_return = $busId['from_time_return'];
                    $busTrip->to_time_return = $busId['to_time_return'];
                    $busTrip->date_end = $busId['date_end'];
                    $busTrip->date_start = $busId['date_start'];
                    $busTrip->save();
                    $bus->status = 'completed';
                    $bus->bus_driver->pluck('driver')->each->update(['status' => 'completed']);
                    $bus->save();

                    $breakTrips = Breaks_trip::where('trip_id', $trip->id)->get();
                    foreach ($breakTrips as $breakTrip) {
                        $pivoit = new Pivoit();
                        $pivoit->bus__trip_id = $busTrip->id;
                        $pivoit->breaks_trip_id = $breakTrip->id;
                        $pivoit->save();
                    }
                } else {
                    // You can return an error message or log an error if the bus is not available
                    return response()->json([
                        'message' => 'bus not  available',
                    ]);
                }
            }
            DB::commit();
            
            $trips1 = $trip->with(['bus_trip.Pivoit', 'breaks_trip.break', 'path'])->find($trip->id);
            $key = 'trip_' . $trips1->id;
            Cache::put($key, $trips1, now()->addMinutes(30));

            event(new NewTrip($trips1));
            
            return response()->json($trips1, 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Failed to create trip: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show($trip)
    {
        $company_id = Auth::user()->Company->id;
        $trips = Trip::where('company_id', $company_id)
            ->where('id', $trip)
            ->with(['bus_trip.Pivoit.break_trip', 'breaks_trip.break', 'path'])->get();
        return response()->json($trips);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Trip $trip)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $company = Auth::user()->Company->id;
        $validator = Validator::make($request->all(), [
            'path_id' => 'required|exists:paths,id,deleted_at,NULL',
            'price' => 'sometimes|string|max:255',
            'bus_ids' => 'required_with:breaks_ids|array',
            'bus_ids.*.bus_id' => 'sometimes|string',
            'bus_ids.*.type' => 'string',
            'bus_ids.*.from_time_going' => 'sometimes|date_format:H:i',
            'bus_ids.*.to_time_going' => 'sometimes|date_format:H:i',
            'bus_ids.*.from_time_return' => 'sometimes|date_format:H:i',
            'bus_ids.*.to_time_return' => 'sometimes|date_format:H:i',
            'bus_ids.*.date_start' => 'sometimes|date',
            'bus_ids.*.date_end' => 'sometimes|date',
        ]);
        $validator->after(function ($validator) use ($request) {
            foreach ($request->input('bus_ids') as $busId) {
                if (strtotime($busId['to_time_going']) <= strtotime($busId['from_time_going'])) {
                    $validator->errors()->add('bus_ids.*.to_time_going', 'To time going must be after from time going');
                }
                if (strtotime($busId['to_time_return']) <= strtotime($busId['from_time_return'])) {
                    $validator->errors()->add('bus_ids.*.to_time_return', 'To time return must be after from time return');
                }if (strtotime($busId['date_start']) > strtotime($busId['date_end'])) {
                    $validator->errors()->add('bus_ids.*.to_time_return', 'date_start time return must be befor from time date_end');
                }

            }
        });

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        $trip = Trip::find($id);

        if (!$trip) {
            return response()->json(['error' => 'Trip not found'], 404);
        }

        if ($trip->path->company->id !== Auth::user()->Company->id) {

            return response()->json(['error' => 'You are not authorized to update this break.'], 403);

        }

        DB::beginTransaction();

        try {
            if ($request->has('price')) {
                $trip->price = $request->input('price');
                $trip->save();
            }

            if ($request->has('path_id') && $request->has('bus_ids')) {
                $bus_trips = Bus_Trip::where('trip_id', $trip->id)->get();
                if ($bus_trips->count() > 0) {
                    foreach ($bus_trips as $bus_trip) {
                        $bus = $bus_trip->bus;
                        $re=Reservation::where('status' , 'pending')
                        ->where('bus__trip_id' ,$bus_trip->id)->first();
                        if($re)
                        {
                            DB::rollBack();
                            return response()->json([
                                'message' => 'bus has reservation ',
                            ]);

                        }
                        if($bus_trip->event == 'stopped' )
                        {
                            if ($bus) {
                                $bus->status = 'available';
                                $bus->save();
                                $drivers = Bus_Driver::where('bus_id', $bus->id)
                                    ->where('status', 'pending')
                                    ->get();
                                if ($drivers->count() > 0) {
                                    foreach ($drivers as $driverr) {
                                        $x = $driverr->driver;
                                        $x->status = 'available';
                                        $x->save();
                                    }
                                }
                            }
                        }else{
                            DB::rollBack();
                            return response()->json([
                                'message' => 'bus active on trip ',
                            ]);

                        }
                    }
                    $trip->bus_trip()->delete();
                    $trip->breaks_trip()->delete();


                    $breakIds = Breaks::where('path_id', $request->input('path_id'))->get();
                    foreach ($breakIds as $breakId) {
                        $FIND = Breaks::find($breakId->id);
                        if (!$FIND) {
                            throw new Exception('Break not found');
                        }
                        $breakTrip = new Breaks_trip();
                        $breakTrip->trip_id = $trip->id;
                        $breakTrip->breaks_id = $breakId->id;
                        $breakTrip->save();
                    }

                    $busIds = $request->input('bus_ids');

                    foreach ($busIds as $busId) {
                        $bus = Bus::find($busId['bus_id']);
                        if ($bus && $bus->status == 'available') {
                            $busTrip = new Bus_Trip();
                            $busTrip->trip_id = $trip->id;
                            $busTrip->bus_id = $busId['bus_id'];
                            $busTrip->type = $busId['type'];
                            $busTrip->from_time_going = $busId['from_time_going']; // optional
                            $busTrip->to_time_going = $busId['to_time_going']; // optional
                            $busTrip->from_time_return = $busId['from_time_return'];
                            $busTrip->to_time_return = $busId['to_time_return'];
                            $busTrip->date_end = $busId['date_end'];
                            $busTrip->date_start = $busId['date_start'];
                            $busTrip->save();
                            $bus->status = 'completed';
                            $bus->bus_driver->pluck('driver')->each->update(['status' => 'completed']);
                            $bus->save();

                            $breakTrips = Breaks_trip::where('trip_id', $trip->id)->get();
                            foreach ($breakTrips as $breakTrip) {
                                $pivoit = new Pivoit();
                                $pivoit->bus__trip_id = $busTrip->id;
                                $pivoit->breaks_trip_id = $breakTrip->id;
                                $pivoit->save();
                            }
                        } else {
                            DB::rollBack();
                            throw new Exception('Bus not available');
                        }
                    }
                }
            }

            $trip_id = $id;
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

            return response()->json([
                'message' => 'Trip updated successfully',
            ]);
        } catch (Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => $e->getMessage(),
            ], 500);
        }
    }


    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $trip = Trip::find($id);
        if (!$trip) {

            return response()->json(['error' => 'Trip not found'], 404);
        }

        if ($trip->path->company->id !== Auth::user()->Company->id) {
            return response()->json(['error' => 'You are not authorized to update this break.'], 403);
        }
        $bus_trips = Bus_Trip::where('trip_id', $trip->id)->get();
        if ($bus_trips->count() > 0) {
            foreach ($bus_trips as $bus_trip) {
                $bus = $bus_trip->bus;
                $re=Reservation::where('status' , 'pending')
                ->where('bus__trip_id' ,$bus_trip->id)->first();
                if($re)
                {
                    return response()->json([
                        'message' => 'bus has reservation ',
                    ]);

                }
                if($bus_trip->event != 'stopped' )
                {
                    if ($bus) {
                        $bus->status = 'available';
                        $bus->save();
                        $drivers = Bus_Driver::where('bus_id', $bus->id)
                            ->where('status', 'pending')
                            ->get();
                        if ($drivers->count() > 0) {
                            foreach ($drivers as $driverr) {
                                $x = $driverr->driver;
                                $x->status = 'available';
                                $x->save();
                            }
                        }
                    }
                }else{
                    return response()->json([
                        'message' => 'bus active on trip ',
                    ]);

                }
            }
        }
        $trip->delete();
        $trip_id = $id;
        $key = 'trip_' . $trip_id;
        // Check if the trip is already cached
        if (Cache::has($key)) {
            // If it is, retrieve the cached trip and update it
            // Update the trip information here (e.g., $trip1->status = 'updated')
            Cache::forget($key); // Remove the old cache entry   
        }
        return response()->json([
            'message' => 'Trip deleted successfully',
        ]);
    }


 /*   public function index_user()
    {

        //this commment by hamza
        // $trips = Trip::where('status', ['pending' ,'finished_going'])->with('bus_trip')->get();
        $trips = Trip::where('status', 'pending')->get();

        $data = [];

        foreach ($trips as $trip) {

            // $busTrips = $trip->bus_trip;
            // $busTripsData = [];
            // foreach ($busTrips as $busTrip) {
            //     $busTripData = [
            //         'bus_trip_id' => $busTrip->id,
            //         'bus_id' => $busTrip->bus_id,
            //         'from_time' => $busTrip->from_time,
            //         'to_time' => $busTrip->to_time,
            //         'type' => $busTrip->type,
            //         'event' => $busTrip->type,
            //     ];

            //     $pivotData = $busTrip->Pivoit;
            //     $customPivotData = [];
            //     foreach ($pivotData as $pivot) {
            //         $customPivotData[] = [
            //             'break_id'  => $pivot->id,
            //             'government'  => $pivot->break_trip->break->area->name,
            //             'name_break' => $pivot->break_trip->break->name,
            //             'status' => $pivot->status,

            //         ];
            //     }
            //     $busTripData['pivot'] = $customPivotData;

            //     $seats = $busTrip->bus->seat; // Assuming you have a seats relationship on the bus_trip model
            //     $seatsData = [];
            //     foreach ($seats as $seat) {
            //         $seatsData[] = [
            //             'id' => $seat->id,
            //             'status' => $seat->status,
            //             // Add any other columns you want to include from the seats table
            //         ];
            //     }
            //     $busTripData['seats'] = $seatsData;

            //     $busTripsData[] = $busTripData;
            // }

            $data[] = [
                'trip_id' => $trip->id,
                'company_name' => $trip->company->user->name,
                'from'  => $trip->path->from,
                'to'  => $trip->path->to,
                'price' => $trip->price,
                // 'bus_trips' => $busTripsData,


            ];
        }
        return response()->json($data);
    }*/

    public function index_user()
    {
        $trips = [];
        foreach (Trip::where('status', 'pending')->pluck('id') as $trip_id) {
            $key = 'trip_' . $trip_id; // Create a unique cache key for each trip
            // Check if the trip is already cached
            if (Cache::has($key)) {
                $trips[] = Cache::get($key);
            } else {
                // If not, retrieve the trip from the database and cache it
                $trip = Trip::where('id', $trip_id)
                    ->with('path')
                    ->first();
                $data = [
                    'trip_id' => $trip->id,
                    'company_name' => $trip->company->user->name,
                    'from'  => $trip->path->from,
                    'to'  => $trip->path->to,
                    'price' => $trip->price,
                    // 'bus_trips' => $busTripsData,
                ];
                $trips[] = $data;
                Cache::put($key, $data, now()->addMinutes(30)); // Cache for 30 minutes
            }
        }
        return response()->json($trips);
    }


    public function trip_user_by_path(Request $request)
    {
        $from = $request->input('from');
        $to = $request->input('to');
        $companyName = $request->input('company_name');
        $name_break = $request->input('name_break');

        $tripsQuery = Trip::where('status', 'pending')

            ->whereHas('path', function ($query) use ($from, $to) {

                $query->where('from', 'like', "%{$from}%")
                    ->orWhere('to', 'like', "%{$to}%");
            })
            ->with('bus_trip');

        if ($companyName) {
            $tripsQuery->whereHas('company', function ($query) use ($companyName) {
                $query->where('name_company', 'like', "%{$companyName}%");
            });
        }

        if ($name_break) {
            $tripsQuery->whereHas('breaks_trip.break', function ($query) use ($name_break) {
                $query->where('name', 'like', "%{$name_break}%");
            });
        }



        $trips = $tripsQuery->get();
        $data = [];
        foreach ($trips as $trip) {
            // $busTrips = $trip->bus_trip;
            // $busTripsData = [];
            // foreach ($busTrips as $busTrip) {
            //     $busTripData = [

            //         'bus_id' => $busTrip->bus_id,
            //         'from_time' => $busTrip->from_time,
            //         'to_time' => $busTrip->to_time,
            //         'type' => $busTrip->type,
            //         'event' => $busTrip->type,
            //     ];

            //     $pivotData = $busTrip->Pivoit;
            //     $customPivotData = [];
            //     foreach ($pivotData as $pivot) {
            //         $customPivotData[] = [
            //             'break_id'  => $pivot->id,
            //             'government'  => $pivot->break_trip->break->area->name,
            //             'name_break' => $pivot->break_trip->break->name,
            //             'status' => $pivot->status,

            //         ];
            //     }
            //     $busTripData['pivot'] = $customPivotData;

            //     $seats = $busTrip->bus->seat; // Assuming you have a seats relationship on the bus_trip model
            //     $seatsData = [];
            //     foreach ($seats as $seat) {
            //         $seatsData[] = [
            //             'id' => $seat->id,
            //             'status' => $seat->status,
            //             // Add any other columns you want to include from the seats table
            //         ];
            //     }
            //     $busTripData['seats'] = $seatsData;

            //     $busTripsData[] = $busTripData;
            // }

            $data[] = [
                'trip_id' => $trip->id,
                'company_name' => $trip->company->user->name,
                'from'  => $trip->path->from,
                'to'  => $trip->path->to,
                'price' => $trip->price,
                // 'bus_trips' => $busTripsData,

                // Add any other columns you want to include from the trips table
            ];
        }
        return response()->json($data);
    }
    //code by hamza
    public function cancelTrip(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'trip_id' => 'required|exists:bus__trips,id',
            'description' => 'required|string|max:100',
            'reasons' => 'required|array',
            'reasons.*' => 'string|max:50',
            'rate' => 'numeric|min:0|max:100',
            'satisfaction_rate_description' => 'string|max:255'
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], 422);
        }


        $user = Auth::user();
        if (!$user->company) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $tripId = $request->input('trip_id');
        $description = $request->input('description');
        $reasons = $request->input('reasons');
        $rate = $request->input('rate');
        $satisfactionRateDescription = $request->input('satisfaction_rate_description');
        DB::beginTransaction();
        try {

            $trip = Bus_Trip::findOrFail($tripId);
            $tripStatus = Trip::findOrFail($tripId);


            if ($trip->status === 'canceled') {
                return response()->json(['error' => 'Trip is already canceled'], 400);
            }


            $canceledTrip = CanceledTrip::create([
                'trip_id' => $trip->id,
                'description' => $description,
            ]);


            foreach ($reasons as $reason) {
                CancellationReason::create([
                    'canceled_trip_id' => $canceledTrip->id,
                    'reason' => $reason,
                ]);
            }

            // tripsStatus VARIABLE => TRIP TABLE
            // TRIP          => Bus trip table

            $trip->status = 'canceled';
            $tripStatus->status = 'canceled';

            $trip->save();
            $tripStatus->save();
            $refundPoints = $tripStatus->price;
            // print('refund point'.$refundPoints);
            $buses = Bus::whereHas('bus_trip', function ($query) use ($trip) {
                $query->where('id', $trip->id);
            })->get();


            foreach ($buses as $bus) {
                $bus->status = 'available';
                $bus->save();
            }


            $company = $trip->bus->company->user;
            // print($company);
            $satisfactionRate = null;
            if ($rate !== null && $rate > 0) {
                $satisfactionRate = SatisfactionRate::create([
                    'company_id' => $trip->bus->company->id,
                    'description' => $satisfactionRateDescription,
                    'rate' => $rate,
                ]);
                $satisfactionRateValue = $satisfactionRate->rate;
            }
            $reservedSeats = Seat_Reservation::whereHas('seat', function ($query) use ($buses) {
                $query->whereIn('bus_id', $buses->pluck('id'));
            })->where('status', 'pending')->get();

            foreach ($reservedSeats as $reservation) {

                $seat = $reservation->seat;
                $seat->status = 0;
                $seat->save();

                // Mark reservation as canceled
                $reservationRecord = $reservation->reservation;
                $reservationRecord->status = 'canceled';
                $reservationRecord->save();


                $pivoits = $reservationRecord->pivoit;

                $pivoits->status = 'canceled';
                $pivoits->save();



                $reservation->status = 'canceled';
                $reservation->save();

                $user = $reservationRecord->user;

                // print('user !' . $user);
                // Calculate and apply satisfaction rate if not zero
                if ($satisfactionRate !== null) {
                    // Create or update the satisfaction rate record


                    $pointsAwarded = ($refundPoints * $satisfactionRateValue) / 100;

                    $user->point += $pointsAwarded;
                    $user->save();

                    // Store the user satisfaction rate record
                    UserSatisfactionRate::create([
                        'user_id' => $user->id,
                        'satisfaction_rate_id' => $satisfactionRate->id,
                    ]);
                }
                if ($company->point >= $refundPoints) {
                    $company->point -= $refundPoints;
                    $user->point += $refundPoints;

                    $company->save();
                    $user->save();
                } else {
                    DB::rollBack();
                    return response()->json(['error' => 'Company does not have enough points for refund'], 400);
                }
            }
            DB::commit();
            return response()->json([
                'message' => 'Trip has been successfully canceled',
                'canceled_trip_id' => $canceledTrip->id,
            ], 200);
        } catch (\Exception $e) {

            return response()->json(['error' => 'An error occurred: ' . $e->getMessage()], 500);
        }
    }

    public function sum($x, $y)
    {
        return $x + $y;
    }
}
