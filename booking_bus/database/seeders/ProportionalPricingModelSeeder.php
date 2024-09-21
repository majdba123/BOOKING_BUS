<?php

namespace Database\Seeders;

use App\Models\ProportionalPricingModel;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ProportionalPricingModelSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        ProportionalPricingModel::factory(10)->create();
    }
}
