<?php

namespace Database\Seeders;

use App\Models\Bus;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class BusSeedres extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run()
    {
        Bus::factory()->count(3)->create();
    }
}
