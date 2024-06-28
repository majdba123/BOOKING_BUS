<?php

namespace App\Http\Controllers;

use App\Models\Driver;
use Illuminate\Http\Request;
use App\Models\Company;
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

        $driver = Driver::where('company_id', $company )->get();
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
        $company=Auth::user()->Company->id;
        $driver = Driver::where('company_id', $company )
               ->where('status' , $request->input('status'))
               ->get();
        return response()->json($driver, 200);
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
}
