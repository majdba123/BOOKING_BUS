<?php

namespace Database\Seeders;

use App\Models\Seat;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class SeatSeedres extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Seat::factory()->count(3)->create();

    }
}
