<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use App\Models\Reservation;
use App\Models\Trip;
use App\Models\Pivoit;
use App\Models\Favourite;
use App\Models\Bus_Trip;
use App\Models\Company;
use App\Models\User;
use App\Models\Driver;
use App\Models\Bus;
use App\Models\Private_trip;
use App\Models\Order_Private_trip;
use Illuminate\Support\Facades\Auth;

class AdminDashBoardController extends Controller
{
    public function all_user()
    {
        $user=User::all()->load(['profile', 'address']);
        return response()->json($user);
    }

    public function user_details($id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['error' => 'User not found'], 404);
        }
        $user->load(['profile', 'address']);
        return response()->json($user);

    }

    public function fillter_user(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string',
            'email' => 'nullable|email',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $query = User::query();

        if ($request->input('name')) {
            $query->where('name', 'like', "%{$request->input('name')}%");
        }

        if ($request->input('email')) {
            $query->orWhere('email', 'like', "%{$request->input('email')}%");
        }

        $users = $query->with(['profile', 'address'])->get();

        if ($users->isEmpty()) {
            return response()->json(['error' => 'No users found'], 404);
        }

        return response()->json($users);
    }

    public function user_reservation($id)
    {
        $reservations = Reservation::where('user_id', $id)->get();
        $data=[];
        foreach($reservations  as $reservation)
        {
            $info=[
                "user_name" => $reservation->user->name,
                "reservation_id" => $reservation->id,
                "area_name" => $reservation->pivoit->break_trip->break->area->name,
                "break_name" => $reservation->pivoit->break_trip->break->name,
                'pivoit_id' => $reservation->pivoit->id,
                "reservation_status" => $reservation->status,
                "reservation_type" => $reservation->type,
                "seat" => $reservation->seat_reservation->map(function($seatReservation) {
                    return [
                        'seat_id' => $seatReservation->seat->id,
                        'status' => $seatReservation->status, // assuming SeatReservation model has a 'seat_type' column
                        // add more fields as needed
                    ];
                })->all(),
            ];
            $data[]=$info;
        }
        return response()->json($data);
    }

    public function user_reservation_by_status($id, Request $request)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'nullable|string|in:completed,padding,out,finished',
            'type' => 'nullable|integer|in:1,2',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $reservations = Reservation::where('user_id', $id);

        if ($request->input('status')) {
            $reservations->where('status', $request->input('status'));
        }

        if ($request->input('type')) {
            $reservations->where('type', $request->input('type'));
        }

        $reservations = $reservations->get();

        $data = [];
        foreach ($reservations as $reservation) {
            $info = [
                "user_name" => $reservation->user->name,
                "reservation_id" => $reservation->id,
                "area_name" => $reservation->pivoit->break_trip->break->area->name,
                "break_name" => $reservation->pivoit->break_trip->break->name,
                'pivoit_id' => $reservation->pivoit->id,
                "reservation_status" => $reservation->status,
                "reservation_type" => $reservation->type,
                "seat" => $reservation->seat_reservation->map(function ($seatReservation) {
                    return [
                        'seat_id' => $seatReservation->seat->id,
                        'status' => $seatReservation->status, // assuming SeatReservation model has a 'seat_type' column
                        // add more fields as needed
                    ];
                })->all(),
            ];
            $data[] = $info;
        }

        return response()->json($data);
    }
    public function all_trip_history_of_user($id)
    {
        $reservations = Reservation::where('user_id', $id)
                        ->get();

        $busTripIds = $reservations->pluck('bus__trip_id')->all();

        $customBusTrips = Bus_Trip::whereIn('id', $busTripIds)
            ->get()
            ->map(function ($busTrip) {
                return [
                    'id' => $busTrip->id,
                    'from' => $busTrip->trip->path->from,
                    'to' => $busTrip->trip->path->to,
                    'price_trip' => $busTrip->trip->price,
                    'from_time' => $busTrip->from_time,
                    'to_time' => $busTrip->to_time,
                    'date' => $busTrip->date,
                    'status' => $busTrip->status,
                    'type' => $busTrip->type,
                    'event' => $busTrip->event,
                ];
            })->all();

            return response()->json($customBusTrips);
        }

        public function all_trip_history_of_user_fillter($id, Request $request)
        {
            $reservations = Reservation::where('user_id', $id)
                ->get();

            $busTripIds = $reservations->pluck('bus__trip_id')->all();

            $customBusTrips = Bus_Trip::whereIn('id', $busTripIds);

            // Filter by date range
            if ($request->query('from_date') && $request->query('to_date')) {
                $customBusTrips->whereBetween('date', [$request->query('from_date'), $request->query('to_date')]);
            }

            // Filter by status
            if ($request->query('status')) {
                $customBusTrips->where('status', $request->query('status'));
            }

            // Filter by type
            if ($request->query('type')) {
                $customBusTrips->where('type', $request->query('type'));
            }

            $customBusTrips = $customBusTrips->get()
                ->map(function ($busTrip) {
                    return [
                        'id' => $busTrip->id,
                        'from' => $busTrip->trip->path->from,
                        'to' => $busTrip->trip->path->to,
                        'price_trip' => $busTrip->trip->price,
                        'from_time' => $busTrip->from_time,
                        'to_time' => $busTrip->to_time,
                        'date' => $busTrip->date,
                        'status' => $busTrip->status,
                        'type' => $busTrip->type,
                        'event' => $busTrip->event,
                    ];
                })->all();

            return response()->json($customBusTrips);
        }

        public function favourite_company_of_user($user_id)
        {
            $favoutite = Favourite::where('user_id', $user_id)->get();

            $response = [];

            foreach ($favoutite as $favourite) {
                $company = $favourite->company;
                $response[] = [
                    'id_favourite' => $favourite->id,
                    'name_user' => $favourite->user->name,
                    'user_id' => $favourite->user->id,
                    'name_company' => $company->name_company,
                    'company_id' => $company->id,
                    'email_company' => $company->user->email,
                    'image_company' => $company->user->profile->image,
                    'phone' => $company->user->profile->phone,
                ];
            }

            return response()->json($response);
        }

        public function private_order_of_user($user_id)
        {
            $Private_trips = Private_trip::where('user_id', $user_id)->with('order_private_trip')->get();

            $response = [];

            foreach ($Private_trips as $Private_trip) {
                $response[] = [
                    'Private_trip_id' => $Private_trip->id,
                    'user_id' => $Private_trip->user_id,
                    'user_name' => $Private_trip->user->name,
                    'user_email' => $Private_trip->user->email,
                    'from' => $Private_trip->from,
                    'to' => $Private_trip->to,
                    'date' => $Private_trip->date,
                    'start_time' => $Private_trip->start_time,
                    'status' => $Private_trip->status,
                    'order_private_trip' => $Private_trip->order_private_trip ? $Private_trip->order_private_trip->map(function ($orderPrivateTrip) {
                        return [
                            'id' => $orderPrivateTrip->id,
                            'company_id' => $orderPrivateTrip->company_id,
                            'price' => $orderPrivateTrip->price,
                            'payment_status' => $orderPrivateTrip->status,
                        ];
                    })->all() : [],
                ];
            }

            return response()->json($response);
        }
        public function private_order_of_user_fillter(Request $request, $user_id)
        {
            $validator = Validator::make($request->all(), [
                'from' => 'nullable|string',
                'to' => 'nullable|string',
                'status' => 'nullable|string',
                'start_time' => 'nullable|string',
                'date' => 'nullable|string',
            ]);

            if ($validator->fails()) {
                return response()->json(['error' => $validator->messages()], 422);
            }

            $from = $request->input('from');
            $to = $request->input('to');
            $status = $request->input('status');
            $start_time = $request->input('start_time');
            $date = $request->input('date');


            if ($from) {
                $Private_trips = Private_trip::where('user_id', $user_id)
                                                ->where('from' ,$from )
                                                ->with('order_private_trip')->get();
            }

            if ($to) {
                $Private_trips = Private_trip::where('user_id', $user_id)
                ->where('to' ,$to )
                ->with('order_private_trip')->get();
            }

            if ($status) {
                $Private_trips = Private_trip::where('user_id', $user_id)
                ->where('status' ,$status )
                ->with('order_private_trip')->get();
            }

            if ($start_time) {
                $Private_trips = Private_trip::where('user_id', $user_id)
                                                ->where('start_time' ,$start_time )
                                                ->with('order_private_trip')->get();
            }

            if ($date) {
                $Private_trips = Private_trip::where('user_id', $user_id)
                                                ->where('date' ,$date )
                                                ->with('order_private_trip')->get();
            }

            $response = [];

            foreach ($Private_trips as $Private_trip) {
                $response[] = [
                    'Private_trip_id' => $Private_trip->id,
                    'user_id' => $Private_trip->user_id,
                    'user_name' => $Private_trip->user->name,
                    'user_email' => $Private_trip->user->email,
                    'from' => $Private_trip->from,
                    'to' => $Private_trip->to,
                    'date' => $Private_trip->date,
                    'start_time' => $Private_trip->start_time,
                    'status' => $Private_trip->status,
                    'order_private_trip' => $Private_trip->order_private_trip ? $Private_trip->order_private_trip->map(function ($orderPrivateTrip) {
                        return [
                            'id' => $orderPrivateTrip->id,
                            'company_id' => $orderPrivateTrip->company_id,
                            'price' => $orderPrivateTrip->price,
                            'payment_status' => $orderPrivateTrip->status,
                        ];
                    })->all() : [],
                ];
            }

            return response()->json($response);
    }

    public function all_company()
    {
        $companies = Company::with('user.profile', 'user.address')->paginate(10);
        return response()->json($companies);
    }


    public function company_by_id($company_id)
    {
        $company = Company::with('user.profile', 'user.address')->findOrFail($company_id);
        return response()->json($company);
    }
    public function fillter_company(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string',
            'email' => 'nullable|email',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $name = $request->input('name');
        $email = $request->input('email');

        $query = Company::with('user.profile', 'user.address');

        if ($name) {
            $query->whereHas('user', function ($query) use ($name) {
                $query->where('name', $name);
            });
        }

        if ($email) {
            $query->whereHas('user', function ($query) use ($email) {
                $query->where('email', $email);
            });
        }

        if (!$name && !$email) {
            return response()->json(['error' => 'Please provide either name or email to search for a company'], 422);
        }

        $company = $query->get();

        return response()->json($company);
    }

    public function all_driver_by_id_company($company_id)
    {
        $drivers = Driver::where('company_id' , $company_id)->with('user.profile' ,'user.address',)->get();
        return response()->json($drivers);
    }

    public function all_driver_status_by_id_company($company_id, Request $request)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $drivers = Driver::where('company_id', $company_id);
        $status =$request->input('status');

        if ($status) {
            $drivers->where('status', $status);
        }
        $drivers = $drivers->with('user.profile', 'user.address')->get();
        return response()->json($drivers);
    }

    public function all_bus_by_id_company($company_id)
    {
        $drivers = Bus::where('company_id' , $company_id)->with('seat' ,'company')->get();
        return response()->json($drivers);
    }

    public function all_bus_status_by_id_company($company_id, Request $request)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $buses = Bus::where('company_id', $company_id);
        $status = $request->input('status');

        if ($status) {
            $buses->where('status', $status);
        }
        $buses = $buses->with('seat', 'company')->get();
        return response()->json($buses);
    }

    public function all_trip_of_company($company_id)
    {
        $trips=Trip::where('company_id' ,$company_id)->with(['bus_trip.Pivoit','breaks_trip.break.area','path'])->get();
        return response()->json($trips);
    }

    public function trip_by_status_of_company(Request $request , $company_id)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }
        $trips=Trip::where('company_id' ,$company_id)
                    ->where('status',$request->input('status'))
                    ->with(['bus_trip.Pivoit','breaks_trip.break.area','path'])->get();
        return response()->json($trips);
    }

    public function fillter_all_trip(Request $request)
    {
            $path = $request->input('path_id');
            $companyName = $request->input('company_name');
            $name_break = $request->input('name_break');

            $tripsQuery = Trip::with('bus_trip');

            if ($path) {
                $tripsQuery->whereHas('path', function ($query) use ($path) {
                    $query->where('id', $path);
                });
            }


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
                $busTrips = $trip->bus_trip;
                $busTripsData = [];
                foreach ($busTrips as $busTrip) {
                    $busTripData = [

                        'bus_id' => $busTrip->bus_id,
                        'from_time' => $busTrip->from_time,
                        'to_time' => $busTrip->to_time,
                        'type' => $busTrip->type,
                        'event' => $busTrip->type,
                    ];

                    $pivotData = $busTrip->Pivoit;
                    $customPivotData = [];
                    foreach ($pivotData as $pivot) {
                        $customPivotData[] = [
                            'break_id'  => $pivot->id,
                            'government'  => $pivot->break_trip->break->area->name,
                            'name_break' => $pivot->break_trip->break->name,
                            'status' => $pivot->status,

                        ];
                    }
                    $busTripData['pivot'] = $customPivotData;

                    $seats = $busTrip->bus->seat; // Assuming you have a seats relationship on the bus_trip model
                    $seatsData = [];
                    foreach ($seats as $seat) {
                        $seatsData[] = [
                            'id' => $seat->id,
                            'status' => $seat->status,
                            // Add any other columns you want to include from the seats table
                        ];
                    }
                    $busTripData['seats'] = $seatsData;

                    $busTripsData[] = $busTripData;
                }

                $data[] = [
                    'trip_id' => $trip->id,
                    'company_id' => $trip->company->user->name,
                    'from'  => $trip->path->from,
                    'to'  => $trip->path->to,
                    'price' => $trip->price,
                    'bus_trips' => $busTripsData,

                    // Add any other columns you want to include from the trips table
                ];
            }
            return response()->json($data);
    }

    public function get_all_BusTripsByTripId(Request $request ,$companyId)
    {
        $validator = Validator::make($request->all(), [
            'trip_id' => 'required|integer|exists:trips,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $tripId =$request->input('trip_id');
        if($companyId){
            $trip = Trip::where('company_id' , $companyId)->find($tripId);
            if (!$trip) {
                // Return an error or a default response if the trip is not found
                return response()->json(['error' => 'Trip not found'], 404);
            }
        }else{
            $trip = Trip::find($tripId);
            if (!$trip) {
                // Return an error or a default response if the trip is not found
                return response()->json(['error' => 'Trip not found'], 404);
            }
        }

        $busTrips = $trip->bus_trip;


        $busTripsData = [];
        foreach ($busTrips as $busTrip) {
            $busTripData = [
                'bus_id' => $busTrip->bus_id,
                'from' => $trip->path->from,
                'to' => $trip->path->to,
                'from_time' => $busTrip->from_time,
                'to_time' => $busTrip->to_time,
                'type' => $busTrip->type,
                'event' => $busTrip->event,
            ];

            $breaksData = [];
            foreach ($busTrip->Pivoit as $pivot) {
                $breakData = [
                    'id' => $pivot->id,
                    'government' => $pivot->break_trip->break->area->name,
                    'name_break' => $pivot->break_trip->break->name,
                    'status' => $pivot->status,
                ];
                $breaksData[] = $breakData;
            }

            $busTripData['breaks'] = $breaksData;

            $seats = $busTrip->bus->seat;
            $seatsData = [];
            foreach ($seats as $seat) {
                $seatsData[] = [
                    'status' => $seat->status,
                    // Add any other columns you want to include from the seats table
                ];
            }
            $busTripData['seats'] = $seatsData;

            $busTripsData[] = $busTripData;
        }

        return response()->json($busTripsData);
    }

    public function get_all_BusTripsByFillter(Request $request)
    {
        $fromTime = $request->input('from_time');
        $toTime = $request->input('to_time');
        $type = $request->input('type');
        $from = $request->input('from');
        $to = $request->input('to');
        $status = $request->input('status');


        $busTrips = Bus_Trip::query();

        if ($fromTime) {
            $busTrips->where('from_time', $fromTime);
        }

        if ($status) {
            $busTrips->where('status', $status);
        }

        if ($toTime) {
            $busTrips->where('to_time', $toTime);
        }

        if ($type) {
            $busTrips->where('type', $type);
        }

        if ($from) {

            $busTrips->whereHas('trip.path', function ($query) use ($from) {

                $query->where('from', $from);

            });

        }


        if ($to) {

            $busTrips->whereHas('trip.path', function ($query) use ($to) {

                $query->where('to', $to);

            });

        }

        $busTrips = $busTrips->get();

        $busTripsData = [];
        foreach ($busTrips as $busTrip) {
            $busTripData = [
                'bus_id' => $busTrip->bus_id,
                'from_time' => $busTrip->from_time,
                'to_time' => $busTrip->to_time,
                'type' => $busTrip->type,
                'event' => $busTrip->event,
            ];

            $breaksData = [];
            foreach ($busTrip->Pivoit as $pivot) {
                $breakData = [
                    'id' => $pivot->id,
                    'government' => $pivot->break_trip->break->area->name,
                    'name_break' => $pivot->break_trip->break->name,
                    'status' => $pivot->status,
                ];
                $breaksData[] = $breakData;
            }

            $busTripData['breaks'] = $breaksData;

            $seats = $busTrip->bus->seat;
            $seatsData = [];
            foreach ($seats as $seat) {
                $seatsData[] = [
                    'status' => $seat->status,
                    // Add any other columns you want to include from the seats table
                ];
            }
            $busTripData['seats'] = $seatsData;

            $busTripsData[] = $busTripData;
        }

        return response()->json($busTripsData);
    }


    public function all_reservation_of_company($company_id)
    {
        $company = Company::findOrfail($company_id);
        $reservations = [];

        foreach ($company->trip as $trip1) {
            foreach ($trip1->bus_trip as $busTrip) {
                foreach ($busTrip->Reservation as $reservation) {
                    $seats = [];
                    foreach ($reservation->seat_reservation as $seatReservation) {
                        $seats[] = [
                            'id' => $seatReservation->seat->id,
                            'status' => $seatReservation->seat->status
                        ];
                    }
                    $customReservation = [
                        'id' => $reservation->id,
                        'price' => $reservation->price,
                        'type' => $reservation->type,
                        'status' => $reservation->status,
                        'user_name' => $reservation->user->name,
                        'user_id' => $reservation->user_id,
                        'break' => $reservation->pivoit->break_trip->break->name,
                        'from' =>$reservation->pivoit->bus_trip->trip->path->from,
                        'to' => $reservation->pivoit->bus_trip->trip->path->from,
                        'seats' => $seats // array of seat names or properties


                    ];
                    $reservations[] = $customReservation;
                }
            }
        }
        return response()->json($reservations);
    }


    public function all_reservation_of_company__by_status(Request $request , $company_id)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }
        $status = $request->input('status');
        $company = Company::findOrfail($company_id);
        $reservations = [];

        foreach ($company->trip as $trip1) {
            foreach ($trip1->bus_trip as $busTrip) {
                foreach ($busTrip->Reservation as $reservation) {
                    if (str_contains($reservation->status, $status)) {
                        $customReservation = [
                            'id' => $reservation->id,
                            'price' => $reservation->price,
                            'user_name' => $reservation->user->name,
                            'user_id' => $reservation->user_id,
                            'type' => $reservation->type,
                            'status' => $reservation->status,
                            'break' => $reservation->pivoit->break_trip->break->name,
                            'from' =>$reservation->pivoit->bus_trip->trip->path->from,
                            'to' => $reservation->pivoit->bus_trip->trip->path->from,
                        ];
                        $reservations[] = $customReservation;
                    }
                }
            }
        }
        return response()->json($reservations);
    }

    public function all_reservation_by_bus_trip($id ,Request $request)
    {

        $company_id = Company::findOrfail($id);

        $validator = Validator::make($request->all(), [
            'bus_trip_id' => 'required|integer|exists:bus__trips,id',
        ]);
        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $bus_trip_id =$request->input('bus_trip_id');
        $reservations = Reservation::where('bus__trip_id', $bus_trip_id)
            ->whereHas('pivoit.bus_trip.trip.company', function ($query) use ($company_id) {
                $query->where('id', $company_id->id);
            })
            ->get();

        $customReservations = [];
        foreach ($reservations as $reservation) {
            $seats = [];
            foreach ($reservation->seat_reservation as $seatReservation) {
                $seats[] = [
                    'id' => $seatReservation->seat->id,
                    'status' => $seatReservation->seat->status
                ];
            }
            $customReservation = [
                'id' => $reservation->id,
                'price' => $reservation->price,
                'user_name' => $reservation->user->name,
                'user_id' => $reservation->user_id,
                'type' => $reservation->type,
                'status' => $reservation->status,
                'break' => $reservation->pivoit->break_trip->break->name,
                'from' =>$reservation->pivoit->bus_trip->trip->path->from,
                'to' => $reservation->pivoit->bus_trip->trip->path->to,
                'seats' => $seats // array of seat names or properties

            ];
            $customReservations[] = $customReservation;
        }

        return response()->json($customReservations);
    }

    public function get_profit_bus_trip($id_bus_trip)
    {
        $bus_trip=Bus_Trip::find($id_bus_trip);
        // Check if the bus trip belongs to the company that made the request

        // Get all completed and out reservations for the bus trip
        $reservations = $bus_trip->Reservation()->whereIn('status', ['completed', 'out'])->get();

        // Calculate the total price
        $total_price = 0;
        foreach ($reservations as $reservation) {
            $total_price += $reservation->price;
        }

        return response()->json(['total_price' => $total_price]);
    }

    public function get_profit_trip($id_trip)
    {

        $trip = Trip::find($id_trip);
        // Check if the trip belongs to the company that made the request


        // Get all bus trips for the trip
        $busTrips = $trip->bus_trip;

        // Initialize total price
        $total_price = 0;

        // Loop through each bus trip and get its reservations
        foreach ($busTrips as $busTrip) {
            $reservations = $busTrip->Reservation()->whereIn('status', ['completed', 'out'])->get();
            // Calculate the total price for each bus trip
            foreach ($reservations as $reservation) {
                $total_price += $reservation->price;
            }
        }

        return response()->json(['total_price' => $total_price]);
    }

    public function user_info($user_id)
    {
        $user=User::find($user_id)->load(['profile', 'address']);
        return response()->json($user);
    }


    public function company_all_info($company_id)
    {
        $company = Company::findOrfail($company_id);

        $reservationCounts = Reservation::whereHas('pivoit.bus_trip.trip.company', function ($query) use ($company) {
            $query->where('id', $company->id);
        })
        ->selectRaw('status, COUNT(*) as count')
        ->groupBy('status')
        ->get()
        ->keyBy('status')
        ->mapWithKeys(function ($item) {
            return [$item->status => $item->count];
        });

        $trip_count =Trip::where('company_id' , $company->id )
        ->selectRaw('status, COUNT(*) as count')
        ->groupBy('status')
        ->get()
        ->keyBy('status')
        ->mapWithKeys(function ($item) {
            return [$item->status => $item->count];
        });

        $bus_trip = Bus_Trip::whereHas('trip.company', function ($query) use ($company) {
            $query->where('id', $company->id);
        })
        ->selectRaw('status, COUNT(*) as count')
        ->groupBy('status')
        ->get()
        ->keyBy('status')
        ->mapWithKeys(function ($item) {
            return [$item->status => $item->count];
        });

        $reservationSums = Reservation::whereHas('pivoit.bus_trip.trip.company', function ($query) use ($company) {
            $query->where('id', $company->id);
        })
        ->selectRaw('status, SUM(price) as sum')
        ->groupBy('status')
        ->get()
        ->keyBy('status')
        ->mapWithKeys(function ($item) {
            return [$item->status => $item->sum];
        });

        $driverCounts = Driver::where('company_id', $company->id)

            ->selectRaw('status, COUNT(*) as count')
            ->groupBy('status')
            ->get()
            ->keyBy('status')
            ->mapWithKeys(function ($item) {
                return [$item->status => $item->count];
            });
        $allDrivers = $driverCounts->sum();
        $completed_Drivers = $driverCounts->get('completed', 0);
        $availableDrivers = $driverCounts->get('available', 0);
        $pending_Drivers = $driverCounts->get('pending', 0);

        $busCounts = Bus::where('company_id', $company->id)
            ->selectRaw('status, COUNT(*) as count')
            ->groupBy('status')
            ->get()
            ->keyBy('status')
            ->mapWithKeys(function ($item) {
                return [$item->status => $item->count];
            });

        $privateTripCounts = Order_Private_Trip::where('company_id', $company->id)
            ->selectRaw('status, COUNT(*) as count')
            ->groupBy('status')
            ->get()
            ->keyBy('status')
            ->mapWithKeys(function ($item) {
                return [$item->status => $item->count];
            });

        $acceptedTotalPrice = Order_Private_Trip::where('company_id', $company->id)
            ->where('status', 'accepted')
            ->sum('price');

        $favourite_count =Favourite::where('company_id' , $company->id)->count();

        $dash = [
            'pending_reservations' => $reservationCounts->get('padding', 0),
            'completed_reservations' => $reservationCounts->get('completed', 0),
            'out_reservation' => $reservationCounts->get('out', 0),
            'pending_trip' => $trip_count->get('padding', 0),
            'finished_trip' => $trip_count->get('finished', 0),
            'finished_going_trip' => $trip_count->get('finished_going', 0),
            'pending_bus_trip' => $bus_trip->get('padding', 0),
            'finished_bus_trip' => $bus_trip->get('finished', 0),
            'finished_going_bus_trip' => $bus_trip->get('finished_going', 0),
            'total_profit_pending' => $reservationSums->get('padding', 0),
            'total_profit_completed' => $reservationSums->get('completed', 0),
            'total_profit_out' => $reservationSums->get('out', 0),
            'all_drivers' => $allDrivers,
            'pending_drivers' => $pending_Drivers,
            'available_drivers' => $availableDrivers,
            'completed_driver' => $completed_Drivers,
            'allBuses' => $busCounts->sum(),
            'completed_Buses' => $busCounts->get('completed', 0),
            'availableBuses' => $busCounts->get('available', 0),
            'pending_Buses' => $busCounts->get('pending', 0),
            'inProgress_PrivateTrips' => $privateTripCounts->get('padding', 0),
            'completed_PrivateTrips' => $privateTripCounts->get('accepted', 0),
            'canceled_PrivateTrips' => $privateTripCounts->get('cancelled', 0),
            'total_price_completed_PrivateTrips' => $acceptedTotalPrice,
            'count_favourite' => $favourite_count,

        ];

        return response()->json($dash);
    }


    public function statiesticle_dash()
    {
        $user = User::count();
        $company = Company::count();
        $driver = Driver::count();
        $trip = Trip::count();
        $reservationCounts = Reservation::selectRaw('status, COUNT(*) as count')
                ->groupBy('status')
                ->get()
                ->keyBy('status')
                ->mapWithKeys(function ($item) {
                    return [$item->status => $item->count];
                });


        $trip_count = Trip::selectRaw('status, COUNT(*) as count')
            ->groupBy('status')
            ->get()
            ->keyBy('status')
            ->mapWithKeys(function ($item) {
                return [$item->status => $item->count];
            });


        $reservationSums = Reservation::selectRaw('status, SUM(price) as sum')
            ->groupBy('status')
            ->get()
            ->keyBy('status')
            ->mapWithKeys(function ($item) {
                return [$item->status => $item->sum];
            });

        $bus_trip = Bus_Trip::selectRaw('status, COUNT(*) as count')
            ->groupBy('status')
            ->get()
            ->keyBy('status')
            ->mapWithKeys(function ($item) {
                return [$item->status => $item->count];
            });

        $driverCounts = Driver::selectRaw('status, COUNT(*) as count')
            ->groupBy('status')
            ->get()
            ->keyBy('status')
            ->mapWithKeys(function ($item) {
                return [$item->status => $item->count];
            });
        $allDrivers = $driverCounts->sum();
        $completed_Drivers = $driverCounts->get('completed', 0);
        $availableDrivers = $driverCounts->get('available', 0);
        $pending_Drivers = $driverCounts->get('pending', 0);

        $busCounts = Bus::selectRaw('status, COUNT(*) as count')
            ->groupBy('status')
            ->get()
            ->keyBy('status')
            ->mapWithKeys(function ($item) {
                return [$item->status => $item->count];
            });

        $privateTripCounts = Order_Private_Trip::selectRaw('status, COUNT(*) as count')
            ->groupBy('status')
            ->get()
            ->keyBy('status')
            ->mapWithKeys(function ($item) {
                return [$item->status => $item->count];
            });
        $acceptedTotalPrice = Order_Private_Trip::where('status', 'accepted')
            ->sum('price');


        $favourite_count =Favourite::count();

        $all_user=User::count();
        $all_company=Company::count();

        $dash = [
            'pending_reservations' => $reservationCounts->get('padding', 0),
            'completed_reservations' => $reservationCounts->get('completed', 0),
            'out_reservation' => $reservationCounts->get('out', 0),
            'pending_trip' => $trip_count->get('padding', 0),
            'finished_trip' => $trip_count->get('finished', 0),
            'finished_going_trip' => $trip_count->get('finished_going', 0),
            'pending_bus_trip' => $bus_trip->get('pending', 0),
            'finished_bus_trip' => $bus_trip->get('finished', 0),
            'finished_going_bus_trip' => $bus_trip->get('finished_going', 0),
            'total_profit_pending' => $reservationSums->get('padding', 0),
            'total_profit_completed' => $reservationSums->get('completed', 0),
            'total_profit_out' => $reservationSums->get('out', 0),
            'all_drivers' => $allDrivers,
            'pending_drivers' => $pending_Drivers,
            'available_drivers' => $availableDrivers,
            'completed_driver' => $completed_Drivers,
            'allBuses' => $busCounts->sum(),
            'completed_Buses' => $busCounts->get('completed', 0),
            'availableBuses' => $busCounts->get('available', 0),
            'pending_Buses' => $busCounts->get('pending', 0),
            'inProgress_PrivateTrips' => $privateTripCounts->get('padding', 0),
            'completed_PrivateTrips' => $privateTripCounts->get('accepted', 0),
            'canceled_PrivateTrips' => $privateTripCounts->get('cancelled', 0),
            'total_price_completed_PrivateTrips' => $acceptedTotalPrice,
            'count_favourite' => $favourite_count,
            'all_user' => $all_user,
            'all_company' => $all_company,


        ];

        return response()->json($dash);

    }



}
