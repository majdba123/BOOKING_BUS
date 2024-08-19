<?php

namespace Database\Factories;

use App\Models\Breaks;
use App\Models\Breaks_trip;
use App\Models\Trip;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Breaks_trip>
 */
class Breaks_tripFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Breaks_trip::class;


    public function definition()
    {
        return [
            'breaks_id' => Breaks::factory(), // create a break for each breaks trip
            'trip_id' => Trip::factory(), // create a trip for each breaks trip
        ];
    }
}
