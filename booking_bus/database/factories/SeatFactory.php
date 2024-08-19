<?php

namespace Database\Factories;

use App\Models\Bus;
use App\Models\Seat;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Seat>
 */
class SeatFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    
    protected $model = Seat::class;
    public function definition(): array
    {
        return [
            'bus_id' => Bus::factory(), // create a bus for each seat
            'status' => $this->faker->randomElement(['0', '1', '2','3']),
        ];
    }
}
