<?php

namespace Database\Factories;

use App\Models\Driver;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Driver>
 */
class DriverFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Driver::class;
    public function definition()
    {
        $user = UserFactory::new()->create();
        $company = CompanyFactory::new()->create();
        return [
            'user_id' => $user->id,
            'company_id' => $company->id,
            'status' => $this->faker->randomElement(['completed', 'pending', 'available']),
            'Wages' => $this->faker->numberBetween(1000, 100000),
        ];
    }
}
