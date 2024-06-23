<?php

namespace App\Http\Controllers;

use App\Models\Path;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
class PathController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $company=Auth::user()->Company->id;

        $paths = Path::where('company_id', $company )->get();
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
        $validator = Validator::make($request->all(), [
            'from' => 'required|string',
            'to' => 'required|string',
        ]);
        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        $path = new Path();
        $path->from = $request->input('from');
        $path->to = $request->input('to');
        $path->company_id = Auth::user()->id;
        $path->save();

        return response()->json([
            'message' => 'path Created ',
        ]);
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
    public function update(Request $request,  $pathh)
    {
        $validator = Validator::make($request->all(), [
            'from' => 'sometimes|string',
            'to' => 'sometimes|string',

        ]);
        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        $path=Path::findOrfail($pathh);
        if ($path->company_id!== auth()->user()->id) {
            return response()->json(['error' => 'you are not owner to update path'], 403);
        }
        $path->from = $request->input('from') ?? $path->from;
        $path->to = $request->input('to') ?? $path->to;
        $path->save();
        return response()->json([
            'message' => 'path updated',
        ]);
    }
    /**
     * Remove the specified resource from storage.
     */
    public function destroy($path)
    {
        $path=Path::findOrfail($path);
        if ($path->company_id!== auth()->user()->id) {
            return response()->json(['error' => 'you are not owner to update path'], 403);
        }
        $path->delete();
        return response()->json([
            'message' => 'path deleted  ',
        ]);
    }
}
