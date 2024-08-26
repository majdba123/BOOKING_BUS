<?php

namespace Database\Factories;

use App\Models\Company;
use App\Models\Geolocation;
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
            'company_id' => Company::factory(),  // Assuming you have a factory for Company
            'from' => $this->faker->city,
            'from_location' => Geolocation::factory(),  // Assuming you have a factory for Geolocation
            'to' => $this->faker->city,
            'to_location' => Geolocation::factory(),    // Assuming you have a factory for Geolocation
            'Distance' => $this->faker->numberBetween(10, 1000),  // Random distance between 10 and 1000 km
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }
}
