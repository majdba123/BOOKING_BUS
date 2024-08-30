<?php

namespace App\Http\Controllers;

use App\Events\PrivateNotification;
use App\Models\Policy\CancellationRule\CancelReservation;
use App\Models\Reservation;
use App\Models\Trip;
use App\Models\Breaks_trip;
use App\Models\Bus_Driver;
use App\Models\Bus_Trip;
use App\Models\Seat_Reservation;
use App\Models\Pivoit;
use App\Models\Bus;
use App\Models\Seat;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Events\SeatEvent;
use App\Models\Policy\CancellationRule\CancellationRule;
use App\Models\Policy\Reward\Reward;
use Carbon\Carbon;
use FFI\Exception;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

class ReservationController extends Controller
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
    public function store(Request $request, $bus_trip_id)
    {
        $lock = Cache::lock('reservation_locks', 10);
        if (!$lock) {
            return response()->json(['message' => 'Failed to acquire lock. Try again later.'], 500);
        }
    
        try {
            DB::beginTransaction();
    
            $bus_trip = Bus_Trip::findOrfail($bus_trip_id);
            $pivoit = $bus_trip->Pivoit->where('status', 'pending')->pluck('id');
            $validator = Validator::make($request->all(), [
                'type' => 'required|in:1,2',
                'seat' => 'nullable|array',
                'seat.*' => 'integer|exists:seats,id',
                'break_id' => 'nullable|integer|exists:pivoits,id|in:' . implode(',', $pivoit->all())
            ]);
            if ($validator->fails()) {
                DB::rollBack();
                $errors = $validator->errors()->first();
                return response()->json(['error' => $errors], 422);
            }
    
            $user_id = Auth::user()->id;
    
            $number_seattt = $bus_trip->bus->seat->count();
    
            $number_seat_complete = $bus_trip->bus->seat->where('status', 3)->count();
    
            if ($number_seat_complete == $number_seattt) {
                DB::rollBack();
                return response()->json([
                    'message' => "trip has completed can not",
                ]);
            }
    
            if ($bus_trip->status == 'finished_going' && $request->input('type') == 1) {
                DB::rollBack();
                return response()->json([
                    'massage' => 'trip finished going trips'
                ]);
            }
    
            $pivoit1 = Pivoit::where('bus__trip_id', $bus_trip->id)
                ->where('id', $request->input('break_id'))
                ->first();
    
            if ($pivoit1->break_trip->break->name == "start" &&  $request->input('type') == 2) {
                DB::rollBack();
                return response()->json([
                    'massage' => 'can not this is the las breake_start'
                ]);
            }
            if ($pivoit1->break_trip->break->name == 'end' &&  $request->input('type') == 1) {
                DB::rollBack();
                return response()->json([
                    'massage' => 'can not this is the last breake_end'
                ]);
            }
            if ($pivoit1->break_trip->break->name == $bus_trip->event) {
                DB::rollBack();
                return response()->json([
                    'massage' => 'the bus already in this break and it will leave '
                ]);
            }
            $seatInput = $request->input('seat');
            if (is_array($seatInput)) {
                $count_seat_of_user = count($seatInput);
            } else {
                $count_seat_of_user = 1;
            }
            $count_reservation = Seat_Reservation::where('status', 'pending')
                ->whereHas('seat', function ($query) use ($bus_trip) {
                    $query->where('bus_id', $bus_trip->bus->id);
                })
                ->count();
            if ($count_seat_of_user + $count_reservation >  2 * $number_seattt) {
                DB::rollBack();
                return response()->json([
                    'message' => "trip has completed can_____ not",
                ]);
            }
            $seats = $request->input('seat');
            $bus_seats = $bus_trip->bus->seat->pluck('id')->all();
    
            foreach ($seats as $seat_id) {
                $seat = Seat::find($seat_id);
                if (!$seat) {
                    DB::rollBack();
                    return response()->json([
                        'message' => 'seat not_found',
                    ]);
                }
                if (!in_array($seat_id, $bus_seats)) {
                    DB::rollBack();
                    return response()->json([
                        'message' => "Seat is not part of this bus's seat configuration",
                    ]);
                }
    
                if ($seat->status == 3) {
                    DB::rollBack();
                    return response()->json([
                        'message' => "Seat is not available",
                    ]);
                }
                if ($seat->status == $request->input('type')) {
                    DB::rollBack();
                    return response()->json([
                        'message' => "Seat already booking",
                    ]);
                }
            }
            $price1 = $bus_trip->trip->price;
    
            $price = $this->calculatePrice($price1, $count_seat_of_user);
            $user = auth()->user();
            if ($user->point < $price) {
                DB::rollBack();
                return response()->json(['message' => 'You do not have enough points to make this reservation']);
            }
    
            $reward = Reward::where('company_id', $bus_trip->bus->company->id)
                ->where('Reservation_Costs', '<=', $price)
                ->orderBy('Reservation_Costs', 'desc')
                ->first();
    
            if ($reward) {
                $reward_points = ($price * ($reward->reward_percentage / 100));
            } else {
                $reward_points = 0;
            }
    
            $user->point -= $price;
            $user->save();
    
            // إضافة المكافأة إلى نقاط المستخدم
            if ($reward_points > 0) {
                $user->point += $reward_points;
                $user->save();
    
                $user->rewards()->attach($reward->id);
            }
    
            $bookink = new Reservation();
            $bookink->user_id = $user_id;
            $bookink->bus__trip_id = $bus_trip_id;
            $bookink->pivoit_id = $request->input('break_id');
            $bookink->type = $request->input('type');
            $bookink->price = $price;
            $massage = " your booked is done : $bookink ";
            event(new PrivateNotification($user_id, $massage));
    
            $bookink->save();
    
            $reservation_id = $bookink->id;
    
            foreach ($seats as $seat_id) {
                $seat_reservation = new Seat_Reservation();
                $seat_reservation->reservation_id = $reservation_id;
                $seat_reservation->seat_id = $seat_id;
                $seat_reservation->save();
    
                $seat = Seat::find($seat_id);
                if ($request->input('type') == 1) {
                    if ($seat->status == 0) {
                        $seat->status = 1;
                    } elseif ($seat->status == 2) {
                        $seat->status = 3;
                    }
                    $seat->save();
                    event(new SeatEvent($bus_trip, $seat));
                } elseif ($request->input('type') == 2) {
                    if ($seat->status == 1) {
                        $seat->status = 3;
                    } elseif ($seat->status == 0) {
                        $seat->status = 2;
                    }
                    $seat->save();
                    event(new SeatEvent($bus_trip, $seat));
                }
            }
    
            $company = $bus_trip->bus->company->user;
            $company->point += $price;
            $company->save();
    
            DB::commit();
    
            $responseData = [
                'message' => 'Reservation created successfully',
                'reservation_id' => $bookink->id,
                'break' => $bookink->pivoit->break_trip->break->name,
                'bus_trip_id' => $bus_trip_id,
                'seats' => $bookink->seat_reservation->where('status', 'padding')->all(),
                'price' => $bookink->price,
                'user_name' => $bookink->user->name,
            ];
    
            return response()->json($responseData);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'An error occurred while creating reservation'], 500);
        } finally {
            $lock->release();
        }
    }


    public function calculatePrice($basePrice, $numberOfSeats)
    {
        return $basePrice * $numberOfSeats;
    }




    /**
     * Display the specified resource.
     */
    public function show(Reservation $reservation)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Reservation $reservation)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Reservation $reservation)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Reservation $reservation)
    {
        //
    }

    public function cancelReservation($reservationid)
    {

        $user_id = Auth::user()->id;


        DB::beginTransaction();
        try {
            $reservation = Reservation::with('bus_trip')
                ->where('id', $reservationid)
                ->where('user_id', $user_id)
                ->firstOrFail();


            if ($reservation->status === 'canceled') {
                return response()->json(['message' => 'Reservation already canceled'], 422);
            }


            // if (!$reservation->bus_trip) {
            //     dd('Bus trip is null', $reservation->toArray());
            // }
            // print($reservation);
            $departureDateTime = Carbon::parse($reservation->bus_trip->date . ' ' . $reservation->bus_trip->from_time);


            $hoursBefore = $departureDateTime->diffInHours(now());

            if ($hoursBefore <= 0) {
                return response()->json(['message' => 'The trip has already started and cannot be canceled.'], 422);
            }
            // print('the hours befor the trip is : ' . $hoursBefore);

            $cancellationRule = CancellationRule::where('company_id', $reservation->bus_trip->bus->company_id)
                ->where('hours_before', '<=', $hoursBefore)
                ->orderBy('hours_before', 'desc')
                ->first();
            if (!$cancellationRule) {
                $cancellationRule = CancellationRule::where('company_id', $reservation->bus_trip->bus->company_id)
                    ->orderBy('hours_before', 'asc')
                    ->first();
            }

            if ($cancellationRule) {
                $refundAmount = $reservation->price - ($reservation->price * ($cancellationRule->discount_percentage / 100));
            } else {
                $refundAmount = $reservation->price;
            }
            // print('the cancel rule apply is ' . $cancellationRule->discount_percentage);


            // $refundAmount = $reservation->price - ($reservation->price * ($cancellationRule->discount_percentage / 100));
            $user = $reservation->user;
            $user->point += $refundAmount;
            $user->save();

            $reservation->status = 'canceled';
            $reservation->save();


            foreach ($reservation->seat_reservation as $seat_reservation) {
                $seat = Seat::find($seat_reservation->seat_id);
                if ($seat) {

                    $seat->status = 0;
                    $seat->save();
                }


                $seat_reservation->status = 'canceled';
                $seat_reservation->save();
            }

            CancelReservation::create([
                'reservation_id' => $reservationid,
                'cancellation_rule_id' => $cancellationRule->id,
                'refund_amount' => $refundAmount,
            ]);

            //notifcation Majd

            DB::commit();
            return response()->json([
                'message' => 'Reservation canceled successfully',
                'refund_amount' => $refundAmount,
                'cancellation_rule' => $cancellationRule->description,
            ]);
        } catch (Exception $e) {

            DB::rollBack();
            return response()->json(['message' => 'An error occurred while canceling the reservation. Please try again later.'], 500);
        }
    }
}
