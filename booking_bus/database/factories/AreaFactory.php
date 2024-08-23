<?php

namespace Database\Factories;

use App\Models\Area;
use App\Models\Geolocation;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Area>
 */
class AreaFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [

            'name' => $this->faker->word,
            'geolocation_id' => Geolocation::factory(),
            'created_at' => now(),
            'updated_at' => now(),

        ];
    }
}
