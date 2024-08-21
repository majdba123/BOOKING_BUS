<?php

namespace Database\Factories;

use App\Models\Bus_Trip;
use App\Models\Pivoit;
use App\Models\Reservation;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Reservation>
 */
class ReservationFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Reservation::class;
    public function definition()
    {
        return [
            'user_id' => $this->faker->numberBetween(1, 10), // assuming you have 10 users
            'pivoit_id' => Pivoit::factory(), // assuming you have 10 pivoits
            'bus__trip_id' => Bus_Trip::factory(), // assuming you have 10 bus trips
            'price' => $this->faker->randomFloat(1, 100),
            'type' => $this->faker->randomElement(['type1', 'type2', 'type3']),
            'status' => $this->faker->randomElement(['pending', 'confirmed', 'cancelled']),
        ];
    }
}
