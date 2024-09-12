<?php

namespace App\Http\Controllers;

use App\Models\UserNotification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserNotificationController extends Controller
{
    public function index()
    {

        $user = Auth::user()->id;
        $notifications = UserNotification::where('user_id', $user)
            ->where('status', 'pending')
            ->latest()->get();
        return response()->json($notifications);
    }


    public function readable_massege()
    {
        $user = Auth::user()->id;
        $notifications = UserNotification::where('user_id', $user)
            ->where('status', 'read')
            ->latest();
        return response()->json($notifications);
    }


    public function read($id)
    {
        $user_iid = Auth::user()->id;
        $notification = UserNotification::find($id);
        if (!$notification) {
            return response()->json([
                'error' => 'Notification not found',
            ], 404);
        }
        if ($notification->user_id !== $user_iid) {
            return response()->json([
                'error' => 'You are not authorized to read this notification',
            ], 403);
        }
        $notification->status = 'read';
        $notification->save();
        return response()->json([
            'message' => 'Notification marked as read',
        ]);
    }
}
