<?php

namespace Database\Factories;

use App\Models\Area;
use App\Models\Breaks;
use App\Models\Geolocation;
use App\Models\Path;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Breaks>
 */
class BreaksFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Breaks::class;

    public function definition()
    {
        return [
            'name' => $this->faker->word,
            'path_id' => Path::factory(), // create an area for each break
            'geolocation_id' => Geolocation::factory(),
        ];
    }
}
