<?php

namespace Database\Seeders;

use App\Models\InsuranceCost;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class InsuranceCostSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        InsuranceCost::factory()->count(10)->create();
    }
}
