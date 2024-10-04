<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Address>
 */
class AddressFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $companyOwner = User::where('name', 'Company Owner')->first();

        return [
            'user_id' => $companyOwner ? $companyOwner->id : User::factory(),  // Link to the "Company Owner"
            'city' => $this->faker->city,
            'area' => $this->faker->streetName,
        ];
    }
}
