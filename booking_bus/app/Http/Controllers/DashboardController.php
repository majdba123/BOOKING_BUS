<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use App\Models\Reservation;
use App\Models\Trip;
use App\Models\Pivoit;
use App\Models\Bus_Trip;
use App\Models\User;
use App\Models\Driver;
use App\Models\Favourite;
use App\Models\Bus;
use App\Models\Order_Private_trip;
use Illuminate\Support\Facades\Auth;


class DashboardController extends Controller
{
    public function all_reservation()
    {
        $company = Auth::user()->Company;
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

    public function all_reservation_by_status(Request $request)
    {
        $status = $request->input('status');
        $company = Auth::user()->Company;
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

    public function all_reservation_by_bus_trip($bus_trip_id)
    {
        $company_id = Auth::user()->Company;

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

    public function reser_by_break($pivoit_id)
    {
        $pivoit =Pivoit::with('Reservation')->find($pivoit_id);

        return response()->json($pivoit);
    }

    public function my_dash_boad()
    {
        $company = Auth::user()->Company;

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

        ];

        return response()->json($dash);
    }

    public function get_profit_bus_trip($id_bus_trip)
    {
        $company = Auth::user()->Company->id;
        $bus_trip=Bus_Trip::find($id_bus_trip);
        // Check if the bus trip belongs to the company that made the request
        if ($bus_trip->bus->company_id != $company) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

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
        $company = Auth::user()->Company->id;
        $trip = Trip::find($id_trip);
        // Check if the trip belongs to the company that made the request
        if ($trip->company_id != $company) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

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

}
