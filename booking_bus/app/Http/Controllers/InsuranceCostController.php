<?php

namespace App\Http\Controllers;

use App\Models\Bus;
use App\Models\InsuranceCost;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class InsuranceCostController extends Controller
{
    public function index()
    {
        try {
            $company = Auth::user()->Company;

            if (!$company) {
                return response()->json(['error' => 'Unauthorized. No company associated with the user.'], 403);
            }

            $insuranceCosts = InsuranceCost::with('bus')
                ->whereHas('bus', function ($query) use ($company) {
                    $query->where('company_id', $company->id);
                })
                ->get();

            if ($insuranceCosts->isEmpty()) {
                return response()->json(['message' => 'No insurance costs found for the company\'s buses.'], 404);
            }

            return response()->json($insuranceCosts, 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred: ' . $e->getMessage()], 500);
        }
    }

    public function store(Request $request)
    {
        try {
            // Get the authenticated company
            $company = Auth::user()->Company;

            if (!$company) {
                return response()->json(['error' => 'Unauthorized. No company associated with the user.'], 403);
            }

            // Validate request data
            $validatedData = $request->validate([
                'bus_id' => 'required|exists:buses,id',
                'insurance_cost' => 'required|numeric',
                'insurance_date' => 'required|date',
            ]);

            // Check if the bus belongs to the authenticated company
            $bus = Bus::where('id', $validatedData['bus_id'])
                ->where('company_id', $company->id)
                ->first();

            if (!$bus) {
                return response()->json(['error' => 'Bus not found or does not belong to your company.'], 403);
            }

            // Create the insurance cost record
            $insuranceCost = InsuranceCost::create($validatedData);

            return response()->json($insuranceCost, 201);
        } catch (\Exception $e) {
            // Handle unexpected exceptions
            return response()->json(['error' => 'An error occurred: ' . $e->getMessage()], 500);
        }
    }

    public function show($id)
    {
        try {
            // Get the authenticated company
            $company = Auth::user()->Company;

            if (!$company) {
                return response()->json(['error' => 'Unauthorized. No company associated with the user.'], 403);
            }

            // Find the insurance cost with the associated bus, and check if the bus belongs to the company
            $insuranceCost = InsuranceCost::with('bus')
                ->whereHas('bus', function ($query) use ($company) {
                    $query->where('company_id', $company->id);
                })
                ->findOrFail($id);

            return response()->json($insuranceCost);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred: ' . $e->getMessage()], 500);
        }
    }

    public function update(Request $request, $id)
    {
        try {
            $company = Auth::user()->Company;

            if (!$company) {
                return response()->json(['error' => 'Unauthorized. No company associated with the user.'], 403);
            }

            $insuranceCost = InsuranceCost::whereHas('bus', function ($query) use ($company) {
                $query->where('company_id', $company->id);
            })->findOrFail($id);

            $validatedData = $request->validate([
                'bus_id' => 'required|exists:buses,id',
                'insurance_cost' => 'required|numeric',
                'insurance_date' => 'required|date',
            ]);

            $bus = Bus::where('id', $validatedData['bus_id'])
                ->where('company_id', $company->id)
                ->first();

            if (!$bus) {
                return response()->json(['error' => 'Bus not found or does not belong to your company.'], 403);
            }

            $insuranceCost->update($validatedData);

            return response()->json($insuranceCost);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred: ' . $e->getMessage()], 500);
        }
    }

    public function destroy($id)
    {
        try {
            // Get the authenticated company
            $company = Auth::user()->Company;

            if (!$company) {
                return response()->json(['error' => 'Unauthorized. No company associated with the user.'], 403);
            }

            $insuranceCost = InsuranceCost::whereHas('bus', function ($query) use ($company) {
                $query->where('company_id', $company->id);
            })->findOrFail($id);

            $insuranceCost->delete();

            return response()->json(null, 204);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred: ' . $e->getMessage()], 500);
        }
    }
}
