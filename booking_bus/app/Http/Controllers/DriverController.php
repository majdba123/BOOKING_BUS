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
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
class DriverController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $company=Auth::user()->Company->id;

        $driver = Driver::where('company_id', $company )->with(['company.user','user'])->get();
        return response()->json($driver, 200);
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

        $id= $user->id;
        $company_id =Auth::user()->Company->id;
        #return response()->json($id);

        $driver = Driver::create([
            'user_id' => $id,
            'company_id' => $company_id,
        ]);


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
                'id' => $driver->id,
                'name' => $driver->user->name,
                'email' => $driver->user->email,
                'status' => $driver->status,
                // Add or remove fields as needed
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
        $user_driver =$driver->user;
        $user_driver->delete();

        return response()->json([
            'message' => 'driver_deleted',
        ]);
    }

    public function my_bus()
    {
        $driver =Auth::user()->Driver;

        $bus= Bus_Driver::where('status', 'pending')
                        ->where('driver_id' , $driver->id)->first();

        $info=$bus->bus;
        $data=[
            'id_bus' => $info->id,
            'company_id' => $info->company_id,
            'company_name' => $info->company->name_company,
            'number_bus' => $info->number_bus,
            'number_passenger' => $info->number_passenger,
            'status' => $info->status,
        ];
        return response()->json($data);
    }

    public function my_pending_trip()
    {
        $driver = Auth::user()->Driver;

        $bus = Bus_Driver::where('status', 'pending')
                        ->where('driver_id', $driver->id)
                        ->first();

        $trip = Bus_Trip::where('status', 'pending')
                        ->where('bus_id', $bus->id)
                        ->first();

        $pivotData = [];
        foreach ($trip->Pivoit as $pivoit) {
            $pivotData[] = [
                'id' => $pivoit->id,
                'bus_trip_id' => $pivoit->bus__trip_id,
                'break_name' => $pivoit->break_trip->break->name,
                'status' => $pivoit->status,
            ];
        }

        $response = [

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

        return response()->json($response);
    }

    public function start_trip()
    {
        $driver = Auth::user()->Driver;

        $bus = Bus_Driver::where('status', 'pending')
                        ->where('driver_id', $driver->id)
                        ->first();

        $bus_trip = Bus_Trip::where('status', 'pending')
                        ->where('bus_id', $bus->id)
                        ->first();

        $name_breaks = $bus_trip->Pivoit->where('status', 'pending')->pluck('break_trip.break.name');

        if ($name_breaks->first() === "start") {
            $bus_trip->event = $name_breaks->first();
            $bus_trip->save();
            $pivoit_id=$bus_trip->Pivoit->first()->id;

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

        return response()->json($name_breaks->first());
    }


    public function finish_breaks($pivoit_id)
    {
        $driver = Auth::user()->Driver;

        $bus = Bus_Driver::where('status', 'pending')
                        ->where('driver_id', $driver->id)
                        ->first();

        $bus_trip = Bus_Trip::where('bus_id', $bus->id)
                        ->whereIn('status', ['pending', 'finished_going'])
                        ->first();

        $pivoit =Pivoit::where('bus__trip_id' , $bus_trip->id)
                        ->find($pivoit_id);


        $previous_pivoit = Pivoit::where('bus__trip_id', $bus_trip->id)
                        ->where('id', $pivoit_id - 1)
                        ->first();

        $next_pivoit = Pivoit::where('bus__trip_id', $bus_trip->id)
                        ->where('id', $pivoit_id + 1)
                        ->first();

        if($pivoit->status == 'pending')
        {
            if($pivoit->break_trip->break->name == "start")
            {
                $pivoit->status = 'done1';
                $pivoit->save();
                $bus_trip->event ='running';
                $bus_trip->save();
                return response()->json([
                    'massage' => '1'
                ]);
            }
            if($previous_pivoit->status == 'pending')
            {

                return response()->json([
                    'massage' => 'there is before breaks first '
                ]);
            }
            elseif($pivoit->break_trip->break->name == "end")
            {
                $pivoit->status = 'done2';
                $pivoit->save();

                $bus_trip->event ='running';
                $bus_trip->save();

                $bus_trip->status ='finished_going';
                $bus_trip->save();
                return response()->json([
                    'massage' => '2'
                ]);
            }
            else{
                if($previous_pivoit->status == 'done1' && $next_pivoit->status == 'pending')
                {
                    $pivoit->status = 'done1';
                    $pivoit->save();
                    $bus_trip->event ='running';
                    $bus_trip->save();
                    return response()->json([
                        'massage' => '3'
                    ]);
                }
            }
        }elseif($pivoit->status == 'done1')
        {

            if($pivoit->break_trip->break->name == "start" && $next_pivoit->status == 'done2')
            {
                $pivoit->status = 'done2';
                $pivoit->save();

                $bus_trip->event ='finished';
                $bus_trip->save();

                $bus_trip->status ='finished';
                $bus_trip->save();
                return response()->json([
                    'massage' => 'finished_going'
                ]);
            }
            if($pivoit->break_trip->break->name == "start" && $next_pivoit->status == 'dan1')
            {
                return response()->json([
                    'massage' => 'there is before breaks first'
                ]);
            }

            if($previous_pivoit->status == 'done1' && $next_pivoit->status == 'done2')
            {
                $pivoit->status = 'done2';
                $pivoit->save();
                $bus_trip->event ='running';
                $bus_trip->save();
                return response()->json([
                    'massage' => 'done'
                ]);
            }
        }
        elseif($pivoit->status == 'done2')
        {
            return response()->json([
                'massage' => 'can not this break alredy finished going and returned'
            ]);
        }

    }
}
