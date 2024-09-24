<?php

namespace Database\Factories;

use App\Models\Trip;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Model>
 */
class RateTripFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(), // Assuming you have a User factory
            'trip_id' => Trip::factory(), // Assuming you have a Trip factory
            'rating' => $this->faker->numberBetween(1, 5), // Assuming rating is between 1 and 5
        ];
    }
}
