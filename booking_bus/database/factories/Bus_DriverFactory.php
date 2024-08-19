<?php

namespace Database\Factories;

use App\Models\Bus;
use App\Models\Bus_Driver;
use App\Models\Driver;
use Google\Service\DriveActivity\Drive;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Bus_Driver>
 */
class Bus_DriverFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    protected $model = Bus_Driver::class;


    public function definition()
    {
        return [
            'bus_id' => Bus::factory(), // create a bus for each bus driver
            'driver_id' => Driver::factory(), // create a driver for each bus driver
            'status' => $this->faker->randomElement(['active', 'inactive']),

        ];

    }
}
