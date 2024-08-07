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
/*/// Import Laravel Echo
import Echo from 'laravel-echo';

// Initialize Echo
window.Echo = new Echo({
    broadcaster: 'pusher',
    key: '{{ env("PUSHER_APP_KEY") }}',
    cluster: '{{ env("PUSHER_APP_CLUSTER") }}',
    encrypted: true
});

// Listen for the trip-created event on the trip-channel channel
Echo.channel('trip-channel')
   .listen('.trip-created', (e) => {
        // Update your page with the new trip data
        console.log(e.trips1); // Check the data in the console
        // Update your HTML elements with the new data
        document.getElementById('trip-list').innerHTML = '';
        e.trips1.forEach((trip) => {
            document.getElementById('trip-list').innerHTML += `
                <li>
                    Trip ID: ${trip.id}
                    Path: ${trip.path.name}
                    Price: ${trip.price}
                    <!-- Add more fields as needed -->
                </li>
            `;
        });
    });* */
