<?php

namespace App\Http\Controllers;

use App\Models\FixedPricingModel;
use App\Http\Requests\StoreFixedPricingModelRequest;
use App\Http\Requests\UpdateFixedPricingModelRequest;

class FixedPricingModelController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
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
    public function store(StoreFixedPricingModelRequest $request)
    {
        $validatedData = $request->validate([
            'price' => 'required',
        ]);

        $fixedPricing = FixedPricingModel::create(['price' => $validatedData['price']]);

        return response()->json(['message' => 'Fixed pricing created successfully!', 'data' => $fixedPricing], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(FixedPricingModel $fixedPricingModel)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(FixedPricingModel $fixedPricingModel)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateFixedPricingModelRequest $request, FixedPricingModel $fixedPricingModel)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(FixedPricingModel $fixedPricingModel)
    {
        //
    }
}
