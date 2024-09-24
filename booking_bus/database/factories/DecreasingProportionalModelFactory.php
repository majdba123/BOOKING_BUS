<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\DecreasingProportionalModel>
 */
class DecreasingProportionalModelFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'number_of_station' => $this->faker->numberBetween(1, 10), // Random number of stations
            'Rate_of_Km'        => $this->faker->randomFloat(2, 1, 5), // Random rate per Km
            'min_price_for_Km'  => $this->faker->randomFloat(2, 10, 50), // Minimum price for Km
            'cost'              => $this->faker->randomFloat(2, 100, 1000), // Random cost
        ];
    }
}