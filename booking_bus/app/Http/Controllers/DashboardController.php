<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use App\Models\Reservation;
use App\Models\Pivoit;

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


}
