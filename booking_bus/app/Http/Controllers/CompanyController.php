<?php

namespace App\Http\Controllers;

use App\Events\PrivateNotification;
use App\Models\Company;
use App\Models\user;
use App\Models\Driver;
use App\Models\UserNotification;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class CompanyController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     */
    public function register(Request $request){
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
        $company = Company::create([
            'user_id' => $id,
            'name_company' => $user -> name,
        ]);

        $admins = User::where('type', 1)->get();

        foreach ($admins as $admin) {
            $admin_id = $admin->id;
            // Send the message to each admin using the $admin_id
            $massage = "  created new company  : $company->id   ";
            event(new PrivateNotification($admin_id, $massage));
            UserNotification::create([
                'user_id' => $admin_id,
                'notification' => $massage,
            ]);
        }
        return response()->json([
            'message' => 'company Created ',
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */


    /**
     * Display the specified resource.
     */
    public function show(Company $company)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Company $company)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Company $company)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Company $company)
    {
        //
    }
}
