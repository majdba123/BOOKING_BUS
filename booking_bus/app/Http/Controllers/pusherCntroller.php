<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;


use Pusher\Pusher;
class pusherCntroller extends Controller
{
    public function auth(Request $request)
    {
        $pusher = new Pusher(
            env('PUSHER_APP_KEY'),
            env('PUSHER_APP_SECRET'),
            env('PUSHER_APP_ID'),
            [
                'cluster' => env('PUSHER_APP_CLUSTER'),
                'useTLS' => true,
            ]
        );
        $auth = $pusher->socket_auth($request->input('channel_name'), $request->input('socket_id'));
        return response($auth, 200);
    }
}
