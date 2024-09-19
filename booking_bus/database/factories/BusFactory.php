<?php

namespace Database\Factories;

use App\Models\Bus;
use Illuminate\Support\Str;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Bus>
 */
class BusFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Bus::class;


    public function definition()

    {

        $company = CompanyFactory::new()->create();
        return [
            'company_id' => $company->id,
            'number_bus' => $this->faker->unique()->numberBetween(1000, 9999),
            'number_passenger' => $this->faker->numberBetween(10, 50),
            'status' => $this->faker->randomElement(['completed', 'pending', 'available']),
            'purchase_date' => $this->faker->dateTimeBetween('-10 years', 'now')->format('Y-m-d'),
            'purchase_price' => $this->faker->randomFloat(2, 50000, 300000),
            'lifespan_years' => $this->faker->numberBetween(5, 25),
            'bus_consumption' => $this->faker->randomFloat(2, 15, 25),
            'fuel_consumption' => $this->faker->randomFloat(2, 8, 20),
        ];
    }
}
