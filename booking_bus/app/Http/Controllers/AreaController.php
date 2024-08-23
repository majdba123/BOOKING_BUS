<?php

namespace App\Http\Controllers;

use App\Models\Area;
use App\Models\Map\geolocation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class AreaController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $governments = Area::with('breaks')->get();
        return response()->json($governments);
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
        $validator = Validator::make($request->all(), [
            'name' => ['required', 'string', 'unique:areas,name'],
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
        $area = new Area();
        $area->name = $request->input('name');
        $area->geolocation_id = $Location->id;
        $area->save();

        return response()->json([
            'message' => 'Area_Created ',
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show($area_id)
    {
        $area = Area::find($area_id);
        if (!$area) {
            return response()->json(['error' => 'Area not found.'], 404);
        }
        $area->breaks; // eager load breaks relationship
        return response()->json($area);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Area $area)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request,  $area_id)
    {
        $area = Area::find($area_id);
        if (!$area) {
            return response()->json(['error' => 'Area not found.'], 404);
        }
        $validator = Validator::make($request->all(), [
            'name' => ['required', 'string', 'unique:areas,name,' . $area_id],
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
                ['id' => $area->geolocation_id],
                ['latitude' => $latFrom, 'longitude' => $longFrom]
            );

            $area->geolocation_id = $Location->id;
        }
        $area->name = $request->input('name');
        $area->save();
        return response()->json($area);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($area_id)
    {
        $area = Area::find($area_id);
        if (!$area) {
            return response()->json(['error' => 'Area not found.'], 404);
        }

        $area->delete();
        return response()->json([
            'message' => 'Area deleted successfully',
        ]);
    }
}
