<?php

namespace App\Http\Controllers;

use App\Events\PrivateNotification;
use App\Models\Bus;
use App\Models\Bus_Driver;
use Illuminate\Http\Request;
use App\Models\Seat;
use App\Models\User;
use App\Models\UserNotification;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class BusController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $company = Auth::user()->Company->id;
        $bus = Bus::where('company_id', $company)->get();
        return response()->json($bus, 200);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function get_bus_by_status(Request $request)
    {
        $company = Auth::user()->Company->id;

        $bus = Bus::where('company_id', $company)
            ->where('status', $request->input('status'))
            ->get();

        return response()->json($bus, 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        DB::beginTransaction();

        try {
            $company = Auth::user()->Company->id;

            $validator = Validator::make($request->all(), [
                'number_bus' => 'required|string',
                'number_passenger' => 'required|string',
                'purchase_date' => 'required|date',
                'purchase_price' => 'required|integer|min:1',
                'lifespan_years' => 'required|integer|min:1|max:100',
                'bus_consumption' => 'required|integer|min:1',
                'fuel_consumption' => 'required|integer|min:1'
            ]);

            if ($validator->fails()) {
                DB::rollBack();
                $errors = $validator->errors()->first();
                return response()->json(['error' => $errors], 422);
            }

            $bus = new Bus();
            $bus->number_bus = $request->input('number_bus');
            $bus->number_passenger = $request->input('number_passenger');
            $bus->company_id = $company;
            $bus->purchase_date = $request->input('purchase_date');
            $bus->purchase_price = $request->input('purchase_price');
            $bus->lifespan_years = $request->input('lifespan_years');
            $bus->bus_consumption = $request->input('bus_consumption');
            $bus->fuel_consumption = $request->input('fuel_consumption');
            $bus->save();


            $massage = "  created new BUS  : $bus->id";
            event(new PrivateNotification(Auth::user()->id, $massage));
            UserNotification::create([
                'user_id' => Auth::user()->id,
                'notification' => $massage,
            ]);


            $admins = User::where('type', 1)->get();
            foreach ($admins as $admin) {
                $admin_id = $admin->id;
                // Send the message to each admin using the $admin_id
                $massage = "  created new BUS  : $bus->id  by company: $company ";
                event(new PrivateNotification($admin_id, $massage));
                UserNotification::create([
                    'user_id' => $admin_id,
                    'notification' => $massage,
                ]);
            }

            $number_passenger = $bus->number_passenger;

            // Create seats equal to the number of passengers

            for ($i = 0; $i < $number_passenger; $i++) {
                $seat = new Seat();
                $seat->bus_id = $bus->id;
                $seat->save();
            }

            DB::commit();

            return response()->json([
                'message' => 'bus Created ',
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'An error occurred while creating bus'], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Bus $bus)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Bus $bus)
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
            // 'number_bus' => 'sometimes|string',
            // 'number_passenger' => 'sometimes|string',
            'purchase_date' => 'required|date',
            'purchase_price' => 'required|integer|min:1',
            'lifespan_years' => 'required|integer|min:1|max:100',
            'bus_consumption' => 'required|integer|min:1',
            'fuel_consumption' => 'required|integer|min:1'
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        $bus = Bus::find($id);

        // Check if the bus belongs to the same company as the authenticated user
        if ($bus->company_id !== $company) {
            return response()->json(['error' => 'Unauthorized to update bus'], 403);
        }
        if ($request->has('number_bus')) {
            $bus->number_bus = $request->input('number_bus');
        }
        if ($request->has('number_passenger')) {
            $bus->seat()->delete();
            $bus->number_passenger = $request->input('number_passenger');
            $bus->purchase_date = $request->input('purchase_date');
            $bus->purchase_price = $request->input('purchase_price');
            $bus->lifespan_years = $request->input('lifespan_years');
            $bus->bus_consumption = $request->input('bus_consumption');
            $bus->fuel_consumption = $request->input('fuel_consumption');
            // $number_passenger = $request->input('number_passenger');

            // for ($i = 0; $i < $number_passenger; $i++) {
            //     $seat = new Seat();
            //     $seat->bus_id = $bus->id;
            //     $seat->save();
            // }

            $bus->save();
        }




        return response()->json($bus);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $company = Auth::user()->Company->id;

        $bus = Bus::find($id);

        // Check if the bus belongs to the same company as the authenticated user
        if ($bus->company_id !== $company) {
            return response()->json(['error' => 'Unauthorized to delete bus'], 403);
        }

        $bus->delete();

        $pendingBusDrivers = Bus_Driver::where('bus_id', $id)
            ->where('status', 'pending')
            ->first();
        if ($pendingBusDrivers) {
            $pendingBusDrivers->status = 'cancelled';
            $pendingBusDrivers->save();
            $driver = $pendingBusDrivers->driver;
            $driver->status = 'available';
            $driver->save();
            $bus->delete();
        } else {
            $bus->delete();
        }

        return response()->json([
            'message' => 'bus deleted',
        ]);
    }



    public function getBusAvailableBus(Request $request)
    {
        $company = Auth::user()->Company->id;

        $bus = Bus::where('company_id', $company)
            ->whereIn('status', ['available', 'completed'])
            ->get();

        return response()->json($bus, 200);
    }

}
