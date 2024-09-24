<?php

namespace Database\Seeders;

use App\Models\Bus_Trip;
use App\Models\Policy\CancelTrip\CanceledTrip;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CanceledTripSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $userId = User::where('email', 'c@gmail.com')->first()->id;

        $busTrips = Bus_Trip::where('user_id', $userId)->pluck('id');

        foreach ($busTrips as $tripId) {
            CanceledTrip::factory()->create([
                'trip_id' => $tripId,
            ]);
        }
    }
}
