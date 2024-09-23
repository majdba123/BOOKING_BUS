<?php

namespace App\Http\Controllers;

use App\Models\Bus;
use App\Models\MaintenanceCost;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class MaintenanceCostController extends Controller
{
    public function index()
    {
        try {
            $company = Auth::user()->Company;

            if (!$company) {
                return response()->json(['error' => 'Unauthorized. No company associated with the user.'], 403);
            }

            $maintenanceCosts = MaintenanceCost::whereHas('bus', function ($query) use ($company) {
                $query->where('company_id', $company->id);
            })
                ->get();

            return response()->json($maintenanceCosts);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred: ' . $e->getMessage()], 500);
        }
    }

    public function store(Request $request)
    {
        try {
            $company = Auth::user()->Company;

            if (!$company) {
                return response()->json(['error' => 'Unauthorized. No company associated with the user.'], 403);
            }

            $validatedData = $request->validate([
                'bus_id' => 'required|exists:buses,id',
                'cost' => 'required|numeric',
                'maintenance_date' => 'required|date',
                'description' => 'required|String'
            ]);

            $bus = Bus::where('id', $validatedData['bus_id'])
                ->where('company_id', $company->id)
                ->first();

            if (!$bus) {
                return response()->json(['error' => 'Bus not found or does not belong to your company.'], 403);
            }

            $maintenanceCost = MaintenanceCost::create($validatedData);
            return response()->json([
                'message' => 'Maintenance Cost add it successfully.'
            ], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred: ' . $e->getMessage()], 500);
        }
    }
    public function show($id)
    {
        try {
            $company = Auth::user()->Company;

            if (!$company) {
                return response()->json(['error' => 'Unauthorized. No company associated with the user.'], 403);
            }

            $maintenanceCost = MaintenanceCost::whereHas('bus', function ($query) use ($company) {
                $query->where('company_id', $company->id);
            })
                ->findOrFail($id);

            return response()->json($maintenanceCost);
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

            $maintenanceCost = MaintenanceCost::whereHas('bus', function ($query) use ($company) {
                $query->where('company_id', $company->id);
            })->findOrFail($id);

            $validatedData = $request->validate([
                'bus_id' => 'required|exists:buses,id',
                'cost' => 'required|numeric',
                'maintenance_date' => 'required|date',
                'description' => 'required|String',
            ]);

            $bus = Bus::where('id', $validatedData['bus_id'])
                ->where('company_id', $company->id)
                ->first();

            if (!$bus) {
                return response()->json(['error' => 'Bus not found or does not belong to your company.'], 403);
            }

            $maintenanceCost->update($validatedData);
            return response()->json([
                'message' => ' Update successfully.'
            ], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred: ' . $e->getMessage()], 500);
        }
    }

    public function destroy($id)
    {
        try {
            $company = Auth::user()->Company;

            if (!$company) {
                return response()->json(['error' => 'Unauthorized. No company associated with the user.'], 403);
            }

            $maintenanceCost = MaintenanceCost::whereHas('bus', function ($query) use ($company) {
                $query->where('company_id', $company->id);
            })->findOrFail($id);

            $maintenanceCost->delete();
            return response()->json(['message' => 'deleted successfully  '], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'An error occurred: ' . $e->getMessage()], 500);
        }
    }
}
