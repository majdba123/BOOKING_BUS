<?php

namespace App\Http\Controllers;

use App\Models\Bus_Trip;
use App\Models\Trip;
use App\Models\Breaks_trip;
use App\Models\Bus_Driver;
use App\Models\Pivoit;
use App\Models\Bus;
use App\Models\Reservation;
use App\Models\Seat;
use App\Models\Seat_Reservation;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class BusTripController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(Bus_Trip $bus_Trip)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Bus_Trip $bus_Trip)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Bus_Trip $bus_Trip)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function getBusTripsByTripId($tripId)
    {

        $companyId = Auth::user();
        if ($companyId->company) {
            $trip = Trip::where('company_id', $companyId->company->id)->find($tripId);
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
            $fromTime = new \DateTime($busTrip->from_time);
            $toTime = new \DateTime($busTrip->to_time);
            $interval = $fromTime->diff($toTime);
            $tripDuration = $interval->format('%H:%I');
            $busTripData = [
                'bus_trip_id' => $busTrip->id,
                'bus_id' => $busTrip->bus_id,
                'nameCompany' => $trip->company->name_company,
                'from' => $trip->path->from,
                'to' => $trip->path->to,
                'price' => (int) $trip->price,
                'from_time_going' => $busTrip->from_time_going,
                'to_time_going' => $busTrip->to_time_going,
                'from_time_return' => $busTrip->from_time_return,
                'to_time_return' => $busTrip->to_time_return,
                'date_end' => $busTrip->date_end,
                'date_start' => $busTrip->date_start,
                'Distance' => $trip->path->Distance,
                'tripDuration' => $tripDuration,
                'type' => $busTrip->type,
                'event' => $busTrip->event,
                'seats' => $busTrip->bus->seat->count()

            ];

            $breaksData = [];
            foreach ($busTrip->Pivoit as $pivot) {
                $breakData = [
                    'break_id' => $pivot->id,
                    'name_break' => $pivot->break_trip->break->name,
                    'latitude' => $pivot->break_trip->break->latitude,
                    'longitude' => $pivot->break_trip->break->longitude,
                    'status' => $pivot->status,

                ];
                $breaksData[] = $breakData;
            }

            $busTripData['breaks'] = $breaksData;

            // $seats = $busTrip->bus->seat;
            // $seatsData = [];
            // foreach ($seats as $seat) {
            //     $seatsData[] = [
            //         'id' => $seat->id,
            //         'status' => $seat->status,
            //         // Add any other columns you want to include from the seats table
            //     ];
            // }
            // $busTripData['seats'] = $seatsData;

            $busTripsData[] = $busTripData;
        }

        return response()->json($busTripsData);
    }


    public function getBusTripsByFillter(Request $request)
    {
        $fromTime = $request->input('from_time_going');
        $toTime = $request->input('to_time_going');

        $fromTime_return = $request->input('from_time_return');
        $toTime_return = $request->input('to_time_return');
        $type = $request->input('type');
        $from = $request->input('from');
        $to = $request->input('to');

        $busTrips = Bus_Trip::query();

        if ($fromTime) {
            $busTrips->where('from_time_going', $fromTime);
        }

        if ($toTime) {
            $busTrips->where('to_time_going', $toTime);
        }

        if ($fromTime_return) {
            $busTrips->where('from_time_return', $toTime);
        }

        if ($toTime_return) {
            $busTrips->where('to_time_return', $toTime);
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
                'price_trip' => $busTrip->trip->price,
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

    public function get_fillter_bus_trip(Request $request)
    {
        $company = Auth::user()->Company->id;

        $validator = Validator::make($request->all(), [
            'from_time' => 'sometimes|string',
            'to_time' => 'sometimes|string',
            'type' => 'sometimes|string',
            'from' => 'sometimes|string',
            'to' => 'sometimes|string',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        $fromTime = $request->input('from_time_going');
        $toTime = $request->input('to_time_going');


        $fromTime_return = $request->input('from_time_return');
        $toTime_return = $request->input('to_time_return');

        $type = $request->input('type');
        $from = $request->input('from');
        $to = $request->input('to');

        $busTrips = Bus_Trip::whereHas('bus', function ($query) use ($company) {
            $query->where('company_id', $company);
        });
        if ($fromTime) {
            $busTrips->where('from_time_going', $fromTime);
        }
        if ($toTime) {
            $busTrips->where('to_time_going', $toTime);
        }
        if ($fromTime_return) {
            $busTrips->where('from_time_return', $fromTime);
        }
        if ($toTime_return) {
            $busTrips->where('to_time_return', $toTime);
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
                'price_trip' => $busTrip->trip->price,
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


    //code by hamza !!

    public function replaceBusTrip(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'bus_trip_id' => 'required|exists:bus_trips,id',
            'new_bus_id' => 'required|exists:buses,id',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }


        DB::beginTransaction();
        $bus_trip_id = $request->input('bus_trip_id');
        $new_bus_id = $request->input('new_bus_id');
        try {
            // Find the existing bus trip
            $busTrip = Bus_Trip::findOrFail($bus_trip_id);

            $oldBus = $busTrip->bus;

            if ($oldBus->status !== 'available') {
                return response()->json(['error' => 'The old bus is not available for replacement'], 422);
            }

            $newBus = Bus::findOrFail($new_bus_id);

            if ($newBus->status !== 'available') {
                return response()->json(['error' => 'The new bus is not available'], 422);
            }

            if ($newBus->number_passenger != $oldBus->number_passenger) {
                return response()->json(['error' => 'The new bus does not match the number of seats of the old bus'], 422);
            }

            $oldBus->status = 'moved';
            $oldBus->save();

            $newBusTrip = $busTrip->replicate();
            $newBusTrip->bus_id = $newBus->id;
            $newBusTrip->save();

            $reservations = Reservation::where('bus__trip_id', $bus_trip_id)->get();
            foreach ($reservations as $reservation) {
                $reservation->bus__trip_id = $newBusTrip->id;
                $reservation->save();

                // Update seat reservations
                $seatReservations = Seat_Reservation::where('reservation_id', $reservation->id)->get();
                foreach ($seatReservations as $seatReservation) {
                    $seat = Seat::find($seatReservation->seat_id);
                    if (!$seat) {
                        return response()->json(['error' => 'Seat not found'], 404);
                    }

                    // Transfer seat status to the new bus
                    if ($seat->bus_id == $oldBus->id) {
                        $newSeat = Seat::where('bus_id', $newBus->id)
                            ->where('number_seat', $seat->number_seat)
                            ->first();

                        if ($newSeat) {
                            $newSeat->status = $seat->status; // Set the new seat status to match the old seat status
                            $newSeat->save();
                        }
                    }

                    $seatReservation->save();
                }
            }


            $oldBusSeats = Seat::where('bus_id', $oldBus->id)->get();
            foreach ($oldBusSeats as $oldSeat) {
                $oldSeat->status = 0; //  seat as available
                $oldSeat->save();
            }

            $newBus->status = 'assigned';
            $newBus->save();

            // Commit the transaction
            DB::commit();

            //  notification Majdd!!!!!
            // driver: "Your trip has been canceled due to bus replacement. Please contact company management."
            // user: "The bus you booked has been changed. Please check the details of your trip."

            return response()->json([
                'message' => 'The new bus has been successfully added to the trip',
            ]);
        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json(['error' => 'An error occurred during the bus replacement process'], 500);
        }
    }
}
