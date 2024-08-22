<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class BreakTripEvent  implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    /**
     * Create a new event instance.
     */
    public $bus_trip;
    public $pivoit;

    public function __construct($bus_trip ,$pivoit)
    {
        $this->bus_trip = $bus_trip;
        $this->pivoit = $pivoit;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, \Illuminate\Broadcasting\Channel>
     */
    public function broadcastOn(): array
    {
        return ['trip-break-private-channel-' . $this->bus_trip->id];
    }


    public function broadcastAs()
    {
        return 'BreakTripEvent';
    }
}
