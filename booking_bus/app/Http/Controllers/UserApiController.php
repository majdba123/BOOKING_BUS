<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use App\Models\Company;
use App\Events\NotificatinEvent;
use App\Events\PrivateNotification;
use App\Models\Driver;
use App\Models\UserNotification;
use Illuminate\Support\Facades\Cache;

class UserApiController extends Controller
{
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
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        $user = User::create([
            'name' => $request->input('name'),
            'email' => $request->input('email'),
            'password' => Hash::make($request->input('password')),
        ]);

        $this->updateAllUsersCache();

        $admins = User::where('type', 1)->get();

        foreach ($admins as $admin) {
            $admin_id = $admin->id;
            // Send the message to each admin using the $admin_id
            $massage = "  created new user  : $user->id  ";
            event(new PrivateNotification($admin_id, $massage));
            UserNotification::create([
                'user_id' => $admin_id,
                'notification' => $massage,
            ]);
        }

        return response()->json([
            'message' => 'User Created ',
        ]);
    }

    private function updateAllUsersCache()
    {
        $key = 'all_users';
        $users = User::where('type', '!=', 1) // Exclude users with type 0
            ->doesntHave('driver')
            ->doesntHave('company')
            ->with(['profile', 'address'])
            ->get();
        Cache::put($key, $users, now()->addMinutes(30)); // Cache for 30 minutes
    }



    public function login(Request $request){
        $validator = Validator::make($request->all(), [
            'email'=>'required|string|email',
            'password'=>'required|min:8'
        ], [
            'email.required' => 'Email is required',
            'email.email' => 'Email is invalid',
            'password.required' => 'Password is required',
            'password.min' => 'Password must be at least 8 characters long',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        $user = User::where('email',$request->input('email'))->first();

        if(!$user || !Hash::check($request->input('password'),$user->password)){
            return response()->json([
                'message' => 'Invalid Credentials'
            ],401);
        }
        $type_user = '';
        if ($user->type == 1) {
            $type_user = 'admin';
        } elseif ($user->Company) {
            $type_user = 'company';
        } elseif ($user->Driver) {
            $type_user = 'driver';
        } else {
            $type_user = 'user';
        }

        $token = $user->createToken($user->name.'-AuthToken')->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'type_user'  => $type_user
        ]);
    }




    public function logout(){
        auth()->user()->tokens()->delete();

        return response()->json([
          "message"=>"logged out"
        ]);
    }

    public function get_all_company()
    {
        $companies = Company::with(['user.profile', 'user.address'])->get();
        return response()->json($companies);
    }

    public function get_all_driver()
    {
        $driver = Driver::with(['company','user.profile', 'user.address'])->get();
        return response()->json($driver);
    }
}
