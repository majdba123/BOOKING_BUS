<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\CanceledTrip>
 */
class CanceledTripFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'trip_id' => Bus_TripFactory::factory(), // Associate with a bus trip
            'description' => $this->faker->paragraph(), // Generate a random description
        ];
    }
}
