<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Http\Request;
use App\Http\Controllers\DashboardController;

use Illuminate\Foundation\Testing\WithoutMiddleware; // Add this trait
use Illuminate\Http\JsonResponse;
use Tests\CreatesApplication;

class CalculateAverageProfitTest extends TestCase
{
    /**
     * A basic unit test example.
     */
    use RefreshDatabase;
    use WithoutMiddleware;
    use CreatesApplication;

    public function test_calculatePrice_returns_correct_price()
    {
        $controller = new DashboardController();
        $prices = [40, 288, 120, 50];
        $averageProfit = $controller->calculateAverageProfit($prices);
        $expectedAverageProfit = (40 + 288 + 120 + 50) / 4;
        $this->assertEquals($expectedAverageProfit, $averageProfit);
    }

    public function test_CalculateAverageProfitWithEmptyArray()
    {
        $prices = [];
        $controller = new DashboardController();
        $averageProfit = $controller->calculateAverageProfit($prices);
        $this->assertEquals(0, $averageProfit);
    }
    
    public function test_CalculateAverageProfitWithSingleElementArray()
    {
        $prices = [100];
        $controller = new DashboardController();
        $averageProfit = $controller->calculateAverageProfit($prices);
        $this->assertEquals(100, $averageProfit);
    }
}
