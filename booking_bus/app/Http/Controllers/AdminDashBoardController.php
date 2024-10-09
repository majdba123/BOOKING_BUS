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
use Illuminate\Support\Facades\Cache;

class AdminDashBoardController extends Controller
{
    public function all_user(Request $request)
    {
        $users = User::where('type', '!=', 1) // Exclude users with type 0
        ->doesntHave('driver')
        ->doesntHave('company')
        ->with(['profile', 'address'])
        ->latest()
        ->paginate(4);

        return response()->json([
            'data' => $users->items(),
            'pagination' => [
                'total' => $users->total(),
                'per_page' => $users->perPage(),
                'current_page' => $users->currentPage(),
                'last_page' => $users->lastPage(),
                'from' => $users->firstItem(),
                'to' => $users->lastItem(),
            ],
        ]);
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

    /*public function user_reservation($id)
    {
        $reservations = Reservation::where('user_id', $id)->get();
        $data = [];
        foreach ($reservations  as $reservation) {
            $info = [
                "user_name" => $reservation->user->name,
                "reservation_id" => $reservation->id,
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
    }*/


    /**
     * The current implementation uses lazy loading. In the foreach loop, you're accessing the relationships of the Reservation model, such as user, pivoit, break_trip, break, and seat_reservation. Each time you access these relationships, Laravel executes a separate query to retrieve the related data. This can lead to the N+1 query problem, where multiple queries are executed to retrieve the related data
     */
    public function user_reservation($id)
    {
        $reservations = Reservation::where('user_id', $id)
            ->with('user', 'pivoit.break_trip.break', 'seat_reservation.seat')
            ->get();
        $data = [];
        foreach ($reservations as $reservation) {
            $info = [
                "user_name" => $reservation->user->name,
                "reservation_id" => $reservation->id,
                "break_name" => $reservation->pivoit->break_trip->break->name,
                'pivoit_id' => $reservation->pivoit->id,
                "reservation_status" => $reservation->status,
                "reservation_type" => $reservation->type,
                "seat" => $reservation->seat_reservation->map(function ($seatReservation) {
                    return [
                        'seat_id' => $seatReservation->seat->id,
                        'status' => $seatReservation->status,
                        // add more fields as needed
                    ];
                })->all(),
            ];
            $data[] = $info;
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
    /**n this updated implementation, we're using the with method to eager load the relationships. This will load the related data in a single query, reducing the number of queries executed.

    Benefits of Eager Loading

    Eager loading offers several benefits, including:

        Improved performance: By loading related data in a single query, eager loading can reduce the number of queries executed, improving performance.
        Reduced query count: Eager loading can reduce the number of queries executed, which can help mitigate the N+1 query problem. */




    /* LAZY  public function all_trip_history_of_user($id)
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
                    'price_trip' => $busTrip->pricing->cost,
                    'from_time' => $busTrip->from_time,
                    'to_time' => $busTrip->to_time,
                    'date' => $busTrip->date,
                    'status' => $busTrip->status,
                    'type' => $busTrip->type,
                    'event' => $busTrip->event,
                ];
            })->all();

        return response()->json($customBusTrips);
    }*/
    //EAGER
    public function all_trip_history_of_user($id)
    {
        $reservations = Reservation::where('user_id', $id)
            ->with('bus_trip.trip.path')
            ->get();

        $customBusTrips = $reservations->map(function ($reservation) {
            $busTrip = $reservation->bus_trip;
            return [
                'id' => $busTrip->id,
                'from' => $busTrip->trip->path->from,
                'to' => $busTrip->trip->path->to,
                'price_trip' => $busTrip->trip->pricing->cost,
                'from_time_going' => $busTrip->from_time_going,
                'to_time_going' => $busTrip->to_time_going,
                'from_time_return' => $busTrip->from_time_return,
                'to_time_return' => $busTrip->to_time_return,
                'date_end' => $busTrip->date_end,
                'date_start' => $busTrip->date_start,
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
            $customBusTrips->where(function ($query) use ($request) {
                $query->where('date_start', '<=', $request->input('to_date'));

                $query->where('date_end', '>=', $request->input('from_date'));
            });
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
                    'price_trip' => $busTrip->trip->pricing->cost,
                    'from_time_going' => $busTrip->from_time_going,
                    'to_time_going' => $busTrip->to_time_going,
                    'from_time_return' => $busTrip->from_time_return,
                    'to_time_return' => $busTrip->to_time_return,
                    'date_end' => $busTrip->date_end,
                    'date_start' => $busTrip->date_start,
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
                'from_lat' => $Private_trip->from_latitude,
                'from_long' => $Private_trip->from_longitude,
                'to_lat' => $Private_trip->to_latitude,
                'to_long' => $Private_trip->to_longitude,
                'date' => $Private_trip->date,
                'start_time' => $Private_trip->start_time,
                'status' => $Private_trip->status,
                'order_private_trip' => $Private_trip->order_private_trip ? $Private_trip->order_private_trip->map(function ($orderPrivateTrip) {
                    return [
                        'id' => $orderPrivateTrip->id,
                        'company_id' => $orderPrivateTrip->company_id,
                        'company_name' => $orderPrivateTrip->company->name_company,
                        'price' => $orderPrivateTrip->pricing->cost,
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
                ->where('from', $from)
                ->with('order_private_trip')->get();
        }

        if ($to) {
            $Private_trips = Private_trip::where('user_id', $user_id)
                ->where('to', $to)
                ->with('order_private_trip')->get();
        }

        if ($status) {
            $Private_trips = Private_trip::where('user_id', $user_id)
                ->where('status', $status)
                ->with('order_private_trip')->get();
        }

        if ($start_time) {
            $Private_trips = Private_trip::where('user_id', $user_id)
                ->where('start_time', $start_time)
                ->with('order_private_trip')->get();
        }

        if ($date) {
            $Private_trips = Private_trip::where('user_id', $user_id)
                ->where('date', $date)
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
                'from_location' => $Private_trip->from_location,
                'to_location' => $Private_trip->to_location,
                'to' => $Private_trip->to,
                'date' => $Private_trip->date,
                'start_time' => $Private_trip->start_time,
                'status' => $Private_trip->status,
                'order_private_trip' => $Private_trip->order_private_trip ? $Private_trip->order_private_trip->map(function ($orderPrivateTrip) {
                    return [
                        'id' => $orderPrivateTrip->id,
                        'company_id' => $orderPrivateTrip->company_id,
                        'price' => $orderPrivateTrip->pricing->cost,
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
        $drivers = Driver::where('company_id', $company_id)->with('user.profile', 'user.address',)->get();
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
        $status = $request->input('status');

        if ($status) {
            $drivers->where('status', $status);
        }
        $drivers = $drivers->with('user.profile', 'user.address')->get();
        return response()->json($drivers);
    }

    public function all_bus_by_id_company($company_id)
    {
        $drivers = Bus::where('company_id', $company_id)->with('seat', 'company')->get();
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
        $trips = Trip::where('company_id', $company_id)->with(['bus_trip.Pivoit', 'breaks_trip.break', 'path'])->get();
        return response()->json($trips);
    }

    public function trip_by_status_of_company(Request $request, $company_id)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }
        $trips = Trip::where('company_id', $company_id)
            ->where('status', $request->input('status'))
            ->with(['bus_trip.Pivoit', 'breaks_trip.break', 'path'])->get();
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
                    'price_trip' => $busTrip->trip->pricing->cost,
                    'from_time_going' => $busTrip->from_time_going,
                    'to_time_going' => $busTrip->to_time_going,
                    'from_time_return' => $busTrip->from_time_return,
                    'to_time_return' => $busTrip->to_time_return,
                    'date_end' => $busTrip->date_end,
                    'date_start' => $busTrip->date_start,
                    'status' => $busTrip->status,
                    'type' => $busTrip->type,
                    'event' => $busTrip->event,

                ];

                $pivotData = $busTrip->Pivoit;
                $customPivotData = [];
                foreach ($pivotData as $pivot) {
                    $customPivotData[] = [
                        'break_id'  => $pivot->id,
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
                'price' => $trip->pricing->cost,
                'bus_trips' => $busTripsData,

                // Add any other columns you want to include from the trips table
            ];
        }
        return response()->json($data);
    }

    public function get_all_BusTripsByTripId(Request $request, $companyId)
    {
        $validator = Validator::make($request->all(), [
            'trip_id' => 'required|exists:trips,id,deleted_at,NULL',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $tripId = $request->input('trip_id');
        if ($companyId) {
            $trip = Trip::where('company_id', $companyId)->find($tripId);
            if (!$trip) {
                // Return an error or a default response if the trip is not found
                return response()->json(['error' => 'Trip not found'], 404);
            }
        } else {
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
                'price_trip' => $busTrip->pricing->cost,
                'from_time_going' => $busTrip->from_time_going,
                'to_time_going' => $busTrip->to_time_going,
                'from_time_return' => $busTrip->from_time_return,
                'to_time_return' => $busTrip->to_time_return,
                'date_end' => $busTrip->date_end,
                'date_start' => $busTrip->date_start,
                'status' => $busTrip->status,
                'type' => $busTrip->type,
                'event' => $busTrip->event,
            ];

            $breaksData = [];
            foreach ($busTrip->Pivoit as $pivot) {
                $breakData = [
                    'id' => $pivot->id,
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
        $fromTime = $request->input('from_time_going');
        $toTime = $request->input('to_time_going');
        $type = $request->input('type');
        $from = $request->input('from');
        $to = $request->input('to');
        $status = $request->input('status');


        $busTrips = Bus_Trip::query();

        if ($fromTime) {
            $busTrips->where('from_time_going', $fromTime);
        }

        if ($status) {
            $busTrips->where('status', $status);
        }

        if ($toTime) {
            $busTrips->where('to_time_going', $toTime);
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
                'price_trip' => $busTrip->pricing->cost,
                'from_time_going' => $busTrip->from_time_going,
                'to_time_going' => $busTrip->to_time_going,
                'from_time_return' => $busTrip->from_time_return,
                'to_time_return' => $busTrip->to_time_return,
                'date_end' => $busTrip->date_end,
                'date_start' => $busTrip->date_start,
                'status' => $busTrip->status,
                'type' => $busTrip->type,
                'event' => $busTrip->event,
            ];

            $breaksData = [];
            foreach ($busTrip->Pivoit as $pivot) {
                $breakData = [
                    'id' => $pivot->id,
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


    public function all_reservation_of_company($company_id, Request $request)
    {
        $company = Company::findOrfail($company_id);

        $reservations = $company->trip()->with('bus_trip.Reservation.seat_reservation.seat', 'bus_trip.Reservation.user', 'bus_trip.Reservation.pivoit.break_trip.break', 'bus_trip.trip.path')->get()->map(function ($trip) {
            return $trip->bus_trip->map(function ($busTrip) {
                return $busTrip->reservation;
            });
        })->flatten(2);

        $reservations = $reservations->map(function ($reservation) {
            $seats = [];
            foreach ($reservation->seat_reservation as $seatReservation) {
                $seats[] = [
                    'id' => $seatReservation->seat->id,
                    'status' => $seatReservation->seat->status
                ];
            }
            return [
                'id' => $reservation->id,
                'price' => $reservation->price,
                'type' => $reservation->type,
                'status' => $reservation->status,
                'user_name' => $reservation->user->name,
                'user_id' => $reservation->user_id,
                'break' => $reservation->pivoit->break_trip->break->name,
                'from' => $reservation->pivoit->bus_trip->trip->path->from,
                'to' => $reservation->pivoit->bus_trip->trip->path->to, // Corrected 'to' field
                'seats' => $seats // array of seat names or properties
            ];
        });

        $perPage = 4;
        $currentPage = $request->input('page', 1);
        $offset = ($currentPage - 1) * $perPage;

        $paginatedReservations = $reservations->slice($offset, $perPage)->values();

        return response()->json($paginatedReservations);
    }

    public function all_reservation_of_company__by_status(Request $request, $company_id)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $status = $request->input('status');
        $company = Company::findOrfail($company_id);

        $reservations = $company->trip()->with('bus_trip.Reservation.user', 'bus_trip.Reservation.pivoit.break_trip.break', 'bus_trip.trip.path')->get()->map(function ($trip) use ($status) {
            return $trip->bus_trip->map(function ($busTrip) use ($status) {
                return $busTrip->reservation->filter(function ($reservation) use ($status) {
                    return str_contains($reservation->status, $status);
                });
            });
        })->flatten(2);

        $reservations = $reservations->map(function ($reservation) {
            return [
                'id' => $reservation->id,
                'price' => $reservation->price,
                'user_name' => $reservation->user->name,
                'user_id' => $reservation->user_id,
                'type' => $reservation->type,
                'status' => $reservation->status,
                'break' => $reservation->pivoit->break_trip->break->name,
                'from' => $reservation->pivoit->bus_trip->trip->path->from,
                'to' => $reservation->pivoit->bus_trip->trip->path->to, // Corrected 'to' field
            ];
        });

        $perPage = 4;
        $currentPage = $request->input('page', 1);
        $offset = ($currentPage - 1) * $perPage;

        $paginatedReservations = $reservations->slice($offset, $perPage)->values();

        return response()->json($paginatedReservations);
    }


    public function all_reservation_by_bus_trip($id, Request $request)
    {
        $company_id = Company::findOrfail($id);

        $validator = Validator::make($request->all(), [
            'bus_trip_id' => 'required|exists:bus__trips,id,deleted_at,NULL',
        ]);
        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $bus_trip_id = $request->input('bus_trip_id');
        $company = Company::findOrfail($id);

        $reservations = $company->trip()->with('bus_trip.Reservation.seat_reservation.seat', 'bus_trip.Reservation.user', 'bus_trip.Reservation.pivoit.break_trip.break', 'bus_trip.trip.path')
            ->whereHas('bus_trip', function ($query) use ($bus_trip_id) {
                $query->where('id', $bus_trip_id);
            })
            ->get()->map(function ($trip) {
                return $trip->bus_trip->map(function ($busTrip) {
                    return $busTrip->reservation;
                });
            })->flatten(2);

        $reservations = $reservations->map(function ($reservation) {
            $seats = [];
            foreach ($reservation->seat_reservation as $seatReservation) {
                $seats[] = [
                    'id' => $seatReservation->seat->id,
                    'status' => $seatReservation->seat->status
                ];
            }
            return [
                'id' => $reservation->id,
                'price' => $reservation->price,
                'user_name' => $reservation->user->name,
                'user_id' => $reservation->user_id,
                'type' => $reservation->type,
                'status' => $reservation->status,
                'break' => $reservation->pivoit->break_trip->break->name,
                'from' => $reservation->pivoit->bus_trip->trip->path->from,
                'to' => $reservation->pivoit->bus_trip->trip->path->to,
                'seats' => $seats // array of seat names or properties
            ];
        });

        $perPage = 4;
        $currentPage = $request->input('page', 1);
        $offset = ($currentPage - 1) * $perPage;

        $paginatedReservations = $reservations->slice($offset, $perPage)->values();

        return response()->json($paginatedReservations);
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
            $reservations = $busTrip->Reservation()->whereIn('status', ['pending','completed', 'out'])->get();
            // Calculate the total price for each bus trip
            foreach ($reservations as $reservation) {
                $total_price += $reservation->price;
            }
        }

        return response()->json(['total_price' => $total_price]);
    }

    public function user_info($user_id)
    {
        $user = User::find($user_id)->load(['profile', 'address']);
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

        $trip_count = Trip::where('company_id', $company->id)
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
            ->with('pricing')
            ->get()
            ->sum(function ($order) {
                return $order->pricing ? $order->pricing->cost : 0;
            });

        $favourite_count = Favourite::where('company_id', $company->id)->count();

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
        $admin_id = Auth::user()->id;
        // $key = 'dashboard_company_' . $company->id;
        $key = 'dashboard_Admin_' . $admin_id;
        if (Cache::has($key)) {

            $dash = Cache::get($key);
        } else {

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
                ->with('pricing')
                ->get()
                ->sum(function ($order) {
                    return $order->pricing ? $order->pricing->cost : 0;
                });


            $favourite_count = Favourite::count();

            $all_user = User::where('type', '!=', 1) // Exclude users with type 0
                ->doesntHave('driver')
                ->doesntHave('company')->count();;
            $all_company = Company::count();

        $dash = [
            'pending_reservations' => $reservationCounts->get('pending', 0),
            'completed_reservations' => $reservationCounts->get('completed', 0),
            'out_reservation' => $reservationCounts->get('out', 0),
            'pending_trip' => $trip_count->get('pending', 0),
            'finished_trip' => $trip_count->get('finished', 0),
            'finished_going_trip' => $trip_count->get('finished_going', 0),
            'pending_bus_trip' => $bus_trip->get('pending', 0),
            'finished_bus_trip' => $bus_trip->get('finished', 0),
            'finished_going_bus_trip' => $bus_trip->get('finished_going', 0),
            'total_profit_pending' => $reservationSums->get('pending', 0),
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
            'inProgress_PrivateTrips' => $privateTripCounts->get('pending', 0),
            'completed_PrivateTrips' => $privateTripCounts->get('accepted', 0),
            'canceled_PrivateTrips' => $privateTripCounts->get('cancelled', 0),
            'total_price_completed_PrivateTrips' => $acceptedTotalPrice,
            'count_favourite' => $favourite_count,
            'all_user' => $all_user,
            'all_company' => $all_company,


            ];
            Cache::put($key, $dash, now()->addMinutes(45));
        }
        return response()->json($dash);
    }
    /**Lazy Loading vs Eager Loading in the statiesticle_dash Method
        In the statiesticle_dash method, you're using a mix of lazy loading and eager loading.
        Lazy Loading
        Lazy loading is used when you're accessing the relationships of a model, like User::count(), Company::count(), Driver::count(), etc. These queries are executed only when you access the relationships, which can lead to multiple queries being executed.
        Eager Loading
        Eager loading is used when you're using the selectRaw method with groupBy and get to retrieve the data, like: */

    public function getPriceData1(Request $request, $company_id)
    {
        $period = $request->input('period'); // daily, monthly, yearly
        $company = Company::find($company_id);
        if (!$company) {
            return response()->json(['error' => 'company not found '], 422);
        }
        $validator = Validator::make($request->all(), [
            'period' => ['required', 'string', 'in:daily,monthly,yearly'],
        ]);
        if ($validator->fails()) {
            // Return an error response if the validation fails
            return response()->json(['error' => 'Invalid request'], 422);
        }

        $reservations = Reservation::whereHas('bus_trip.trip.company', function ($query) use ($company_id) {
            $query->where('id', $company_id);
        })
            ->when($period === 'daily', function ($query) {
                $query->whereDate('created_at', today());
            })
            ->when($period === 'monthly', function ($query) {
                $query->whereMonth('created_at', now()->month);
            })
            ->when($period === 'yearly', function ($query) {
                $query->whereYear('created_at', now()->year);
            })
            ->select('price') // select only the price column
            ->get();

        $prices = $reservations->pluck('price')->toArray();
        //   var_dump($prices);
        if (empty($prices)) {
            return response()->json(['message' => 'No prices found for the given period'], 200);
        }

        $averageProfit = $this->calculateAverageProfit1($prices);
        return response()->json(['period' => $request->input('period'), 'average_profit' => $averageProfit]);
    }


    public function calculateAverageProfit1($prices)
    {
        if (empty($prices)) {

            return 0;
        }
        $sum = array_sum($prices);
        $count = count($prices);
        return $sum / $count;
    }
}
/**It depends on the situation.

Use Eager Loading when:

    You need to access the related data frequently.
    You want to reduce the number of queries executed.
    You want to improve performance.

Use Lazy Loading when:

    You only need to access the related data occasionally.
    You want to avoid loading unnecessary data.
    You want to reduce memory usage.
 */
