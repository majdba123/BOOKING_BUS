<?php

namespace Database\Factories;

use App\Models\Geolocation;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Private_trip>
 */
class Private_tripFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(), // Assumes you have a User factory
            'from' => $this->faker->city,
            'from_location' => Geolocation::factory(), // Assumes you have a Geolocation factory
            'to' => $this->faker->city,
            'to_location' => Geolocation::factory(), // Assumes you have a Geolocation factory
            'date' => $this->faker->date(),
            'start_time' => $this->faker->time(),
            'status' => 'padding', // Default status
            'Distance' => $this->faker->numberBetween(10, 1000), // Random distance
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }
}
