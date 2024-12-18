<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\Company;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('buses', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignIdFor(Company::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->string('Brand');
            $table->softDeletes();
            $table->char('number_bus', 6)->unique();
            $table->integer('number_passenger')->default(0);
            $table->string('status')->default('pending');
            $table->date('purchase_date');
            $table->integer('purchase_price');
            $table->integer('lifespan_years');
            $table->integer('bus_consumption');
            $table->integer('fuel_consumption');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('buses');
    }
};
