<?php

namespace Database\Seeders;

use App\Models\CappingPricingModel;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CappingPricingModelSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        CappingPricingModel::factory(10)->create();
    }
}
