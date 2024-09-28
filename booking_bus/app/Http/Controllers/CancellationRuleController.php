<?php

namespace App\Http\Controllers;

use App\Models\Company;
use App\Models\Policy\CancellationRule\CancellationRule;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class CancellationRuleController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $user = Auth::user();


        if (!$user->company) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $rules = CancellationRule::where('company_id', $user->company->id)->get();
        return response()->json($rules, 200);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'hours_before' => 'required|integer|min:0',
            'discount_percentage' => 'required|numeric|min:0|max:100',
            'description' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], 422);
        }

        $user = Auth::user();
        $company = $user->company;

        $rule = CancellationRule::create([
            'company_id' => $company->id,
            'hours_before' => $request->input('hours_before'),
            'discount_percentage' => $request->input('discount_percentage'),
            'description' => $request->input('description'),
        ]);

        return response()->json(['message' => 'Cancellation rule created successfully'], 200);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $rule = CancellationRule::find($id);

        if (!$rule) {
            return response()->json(['error' => 'Cancellation rule not found'], 404);
        }

        $user = Auth::user();


        if ($rule->company_id !== $user->company->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        return response()->json($rule, 200);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $validator = Validator::make($request->all(), [
            'hours_before' => 'required|integer|min:0',
            'discount_percentage' => 'required|numeric|min:0|max:100',
            'description' => 'nullable|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], 422);
        }

        $rule = CancellationRule::find($id);

        if (!$rule) {
            return response()->json(['error' => 'Cancellation rule not found'], 404);
        }

        $user = Auth::user();


        if ($rule->company_id !== $user->company->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $rule->hours_before = $request->input('hours_before');
        $rule->discount_percentage = $request->input('discount_percentage');
        $rule->description = $request->input('description');
        $rule->save();

        return response()->json(['message' => 'Cancellation rule updated successfully'], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $rule = CancellationRule::find($id);

        if (!$rule) {
            return response()->json(['error' => 'Cancellation rule not found'], 404);
        }

        $user = Auth::user();


        if ($rule->company_id !== $user->company->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $rule->delete();

        return response()->json(['message' => 'Cancellation rule deleted successfully'], 200);
    }

    public function GetCanceltionRuleforCompany($companyName)
    {
        $user = Auth::user();


        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }
        $company_id = Company::where('name_company', $companyName)->get();
        // print($company_id);
        $rules = CancellationRule::where('company_id', $company_id[0]->id)->get();


        $rule = $rules->sortBy('hours_before' . 'DEC')->map(function ($rule) {
            return collect($rule->toArray())
                ->only(['hours_before', 'discount_percentage', 'description'])
                ->all();
        })->values();
        return response()->json($rule, 200);
    }
}
