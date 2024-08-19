<?php

namespace Database\Seeders;

use App\Models\Bus_Driver;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class Bus_DriverSeedres extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Bus_Driver::factory()->count(3)->create();

    }
}
