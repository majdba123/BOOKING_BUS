<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\Seat;
use App\Models\Reservation;
return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('seat__reservations', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignIdFor(Seat::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->foreignIdFor(Reservation::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->string('status')->default('pending');
            $table->softDeletes();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('seat__reservations');
    }
};
