<?php

namespace Database\Factories;

use App\Models\Profile;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Profile>
 */
class ProfileFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */

    protected $model = Profile::class;

    public function definition(): array
    {
        return [
            'user_id' => User::factory(), // You can adjust this if you have specific user IDs
            'phone' => $this->faker->phoneNumber,
            'image' => 'default.jpg', // Default image path
        ];
    }
}
