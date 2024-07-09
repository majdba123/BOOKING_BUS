<?php

namespace App\Http\Controllers;

use App\Models\Breaks;
use App\Models\Area;
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
    public function store(Request $request , $area_idd)
    {
        $area = Area::find($area_idd);
        if (!$area) {
            return response()->json(['error' => 'Area not found.'], 404);
        }
        $validator = Validator::make($request->all(), [
            'name' => ['required', 'string', 'unique:breaks,name,'],
        ], [
            'name.required' => 'Name is required',
        ]);
        if ($validator->fails()) {
            return response()->json(['error' => $validator->messages()], 422);
        }

        $break =New Breaks();
        $break->name =$request->input('name');
        $break->area_id =$area_idd;
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
            'name' => ['required', 'string', 'unique:breaks,name,'.$break_id.',id'],
        ], [
            'name.required' => 'Name is required',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->messages()], 422);
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
