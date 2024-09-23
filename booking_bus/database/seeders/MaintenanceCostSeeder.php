<?php

namespace Database\Seeders;

use App\Models\MaintenanceCost;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class MaintenanceCostSeeder extends Seeder
{

    public function run(): void
    {
        MaintenanceCost::factory()->count(10)->create();
    }
}
