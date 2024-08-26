<?php

namespace Database\Factories;

use App\Models\Company;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Policy\SatisfactionRate\SatisfactionRate>
 */
class SatisfactionRateFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'company_id' => Company::factory(),
            'rate' => $this->faker->randomFloat(2, 1, 5),
            'description' => $this->faker->paragraph,
        ];
    }
}
