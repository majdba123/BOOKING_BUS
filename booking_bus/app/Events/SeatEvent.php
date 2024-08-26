<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class SeatEvent implements shouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;
    public $bus_trip;
    public $seat;

    public function __construct($bus_trip ,$seat)
    {
        $this->bus_trip = $bus_trip;
        $this->seat = $seat;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, \Illuminate\Broadcasting\Channel>
     */
    public function broadcastOn(): array
    {
        return ['seat-private-channel-' . $this->bus_trip->id];

    }

    public function broadcastAs()
    {
        return 'SeatEvent';
    }
}
