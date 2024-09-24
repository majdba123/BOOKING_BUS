<?php

namespace Database\Seeders;

use App\Models\Rate_Trips;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class RateTripSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Rate_Trips::factory()->count(10)->create();
    }
}
