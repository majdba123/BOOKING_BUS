<?php

namespace Database\Seeders;
use App\Models\Area;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class AreaSeedres extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run()
    {
        Area::factory()->count(3)->create();
    }
}
