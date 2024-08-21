<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class NewTrip implements shouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;
    public $trips1;
    /**
     * Create a new event instance.
     */
    public function __construct($trips1)
    {
        $this->trips1 = $trips1;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, \Illuminate\Broadcasting\Channel>
     */
    public function broadcastOn(): array
    {
        return ['trip_channel'];
    }

    public function broadcastAs()
    {
        return 'NewTrip';
    }
}

