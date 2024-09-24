<?php

namespace Database\Factories;

use App\Models\Bus;
use App\Models\Bus_Trip;
use App\Models\Trip;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Bus_Trip>
 */
class Bus_TripFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Bus_Trip::class;

    public function definition()
    {
        return [
            'trip_id' => Trip::factory(), // create a trip for each bus trip
            'bus_id' => Bus::factory(), // create a bus for each bus trip
            'status' => $this->faker->randomElement(['finished', 'pending']),
            'from_time_going' => $this->faker->time,
            'to_time_going' => $this->faker->time,
            'to_time_return' => $this->faker->time,
            'from_time_return' => $this->faker->time,
            'date_start' => $this->faker->date,
            'date_end' => $this->faker->date,
            'type' => $this->faker->randomElement(['all', 'going']),
            'event' => $this->faker->word,
        ];
    }
}
