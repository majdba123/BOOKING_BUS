<?php

use Illuminate\Support\Facades\Broadcast;

/*
|--------------------------------------------------------------------------
| Broadcast Channels
|--------------------------------------------------------------------------
|
| Here you may register all of the event broadcasting channels that your
| application supports. The given channel authorization callbacks are
| used to check if an authenticated user can listen to the channel.
|
*/

Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id;
});


Broadcast::channel('private-notification-{id}', function () {
    return true;
});



Broadcast::channel('trip-break-private-channel-{id}', function () {
    return true;
});


Broadcast::channel('private-seat-channel-{id}', function () {
    return true;
});


Broadcast::channel('private-company-notification-{id}', function () {
    return true;
});
