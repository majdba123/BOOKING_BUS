<?php

namespace Database\Seeders;

use App\Models\Driver;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DriverSeedres extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run()
    {
        Driver::factory()->count(3)->create();
    }
}
