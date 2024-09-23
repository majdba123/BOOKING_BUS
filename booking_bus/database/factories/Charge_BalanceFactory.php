<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Charge_Balance>
 */
class Charge_BalanceFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::where('email', 'user@gmail.com')->first()->id, // Set user ID for user@gmail.com
            'image' => $this->faker->imageUrl(), // Generate a random image URL
            'point' => $this->faker->numberBetween(100, 1000), // Generate a random point value
            'status' => 'pending', // Default status
        ];
    }
}
