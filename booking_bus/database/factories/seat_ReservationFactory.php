<?php

namespace Database\Factories;

use App\Models\Reservation;
use App\Models\Seat;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Seat_Reservation>
 */
class seat_ReservationFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'seat_id' => Seat::factory(), // assuming you have 50 seats
            'reservation_id' => Reservation::factory(), // assuming you have 10 reservations
            'status' => $this->faker->randomElement(['0', '1', '2','3']),
        ];
    }
}
