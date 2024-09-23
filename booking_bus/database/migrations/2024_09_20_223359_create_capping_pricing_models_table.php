<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('capping_pricing_models', function (Blueprint $table) {
            $table->id();
            $table->integer('number_of_station');
            $table->decimal('Rate_of_Km', 8, 2);
            $table->decimal('max_price_for_Km', 8, 2);
            $table->decimal('cost', 8, 2);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('capping_pricing_models');
    }
};
