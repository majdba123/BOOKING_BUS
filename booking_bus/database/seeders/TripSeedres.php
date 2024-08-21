<?php

namespace Database\Seeders;

use App\Models\Trip;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class TripSeedres extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Trip::factory()->count(3)->create();

    }
}
