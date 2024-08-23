<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;
use App\Models\Bus;
use App\Models\Trip;
use App\Http\Controllers\BusTripController;
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



    public function test_store_method_updates_bus_and_driver_status()
    {

    }
}
