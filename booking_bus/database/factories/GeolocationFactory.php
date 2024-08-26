<?php

namespace Database\Factories;

use App\Models\Map\geolocation;
use Illuminate\Database\Eloquent\Factories\Factory;

// /**
//  * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\MAP\Geolocation>
//  */
class GeolocationFactory extends Factory
{



    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'latitude' => $this->faker->latitude,
            'longitude' => $this->faker->longitude,
        ];
    }
}
