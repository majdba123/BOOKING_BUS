<?php

namespace App\Http\Controllers;

use App\Events\PrivateNotification;
use App\Models\inquires;
use App\Models\User;
use App\Models\UserNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class InquiresController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $user=Auth::user();
        $inquires= inquires::where('user_id', $user->id)->get();

        return response()->json($inquires);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function by_status(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|string|in:completed,pending,replyed',
          ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        $user=Auth::user();

        $inquires= inquires::where('user_id', $user->id)
                            ->where('status' ,$request->status)
                            ->get();


        return response()->json($inquires);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        DB::beginTransaction();
    
        try {
            $user = Auth::user();
    
            $validator = Validator::make($request->all(), [
                'email' => 'required|email',
                'quastion' => 'required|string',
            ]);
    
            if ($validator->fails()) {
                DB::rollBack();
                $errors = $validator->errors()->first();
                return response()->json(['error' => $errors], 422);
            }
    
            $inquires = new inquires();
            $inquires->email = $request->email;
            $inquires->quastion = $request->quastion;
            $inquires->user_id = $user->id;
            $inquires->save();

            $massage = " your  inquires store done : $inquires->id ";
            event(new PrivateNotification($user->id, $massage));
            UserNotification::create([
                'user_id' => $user->id,
                'notification' => $massage,
            ]);



            $admins = User::where('type', 1)->get();

            foreach ($admins as $admin) {
                $admin_id = $admin->id;
                // Send the message to each admin using the $admin_id
                $massage = "  user has a inquire $user->id ";
                event(new PrivateNotification($admin_id, $massage));
                UserNotification::create([
                    'user_id' => $admin_id,
                    'notification' => $massage,
                ]);
            }



            DB::commit();
    
            return response()->json([
                'message' => "store done"
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'An error occurred while storing inquires'], 500);
        }
    }
    /**
     * Display the specified resource.
     */
    public function admin_index()
    {

        $inquires = inquires::all();
        $data = [];

        foreach ($inquires as $inquire) {
            $data[] = [
                'id' => $inquire->id,
                'user_id' => $inquire->user_id,
                'user_name' => $inquire->user->name,
                'email_user' => $inquire->user->email,
                'email_for_reply' => $inquire->email,
                'question' => $inquire->quastion,
                'status' => $inquire->status,
                'created_at' => $inquire->created_at,
                'updated_at' => $inquire->updated_at,
            ];
        }

        return response()->json($data);
    }
    /**
     * Show the form for editing the specified resource.
     */
    public function admin_by_status(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|string|in:completed,pending,replyed',
          ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }
        $inquires = inquires::where('status' ,$request->status)->get();
        $data = [];

        foreach ($inquires as $inquire) {
            $data[] = [
                'id' => $inquire->id,
                'user_id' => $inquire->user_id,
                'user_name' => $inquire->user->name,
                'email_user' => $inquire->user->email,
                'email_for_reply' => $inquire->email,
                'question' => $inquire->quastion,
                'status' => $inquire->status,
                'created_at' => $inquire->created_at,
                'updated_at' => $inquire->updated_at,
            ];
        }

        return response()->json($data);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, inquires $inquires)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($inquires_id)
    {
        $user=Auth::user();
        $inquires=inquires::where('user_id',$user->id)->find($inquires_id);

        if(!$inquires)
        {
            return response()->json([
                'massage' => 'you dont have premission'
            ]);
        }
        $inquires->delete();
        return response()->json([
            'massage' => 'inquires delete done'
        ]);
    }
}
