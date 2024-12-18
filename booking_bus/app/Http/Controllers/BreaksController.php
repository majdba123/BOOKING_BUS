<?php

namespace App\Http\Controllers;

use App\Events\PrivateNotification;
use App\Models\Breaks;
use App\Models\Geolocation;
use App\Models\Path;
use App\Models\Trip;
use App\Models\User;
use App\Models\UserNotification;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class BreaksController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($path_id)
    {

        $breaks = Breaks::where('path_id', $path_id)->get();

        $company = auth()->user()->Company; // assuming you have a `company` relationship on the User model

        $breaks = Breaks::where('path_id', $path_id)
            ->whereHas('path.company', function ($query) use ($company) {
                $query->where('id', $company->id);
            })
            ->get();
        if ($breaks->isEmpty()) {
            return response()->json(['message' => 'you are not owner of this breaks'], 404);
        }
        return response()->json($breaks);
    }


    public function allbreaks()
    {
        $company = Auth::user()->Company->id;
        $company = Auth::user()->Company->id;
        $paths = Path::where('company_id', $company)->get();
        if ($paths->isEmpty()) {
            return response()->json(['message' => 'No paths found for this company.'], 404);
        }
        $pathIds = $paths->pluck('id');
        $breaks = Breaks::whereIn('path_id', $pathIds)->get();
        if ($breaks->isEmpty()) {
            return response()->json(['message' => 'No breaks found for these paths.'], 404);
        }
        $formattedBreaks = $breaks->map(function ($break) {
            return [
                'id' => $break->id,
                'Path_id' => $break->path_id,
                'break_name' => $break->name,
                'latitude' => $break->latitude,
                'longitude' => $break->longitude,
            ];
        });

        // Return the result as a JSON response (if you're using API)
        return response()->json($formattedBreaks);
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
    public function store(Request $request, $path_id)
    {
        $Path = Path::find($path_id);
        if (!$Path) {
            return response()->json(['error' => 'Path not found.'], 404);
        }

        $company_id = $Path->company_id;
        $user = Auth::user();

        if ($user->Company->id !== $company_id) {
            return response()->json(['error' => 'You do not have permission to create a break for this path.'], 403);
        }


        $validator = Validator::make($request->all(), [
            'name' => ['required', 'string', ],
        ], [
            'name.required' => 'Name is required',
            'lat' => ['required', 'regex:/^[-]?(([0-8]?[0-9])\.(\d+))|(90(\.0+)?)$/'],
            'long' => ['required', 'regex:/^[-]?((((1[0-7][0-9])|([0-9]?[0-9]))\.(\d+))|180(\.0+)?)$/'],
        ]);
        if ($validator->fails()) {
            return response()->json(['error' => $validator->messages()], 422);
        }
        $lat = $request->input('lat');
        $long =   $request->input('long');
        $Location = geolocation::create([
            'latitude' => $lat,
            'longitude' => $long
        ]);
    // Get the end break of the path by its name

        $endBreak = Breaks::where('path_id', $path_id)->where('name', 'end')->first();
        if (!$endBreak) {
            return response()->json(['error' => 'End break not found.'], 404);
        }
        $break = new Breaks();
        $break->name = $request->input('name');
        $break->path_id = $path_id;
        $break->geolocation_id = $Location->id;
        // Update the order of breaks
        $break->save();

        $endBreak->id = $break->id + 1;
        $endBreak->save();

        $massage = " created new break  : $break->id";
        event(new PrivateNotification($user->id, $massage));
        UserNotification::create([
            'user_id' => $user->id,
            'notification' => $massage,
        ]);



        $admins = User::where('type', 1)->get();
        foreach ($admins as $admin) {
            $admin_id = $admin->id;
            // Send the message to each admin using the $admin_id
            $massage = "  created new break  : $break->id  by company: $company_id ";
            event(new PrivateNotification($admin_id, $massage));
            UserNotification::create([
                'user_id' => $admin_id,
                'notification' => $massage,
            ]);
        }

        return response()->json([
            'message' => 'break created ',
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(Breaks $breaks)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Breaks $breaks)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $break_id)
    {
        $break = Breaks::find($break_id);
        if (!$break) {
            return response()->json(['error' => 'Break not found.'], 404);
        }

        if (in_array(strtolower($break->name), ['start', 'end'])) {

            return response()->json(['error' => 'Cannot select this break as it is a start or end break.'], 422);

        }
        $trips = Trip::where('path_id', $break->path_id)
        ->where(function ($query) {
            $query->where('status', 'pending')
                  ->orWhere('status', 'finished_going');
        })
        ->exists();
        if ($trips) {
                 return response()->json(['error' => 'Cannot delete break because it has associated pending or finished trips.'], 422);
        }


        if ($break->path->company->id !== Auth::user()->Company->id) {

            return response()->json(['error' => 'You are not authorized to update this break.'], 403);
        }

        $validator = Validator::make($request->all(), [
            'name' => ['required', 'string', 'unique:breaks,name,' . $break_id . ',id'],
        ], [
            'name.required' => 'Name is required',
            'lat' => ['required', 'regex:/^[-]?(([0-8]?[0-9])\.(\d+))|(90(\.0+)?)$/'],
            'long' => ['required', 'regex:/^[-]?((((1[0-7][0-9])|([0-9]?[0-9]))\.(\d+))|180(\.0+)?)$/'],
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->messages()], 422);
        }
        if ($request->has('lat') && $request->has('long')) {
            $latFrom = $request->input('lat');
            $longFrom = $request->input('long');


            $Location = geolocation::updateOrCreate(
                ['id' => $break->geolocation_id],
                ['latitude' => $latFrom, 'longitude' => $longFrom]
            );

            $break->geolocation_id = $Location->id;
        }
        $break->name = $request->input('name');
        $break->save();

        return response()->json($break);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($break_id)
    {

        $break = Breaks::find($break_id);

        if (!$break) {
            return response()->json(['error' => 'Break not found.'], 404);
        }
        if ($break->path->company_id !== Auth::user()->Company->id) {
            return response()->json(['error' => 'You are not authorized to update this break.'], 403);
        }
        $trips = Trip::where('path_id', $break->path_id)
        ->where(function ($query) {
            $query->where('status', 'pending')
                  ->orWhere('status', 'finished_going');
        })
        ->exists();
        if ($trips) {
        return response()->json(['error' => 'Cannot delete break because it has associated pending or finished trips.'], 422);
        }
        $break->delete();

        return response()->json([
            'message' => 'Break deleted successfully',
        ]);
    }
}
