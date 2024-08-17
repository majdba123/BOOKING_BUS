<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class CompanyNotification
{
    use Dispatchable, InteractsWithSockets, SerializesModels;
    public $company;
    public $notification;
    /**
     * Create a new event instance.
     */
    public function __construct($company ,$notification)
    {
        $this->company =$company;
        $this->notification =$notification;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, \Illuminate\Broadcasting\Channel>
     */
    public function broadcastOn(): array
    {
        return ['private-company-notification-'. $this->company->id];

    }


    public function broadcastAs()
    {
        return 'CompanyNotification';
    }
}
