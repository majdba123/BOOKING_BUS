<?php

namespace Database\Seeders;

use App\Models\Seat_Reservation;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class Seat_ReservationSeedres extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Seat_Reservation::factory()->count(3)->create();

    }
}
