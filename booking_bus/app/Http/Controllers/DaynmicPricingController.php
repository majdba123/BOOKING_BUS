<?php

namespace App\Http\Controllers;

use App\Models\Bus_Trip;
use App\Models\DaynmicPricing;
use App\Http\Requests\StoreDaynmicPricingRequest;
use App\Http\Requests\UpdateDaynmicPricingRequest;
use App\Models\Bus;
use App\Models\Driver;
use App\Models\Path;
use Carbon\Carbon;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class DaynmicPricingController extends Controller
{

    public function calculateKm(Request $request)
    {


        $validator = Validator::make($request->all(), [
            'pathId' => 'required|exists:paths,id',
            'busId' => 'required|exists:buses,id',
            'priceOfLiter' => 'required|numeric|min:0',
        ]);

        // Check for validation errors
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }



        $fixedCost = 0;
        $variableCost = 0;

        $companyId = Auth::user()->Company->id;
        $InsuranceCost =  $this->getCurrentYearInsuranceCost();
        $wages = $this->getTotalMonthlyWages();
        $Depreciation = $this->getTotalMonthlyDepreciation();
        $expectedKm = $this->getTotalDistanceForPreviousMonth();
        if ($expectedKm == 0) {
            return response()->json(['error' => 'You do not have any previous trips to process the calculation!'], 400);
        }
        $fixedCost = ($InsuranceCost + $wages + $Depreciation) / $expectedKm;
        $fuelCost = $this->calculateFuelCostForTrip($request->input('pathId'), $request->input('busId'), $request->input('priceOfLiter'));

        $MaintenanceCost = $this->calculateMaintenanceCost($request->input('busId'), $request->input('pathId'));
        $variableCost = $fuelCost + $MaintenanceCost;
        $totalPriceForKm = $fixedCost + $variableCost;

        $roundedPriceForKm = round($totalPriceForKm, 2);
        return response()->json(['priceForKm' => $roundedPriceForKm]);

        // $this->calculateFuelCostForTrip();
    }


    public function getCurrentYearInsuranceCost()
    {
        $companyId = Auth::user()->Company->id;

        $currentYear = Carbon::now()->year;

        $buses = Bus::where('company_id', $companyId)
            ->with(['insuranceCosts' => function ($query) use ($currentYear) {
                $query->where('insurance_date', $currentYear);
            }])
            ->get();

        $totalInsuranceCost = $buses->reduce(function ($carry, $bus) {
            return $carry + $bus->insuranceCosts->sum('insurance_cost');
        }, 0);

        $monthlyInsuranceCost = $totalInsuranceCost / 12;

        return $monthlyInsuranceCost;
    }

    public function getTotalMonthlyWages()
    {
        $companyId = Auth::user()->Company->id;

        $totalWages = Driver::where('company_id', $companyId)->sum('Wages');

        return $totalWages;
    }

    public function getTotalMonthlyDepreciation()
    {
        $companyId = Auth::user()->Company->id;

        $buses = Bus::where('company_id', $companyId)->get();

        $totalMonthlyDepreciation = 0;

        foreach ($buses as $bus) {
            if ($bus->lifespan_years > 0) {
                $annualDepreciation = $bus->purchase_price / $bus->lifespan_years;
                $monthlyDepreciation = $annualDepreciation / 12;
                $totalMonthlyDepreciation += $monthlyDepreciation;
            }
        }

        return $totalMonthlyDepreciation;
    }

    public function getTotalDistanceForPreviousMonth()
    {
        $companyId = Auth::user()->Company->id;


        $previousMonthStart = Carbon::now()->subMonth()->startOfMonth()->toDateString();
        $previousMonthEnd = Carbon::now()->subMonth()->endOfMonth()->toDateString();




        $totalDistance = Bus_Trip::whereBetween('date_start', [$previousMonthStart, $previousMonthEnd])
            ->whereHas('trip.path', function ($query) use ($companyId) {
                $query->where('company_id', $companyId);
            })
            ->join('trips', 'bus__trips.trip_id', '=', 'trips.id') // Ensure you are joining correctly
            ->sum('trips.path_id'); // Assuming 'path_id' is the column holding distance; adjust if needed.



        return $totalDistance;
    }



    public function calculateFuelCostForTrip($pathId, $busId, $priceForLiter)
    {
        $bus = Bus::where('id', $busId)->firstOrFail();

        $path = Path::where('id', $pathId)->firstOrFail();
        $distance = $path->Distance;


        $fuelConsumptionRate = $bus->fuel_consumption;
        $bus_consumption = $bus->bus_consumption;
        $fuelPricePerLiter = $priceForLiter;

        if ($distance > 0 && $fuelConsumptionRate > 0) {

            $fuelNeeded = ($distance * $fuelConsumptionRate) / $bus_consumption;
            $fuelCost = $fuelNeeded * $fuelPricePerLiter;
        } else {
            $fuelNeeded = 0;
            $fuelCost = 0;
        }
        return $fuelCost;
    }

    public function calculateMaintenanceCost($busId, $pathId)
    {
        $companyId = Auth::user()->Company->id;

        $startDate = Carbon::now()->subMonth()->startOfMonth();
        $endDate = Carbon::now()->subMonth()->endOfMonth();

        $maintenanceCostTotal = Bus::where('id', $busId)
            ->where('company_id', $companyId)
            ->firstOrFail()
            ->maintenanceCosts()
            ->whereBetween('maintenance_date', [$startDate, $endDate])
            ->sum('cost');



        $completedTrips = Bus_Trip::where('bus_id', $busId)
            ->where('status', 'completed')
            ->whereBetween('date_start', [$startDate, $endDate])
            ->get();

        $totalDistance = $completedTrips->sum('path.Distance');

        $maintenanceCostPerKm = $totalDistance > 0 ? $maintenanceCostTotal / $totalDistance : 0;
        $path = Path::find($pathId);
        $total = $maintenanceCostPerKm * $path->Distance;
        return $total;
    }

    public function pricingMethod(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'Threshold' => 'required|numeric',
            'priceOfKm' => 'required|numeric',
            'numberOfStations' => 'required|integer|min:2',
            'Distance' => 'required',
        ]);

        // Check for validation errors
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $Distance = $request->input('Distance');
        $numberOfStations = $request->input('numberOfStations');
        $segmentDistance = $Distance / $numberOfStations;
        $Threshold = $request->input('Threshold');
        $priceOfKm = $request->input('priceOfKm');

        $b = $this->calculateRate($Threshold, $priceOfKm, $numberOfStations);
        $totalPrice = 0;
        for ($station = 1; $station <= $numberOfStations; $station++) {
            // حساب سعر الكيلو متر في هذه المحطة
            $segmentPrice = $this->calculatePricePerSegment($priceOfKm, $b, $station, $segmentDistance); // حساب سعر المقطع
            $totalPrice += $segmentPrice; // تجميع السعر
        }
        return response()->json(['price' => round($totalPrice, 2)]);
    }

    // المعامل
    public function calculateRate($Threshold, $a, $numberOfStations)
    {

        $x = $numberOfStations - 1; // عدد المحطات عدا الأخيرة
        $b = pow(($Threshold / $a), (1 / $x));

        return  $b;
    }

    // سعرالمقطع الواحد
    public function calculatePricePerSegment($priceOfKm, $Rate, $currentSegment, $segmentDistance)
    {

        $a = $priceOfKm; // السعر الأولي للكيلومتر بناء على الموشرات
        $b = $Rate; // المعامل (زيادة ام نقصان)
        $x = $currentSegment; // رقم المحطة الحالية


        $priceAtCurrentSegment = $a * pow($b, $x - 1);
        $segmentPrice = $segmentDistance * $priceAtCurrentSegment;
        return $segmentPrice;
    }
}
