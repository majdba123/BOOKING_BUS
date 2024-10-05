<?php

namespace Database\Factories;

use App\Models\CappingPricingModel;
use App\Models\Company;
use App\Models\DecreasingProportionalModel;
use App\Models\FixedPricingModel;
use App\Models\Path;
use App\Models\ProportionalPricingModel;
use App\Models\Trip;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Trip>
 */
class TripFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Trip::class;
    public function definition()
    {
        $pricingModel = $this->faker->randomElement([
            FixedPricingModel::class,
            ProportionalPricingModel::class,
            DecreasingProportionalModel::class,
            CappingPricingModel::class
        ]);

        $pricing = $pricingModel::factory()->create();
        return [
            'company_id' => Company::factory(),
            'path_id' => Path::factory(),
            'status' => 'pending',
            'pricing_id' => $pricing->id,
            'pricing_type' => $pricingModel,

        ];
    }
}
