<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class NewTrip
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
        return new Channel('trip-channel');
    }

    public function broadcastAs()
    {
        return 'trip-created';
    }
}
/*// Import the Pusher JavaScript SDK
const Pusher = require('pusher-js');

// Set up the Pusher client
const pusher = new Pusher('YOUR_APP_KEY', {
  cluster: 'YOUR_APP_CLUSTER',
  encrypted: true,
});

// Subscribe to the my-channel channel
const channel = pusher.subscribe('trip-channe');

// Bind an event listener to the trip-created event
channel.bind('trip-created', (data) => {
  // Update the home page with the new trip data
  console.log(data);
  // ...
});* */
