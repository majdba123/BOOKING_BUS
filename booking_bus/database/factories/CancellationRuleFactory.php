<?php

namespace Database\Factories;

use App\Models\Policy\CancelTrip\CanceledTrip;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory
 */
class CancellationRuleFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'canceled_trip_id' => CanceledTrip::factory(), // Associate with a canceled trip
            'reason' => $this->faker->sentence(), // Generate a random reason
        ];
    }
}
