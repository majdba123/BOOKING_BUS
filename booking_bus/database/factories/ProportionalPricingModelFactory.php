<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\ProportionalPricingModel>
 */
class ProportionalPricingModelFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'RatePerKm' => $this->faker->randomFloat(2, 1, 5),  // Random rate per Km between 1 and 5
            'cost'      => $this->faker->randomFloat(2, 100, 1000), // Random cost
        ];
    }
}
