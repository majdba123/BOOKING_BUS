<?php

namespace Database\Factories;

use App\Models\Driver;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Model>
 */
class RateDriverFactory extends Factory
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
            'driver_id' => Driver::factory(), // Assuming you have a Driver factory
            'rating' => $this->faker->numberBetween(1, 5), // Assuming rating is between 1 and 5
            'rating_speed' => $this->faker->numberBetween(1, 10), // Example scale for speed rating
        ];
    }
}
