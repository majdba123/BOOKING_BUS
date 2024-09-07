<?php

namespace App\Http\Controllers;

use App\Events\PrivateNotification;
use App\Models\Breaks;
use App\Models\Geolocation;
use App\Models\Path;
use App\Models\User;
use App\Models\UserNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class PathController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $company = Auth::user()->Company->id;

        $paths = Path::where('company_id', $company)->get();
        return response()->json($paths, 200);
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
        DB::beginTransaction();

        try {
            $validator = Validator::make($request->all(), [
                'from' => 'required|string',
                'to' => 'required|string',
                'lat_from' => ['required', 'regex:/^[-]?(([0-8]?[0-9])\.(\d+))|(90(\.0+)?)$/'],
                'long_from' => ['required', 'regex:/^[-]?((((1[0-7][0-9])|([0-9]?[0-9]))\.(\d+))|180(\.0+)?)$/'],
                'lat_to' => ['required', 'regex:/^[-]?(([0-8]?[0-9])\.(\d+))|(90(\.0+)?)$/'],
                'long_to' => ['required', 'regex:/^[-]?((((1[0-7][0-9])|([0-9]?[0-9]))\.(\d+))|180(\.0+)?)$/'],
                'Distance' => 'required',
            ]);

            if ($validator->fails()) {
                DB::rollBack();
                $errors = $validator->errors()->first();
                return response()->json(['error' => $errors], 422);
            }

            $lat_from = $request->input('lat_from');
            $long_from = $request->input('long_from');
            $lat_to = $request->input('lat_to');
            $long_to = $request->input('long_to');

            $fromLocation = geolocation::create([
                'latitude' => $lat_from,
                'longitude' => $long_from
            ]);

            $toLocation = geolocation::create([
                'latitude' => $lat_to,
                'longitude' => $long_to
            ]);

            $path = new Path();
            $path->from = $request->input('from');
            $path->to = $request->input('to');
            $path->company_id = Auth::user()->Company->id;
            $path->from_location = $fromLocation->id;
            $path->to_location = $toLocation->id;
            $path->Distance = $request->input('Distance');

            $path->save();


            $break = new Breaks();
            $break->name = "start";
            $break->path_id = $path->id;
            $break->geolocation_id = $fromLocation->id;

            $break->save();


            $break = new Breaks();
            $break->name = "end";
            $break->path_id = $path->id;
            $break->geolocation_id = $toLocation->id;

            $break->save();


           $d= Auth::user()->Company->id;


           $massage = "your  path created successfully:  $path->id  ";
           event(new PrivateNotification(  $d , $massage));
           UserNotification::create([
               'user_id' =>  Auth::user()->Company->user->id,
               'notification' => $massage,
           ]);
            $admins = User::where('type', 1)->get();

            foreach ($admins as $admin) {
                $admin_id = $admin->id;
                // Send the message to each admin using the $admin_id
                $massage = "  company created path trip : $path->id  by company:  $d ";
                event(new PrivateNotification($admin_id, $massage));
                UserNotification::create([
                    'user_id' => $admin_id,
                    'notification' => $massage,
                ]);
            }
            DB::commit();

            return response()->json([
                'message' => 'path Created ',
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'An error occurred while creating path'], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Path $path)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Path $path)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $pathh)
    {
        DB::beginTransaction();
        try {
            $company = Auth::user()->Company->id;
            $validator = Validator::make($request->all(), [
                'from' => 'required|string',
                'to' => 'required|string',
                'lat_from' => ['required', 'regex:/^[-]?(([0-8]?[0-9])\.(\d+))|(90(\.0+)?)$/'],
                'long_from' => ['required', 'regex:/^[-]?((((1[0-7][0-9])|([0-9]?[0-9]))\.(\d+))|180(\.0+)?)$/'],
                'lat_to' => ['required', 'regex:/^[-]?(([0-8]?[0-9])\.(\d+))|(90(\.0+)?)$/'],
                'long_to' => ['required', 'regex:/^[-]?((((1[0-7][0-9])|([0-9]?[0-9]))\.(\d+))|180(\.0+)?)$/'],
                'Distance' => 'required|numeric',
            ]);
            if ($validator->fails()) {
                DB::rollBack();
                $errors = $validator->errors()->first();
                return response()->json(['error' => $errors], 422);
            }
            $path = Path::findOrfail($pathh);
            if ($path->company_id !== $company) {
                DB::rollBack();
                return response()->json(['error' => 'you are not owner to update path'], 403);
            }
            if ($request->has('from')) {
                $path->from = $request->input('from');
            }
            if ($request->has('to')) {
                $path->to = $request->input('to');
            }
            if ($request->has('lat_from') && $request->has('long_from')) {
                $latFrom = $request->input('lat_from');
                $longFrom = $request->input('long_from');
                $fromLocation = geolocation::updateOrCreate(
                    ['id' => $path->from_location],
                    ['latitude' => $latFrom, 'longitude' => $longFrom]
                );
                $path->from_location = $fromLocation->id;
            }
            if ($request->has('lat_to') && $request->has('long_to')) {
                $latTo = $request->input('lat_to');
                $longTo = $request->input('long_to');
                $toLocation = geolocation::updateOrCreate(
                    ['id' => $path->to_location],
                    ['latitude' => $latTo, 'longitude' => $longTo]
                );
                $path->to_location = $toLocation->id;
            }
            if ($request->has('Distance')) {
                $path->Distance = $request->input('Distance');
            }
            $path->save();
            DB::commit();
            return response()->json($path);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'An error occurred while updating path'], 500);
        }
    }
    /**
     * Remove the specified resource from storage.
     */
    public function destroy($path)
    {
        $company = Auth::user()->Company->id;
        $path = Path::findOrfail($path);
        if ($path->company_id !== $company) {
            return response()->json(['error' => 'you are not owner to update path'], 403);
        }
        $path->delete();
        return response()->json([
            'message' => 'path deleted  ',
        ]);
    }
}
