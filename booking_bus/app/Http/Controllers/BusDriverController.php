<?php

namespace App\Http\Controllers;

use App\Events\PrivateNotification;
use App\Models\Bus_Driver;
use Illuminate\Http\Request;
use App\Models\Company;
use App\Models\Bus;
use App\Models\Bus_Trip;
use App\Models\user;
use App\Models\Driver;
use App\Models\UserNotification;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class BusDriverController extends Controller
{
    /**
     * Display a listing of the resource.
     */


    public function index()
    {
        $company = Auth::user()->Company;

        $busDrivers = $company->bus->load(['bus_driver' => function ($query) {
            $query->where('status', 'pending');
            $query->with('driver');
        }])->flatMap->bus_driver;

        $customData = $busDrivers->map(function ($busDriver) {
            return [
                'id' => $busDriver->id,
                'bus_id' => $busDriver->bus->id,
                'driver_name' => $busDriver->driver->user->name,
                'driver_phone' => $busDriver->driver->user->profile->phone ?? null,
                'status' => $busDriver->status,
                'company_name' => $busDriver->driver->company->user->name,
                'bus_plate_number' => $busDriver->bus->number_bus,
                // Add or remove fields as needed
            ];
        });

        return response()->json($customData);
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
    public function store(Request $request, $bus_id)
    {
        $driver_id = $request->input('driver_id');

        $driver = Driver::find($driver_id);

        if (!$driver) {
            return response()->json(['error' => 'Driver not found'], 404);
        }

        if ($driver->status !== 'pending') {
            return response()->json(['error' => 'Driver is not available'], 422);
        }

        $bus = Bus::find($bus_id);

        if (!$bus) {
            return response()->json(['error' => 'Bus not found'], 404);
        }

        if ($bus->status !== 'pending') {
            return response()->json(['error' => 'bus is not available'], 422);
        }
        // Create a new record in the bus_driver table
        $busDriver = new Bus_Driver();
        $busDriver->bus_id = $bus_id;
        $busDriver->driver_id = $driver_id;
        $busDriver->save();

        $massage = "YOU HAVE NEW BUS :  $bus_id";

        event(new PrivateNotification($driver->user->id, $massage));
        UserNotification::create([
            'user_id' =>$driver->user->id,
            'notification' => $massage,
        ]);

        // Update the status of the bus and driver to available
        $bus->status = 'available';
        $bus->save();

        $driver->status = 'available';
        $driver->save();

        return response()->json([
            'message' => 'Bus and driver assigned successfully',
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(Bus_Driver $bus_Driver)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Bus_Driver $bus_Driver)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Bus_Driver $bus_Driver)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function cancelAssignment($driver_id)
    {
        $busDriver = Bus_Driver::where('driver_id', $driver_id)->first();
        if (!$busDriver) {
            return response()->json(['error' => 'Assignment not found'], 404);
        }
        $busDriver->status = 'canceled';
        $busDriver->save();
        $bus = Bus::find($busDriver->bus_id);
        $bus->status = 'pending';
        $bus->save();

        $driver = Driver::find($driver_id);
        $driver->status = 'pending';
        $driver->save();

        
        $massage = "YOU cancelled of this bus   : $bus ->id ";

        event(new PrivateNotification($driver->user->id, $massage));
        UserNotification::create([
            'user_id' =>$driver->user->id,
            'notification' => $massage,
        ]);

        return response()->json([
            'message' => 'Assignment canceled successfully',
        ]);
    }


    public function bus_driveer()
    {
        $driver = Auth::user()->Driver;
        $busDriver = Bus_Driver::where('driver_id', $driver->id)->all();
        if (!$busDriver) {
            return response()->json(['error' => 'Assignment not found'], 404);
        }
    }



    public function getFirstTrip()
    {
        $validator = Validator::make([], [

            'driver_id' => 'required|exists:drivers,id',

        ]);


        if ($validator->fails()) {

            return response()->json(['error' => $validator->messages()], 422);

        }
        $user = Auth::user();

        $busDriver = Bus_Driver::where('driver_id', $user->Driver->id)->firstOrFail();

        $firstTrip = Bus_Trip::where('bus_id', $busDriver->bus_id)
            ->where('status', 'pending')
            ->orderBy('date_start', 'asc')
            ->orderBy('from_time_going', 'asc')
            ->first();

        if ($firstTrip) {
            $firstTrip->load(['trip.path']);
            $fromTime = new \DateTime($firstTrip->from_time_going);
            $toTime = new \DateTime($firstTrip->to_time_return);
            $interval = $fromTime->diff($toTime);

            $tripDuration = $interval->format('%H:%I');
            return response()->json([
                'id' => $firstTrip->id,
                'bus_id' => $firstTrip->bus_id,
                'from' => $firstTrip->trip->path->from ?? null,
                'to' => $firstTrip->trip->path->to ?? null,
                'Distance' => $firstTrip->trip->path->Distance ?? null,
                'from_time' => $firstTrip->from_time_going,
                'to_time' => $firstTrip->to_time_going,
                'Passengers' =>  $firstTrip->bus->getNumberOfReservationsAttribute(),
                'Stops' =>  $firstTrip->Pivoit->count(),
                'trip_duration' => $tripDuration,
                'status' => $firstTrip->status,
                // 'type' => $firstTrip->type,
                // 'event' => $firstTrip->event,

            ], 200);
        } else {
            return response()->json(['message' => 'No trips found for this driver.'], 404);
        }
    }


    public function getPointofDriver()
    {

        $user = Auth::user();

        $busDriverPoint = User::where('id', $user->id)->firstOrFail();

        if ($busDriverPoint) {

            return response()->json(['point' => $busDriverPoint->point], 200);
        } else {
            return response()->json(['message' => 'No Point found for this driver.'], 404);
        }
    }
}
