<?php

namespace Database\Seeders;

use App\Models\FixedPricingModel;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class FixedPricingModelSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        FixedPricingModel::factory(10)->create();
    }
}
