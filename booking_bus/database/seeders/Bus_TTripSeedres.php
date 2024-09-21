<?php

namespace Database\Seeders;

use App\Models\Bus_Trip;
use App\Models\CappingPricingModel;
use App\Models\DecreasingProportionalModel;
use App\Models\FixedPricingModel;
use App\Models\ProportionalPricingModel;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class Bus_TTripSeedres extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Bus_Trip::factory(10)->create()->each(function ($busTrip) {
            $randomPricingModel = collect([
                FixedPricingModel::class,
                ProportionalPricingModel::class,
                DecreasingProportionalModel::class,
                CappingPricingModel::class,
            ])->random();

            $pricingModelInstance = $randomPricingModel::factory()->create();

            $busTrip->pricing_id = $pricingModelInstance->id;
            $busTrip->pricing_type = $randomPricingModel;
            $busTrip->save();
        });
    }
}
