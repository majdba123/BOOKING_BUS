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
        return [
            'company_id' => Company::factory(), // create a company for each trip
            'path_id' => Path::factory(), // create a path for each trip
            'status' => 'pending',
            'pricing_id'           => $this->faker->randomFloat(2, 50, 1000), // Random price
            'pricing_type'    => $this->faker->randomElement([
                FixedPricingModel::class,
                ProportionalPricingModel::class,
                DecreasingProportionalModel::class,
                CappingPricingModel::class
            ]),
            // 'price' => '20', // random price between 0 and 99999
        ];
    }
}
