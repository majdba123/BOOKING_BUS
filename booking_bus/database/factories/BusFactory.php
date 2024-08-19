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
            'status' => $this->faker->randomElement(['completed', 'pending' , 'available']),
        ];
    }
}
