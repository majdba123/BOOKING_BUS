<?php

namespace Database\Seeders;

use App\Models\Bus_Trip;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class Bus_TTripSeedres extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Bus_Trip::factory()->count(3)->create();
    }
}
