<?php

namespace Database\Factories;

use App\Models\Company;
use App\Models\Path;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Path>
 */
class PathFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Path::class;
    public function definition(): array
    {
        return [
            'company_id' => Company::factory(), // create a company for each route
            'from' => $this->faker->city,
            'to' => $this->faker->city,
        ];
    }
}
