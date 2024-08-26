<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class tripgeolocationEvent implements shouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;
    public $lang;
    public $lat;
    public $bus_trip_id;
    /**
     * Create a new event instance.
     */
    public function __construct($lang ,$lat ,$bus_trip_id)
    {
        $this->lang = $lang;
        $this->lat = $lat;
        $this->bus_trip_id = $bus_trip_id;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, \Illuminate\Broadcasting\Channel>
     */
    public function broadcastOn(): array
    {
        return ['trip-geolocation-private-channel-' . $this->bus_trip_id];

    }

    public function broadcastAs()
    {
        return 'tripgeolocationEvent';
    }
}
