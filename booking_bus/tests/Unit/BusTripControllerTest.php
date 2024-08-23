<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;
use App\Models\Bus;
use App\Models\Trip;
use App\Http\Controllers\ReservationController;
use App\Http\Controllers\TripController;
use App\Models\Breaks;
use App\Models\Breaks_trip;
use App\Models\Bus_Driver;
use App\Models\Bus_Trip;
use App\Models\Company;
use App\Models\Driver;
use App\Models\Path;
use App\Models\Pivoit;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Http\Request;
use Illuminate\Foundation\Testing\WithoutMiddleware; // Add this trait
use Illuminate\Http\JsonResponse;
use Tests\CreatesApplication;
use Mockery;

class BusTripControllerTest extends TestCase
{
    use RefreshDatabase;
    use WithoutMiddleware;
    use CreatesApplication;

    public function calculatePrice_returns_correct_price()

    {

        $controller = new ReservationController();
        $basePrice = 10;
        $numberOfSeats = 2;
        $result = $controller->calculatePrice($basePrice, $numberOfSeats);
        $this->assertEquals(20, $result);
    }
    /**

     * @test

     */
    public function calculatePrice_returns_zero_when_number_of_seats_is_zero()
    {
        $controller = new ReservationController();
        $basePrice = 10;
        $numberOfSeats = 0;
        $result = $controller->calculatePrice($basePrice, $numberOfSeats);
        $this->assertEquals(0, $result);
    }

    /**

     * @test

     */
    public function calculatePrice_returns_base_price_when_number_of_seats_is_one()
    {
        $controller = new ReservationController();
        $basePrice = 10;
        $numberOfSeats = 1;
        $result = $controller->calculatePrice($basePrice, $numberOfSeats);
        $this->assertEquals(10, $result);
    }
}
