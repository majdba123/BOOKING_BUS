<?php

namespace App\Http\Controllers;

use App\Models\Breaks;
use App\Models\Area;
use App\Models\Geolocation;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class BreaksController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index($area_id)
    {
        $breaks = Breaks::where('area_id', $area_id)->get();

        if ($breaks->isEmpty()) {
            return response()->json(['message' => 'No breaks found for this area.'], 404);
        }
        return response()->json($breaks);
    }
    public function allbreaks()
    {
        $breaks = Breaks::with('area')->get();

        if ($breaks->isEmpty()) {
            return response()->json(['message' => 'No breaks found for this area.'], 404);
        }
        $formattedBreaks = $breaks->map(function ($break) {
            return [
                'id' => $break->id,
                'area_id' => $break->area_id,
                'break_name' => $break->name,
                'latitude' => $break->latitude,
                'longitude' => $break->longitude,
                'area_name' => $break->area->name,
                'area_latitude' => $break->area ? $break->area->latitude : null,
                'area_longitude' => $break->area ? $break->area->longitude : null,
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
    public function store(Request $request, $area_idd)
    {
        $area = Area::find($area_idd);
        if (!$area) {
            return response()->json(['error' => 'Area not found.'], 404);
        }
        $validator = Validator::make($request->all(), [
            'name' => ['required', 'string', 'unique:breaks,name,'],
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
        $break = new Breaks();
        $break->name = $request->input('name');
        $break->area_id = $area_idd;
        $break->geolocation_id = $Location->id;

        $break->save();

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
        $break->delete();

        return response()->json([
            'message' => 'Break deleted successfully',
        ]);
    }
}
