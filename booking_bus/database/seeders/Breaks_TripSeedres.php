<?php

namespace Database\Seeders;

use App\Models\Breaks_trip;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class Breaks_TripSeedres extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Breaks_trip::factory()->count(3)->create();

    }
}
