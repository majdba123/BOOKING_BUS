<?php

namespace Database\Factories;

use App\Models\Breaks_trip;
use App\Models\Bus_Trip;
use App\Models\Pivoit;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Pivoit>
 */
class PivoitFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Pivoit::class;
    public function definition()
    {
        return [
            'bus__trip_id' => Bus_Trip::factory(), // create a bus trip for each pivoit
            'breaks_trip_id' => Breaks_trip::factory(), // create a breaks trip for each pivoit
            'status' => $this->faker->randomElement(['pending']),

        ];

    }
}
