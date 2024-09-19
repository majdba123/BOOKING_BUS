<?php

namespace Database\Factories;

use App\Models\Bus;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\InsuranceCost>
 */
class InsuranceCostFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'bus_id' => Bus::factory(),
            'insurance_cost' => $this->faker->randomFloat(2, 500, 5000),
            'insurance_date' => $this->faker->dateTimeBetween('-2 years', 'now')->format('Y'),
        ];
    }
}
