<?php

namespace Database\Seeders;

use App\Models\Policy\CancellationRule\CancellationRule;
use App\Models\Policy\CancelTrip\CanceledTrip;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CancellationRuleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $canceledTrips = CanceledTrip::where('user_id', User::where('email', 'c@gmail.com')->first()->id)->pluck('id');

        foreach ($canceledTrips as $tripId) {
            // Create 3 cancellation reasons for each canceled trip
            for ($i = 0; $i < 3; $i++) {
                CancellationRule::factory()->create([
                    'canceled_trip_id' => $tripId,
                ]);
            }
        }
    }
}
