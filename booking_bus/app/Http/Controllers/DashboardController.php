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
use Illuminate\Support\Facades\Cache;

class DashboardController extends Controller
{
    public function all_reservation(Request $request)
    {
        $company = Auth::user()->Company;
    
        // Get all reservations for the company through the trip->bus_trip->reservation relationship
        $reservations = $company->trip()->with('bus_trip.Reservation.seat_reservation.seat', 'bus_trip.Reservation.user', 'bus_trip.Reservation.pivoit.break_trip.break', 'bus_trip.Reservation.bus_trip.trip.path')
            ->get()
            ->flatMap(function ($trip) {
                return $trip->bus_trip->Reservation;
            })
            ->map(function ($reservation) {
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
                    'from' => $reservation->bus_trip->trip->path->from,
                    'to' => $reservation->bus_trip->trip->path->to,
                    'seats' => $seats // array of seat names or properties
                ];
            });
    
        $perPage = 4;
        $currentPage = $request->input('page', 1);
        $offset = ($currentPage - 1) * $perPage;
    
        $paginatedReservations = $reservations->slice($offset, $perPage)->values();
    
        return response()->json($paginatedReservations);
    }
    public function all_reservation_by_status(Request $request)
    {
        $status = $request->input('status');
        $company = Auth::user()->Company;

        $reservations = $company->trip()->with('bus_trip.Reservation.seat_reservation.seat', 'bus_trip.Reservation.user', 'bus_trip.Reservation.pivoit.break_trip.break', 'bus_trip.trip.path')->get()->map(function ($trip) {
            return $trip->bus_trip->map(function ($busTrip) {
                return $busTrip->reservation;
            });
        })->flatten(2);

        $reservations = $reservations->filter(function ($reservation) use ($status) {
            return str_contains($reservation->status, $status);
        })->map(function ($reservation) {
            return [
                'id' => $reservation->id,
                'price' => $reservation->price,
                'user_name' => $reservation->user->name,
                'user_id' => $reservation->user_id,
                'type' => $reservation->type,
                'status' => $reservation->status,
                'break' => $reservation->pivoit->break_trip->break->name,
                'from' => $reservation->pivoit->bus_trip->trip->path->from,
                'to' => $reservation->pivoit->bus_trip->trip->path->from,
            ];
        });

        $perPage = 4;
        $currentPage = $request->input('page', 1);
        $offset = ($currentPage - 1) * $perPage;

        $paginatedReservations = $reservations->slice($offset, $perPage)->values();

        return response()->json($paginatedReservations);
    }

    public function all_reservation_by_bus_trip($bus_trip_id)
    {
        $company_id = Auth::user()->Company;

        $reservations = Reservation::where('bus__trip_id', $bus_trip_id)
            ->whereHas('pivoit.bus_trip.trip.company', function ($query) use ($company_id) {
                $query->where('id', $company_id->id);
            })
            ->with('seat_reservation.seat', 'user', 'pivoit.break_trip.break', 'pivoit.bus_trip.trip.path')
            ->get()
            ->map(function ($reservation) {
                $seats = $reservation->seat_reservation->map(function ($seatReservation) {
                    return [
                        'id' => $seatReservation->seat->id,
                        'status' => $seatReservation->seat->status
                    ];
                });
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

        return response()->json($reservations);
    }

    public function reser_by_break($pivoit_id)
    {
        $pivoit = Pivoit::with('Reservation')->find($pivoit_id);

        return response()->json($pivoit);
    }

    public function my_dash_boad()
    {

        $company = Auth::user()->Company;
        $key = 'dashboard_company_' . $company->id;

        if (Cache::has($key)) {

            $dash = Cache::get($key);
        } else {
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

            $acceptedOrders = Order_Private_Trip::where('company_id', $company->id)
                ->where('status', 'accepted')
                ->with('pricing')
                ->get();

            $acceptedTotalPrice = $acceptedOrders->sum(function ($order) {
                return $order->pricing ? $order->pricing->cost : 0;
            });
            $favourite_count = Favourite::where('company_id', $company->id)->count();

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

            ];
            Cache::put($key, $dash, now()->addMinutes(45));
        }

        return response()->json($dash);
    }


    /*   public function get_profit_bus_trip($id_bus_trip)
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
*/

    public function get_profit_bus_trip($id_bus_trip)
    {

        $company = Auth::user()->Company->id;

        $bus_trip = Bus_Trip::with('Reservation')->find($id_bus_trip);


        // Check if the bus trip belongs to the company that made the request

        if ($bus_trip->bus->company_id != $company) {

            return response()->json(['error' => 'Unauthorized'], 401);
        }


        // Calculate the total price of completed and out reservations

        $total_price = $bus_trip->Reservation()
            ->whereIn('status', ['completed', 'out'])
            ->sum('price');
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
        $user = User::find($user_id)->load(['profile', 'address']);
        return response()->json($user);
    }


    public function getPriceData(Request $request)
    {
        $period = $request->input('period'); // daily, monthly, yearly
        $company = Auth::user()->Company; // get the authenticated company

        $reservations = Reservation::whereHas('bus_trip.trip.company', function ($query) use ($company) {
            $query->where('id', $company->id);
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

        $averageProfit = $this->calculateAverageProfit($prices);
        return response()->json(['period' => $request->input('period'), 'average_profit' => $averageProfit]);
    }


    public function calculateAverageProfit($prices)
    {
        if (empty($prices)) {

            return 0;
        }
        $sum = array_sum($prices);
        $count = count($prices);
        return $sum / $count;
    }
}
