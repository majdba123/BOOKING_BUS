<?php

use App\Models\Geolocation;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\User;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('private_trips', function (Blueprint $table) {
            $table->id();
            $table->foreignIdFor(User::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->string('from');
            $table->unsignedBigInteger('from_location');
            $table->foreign('from_location')->references('id')->on('geolocations')->cascadeOnUpdate()->cascadeOnDelete();
            $table->string('to');
            $table->unsignedBigInteger('to_location');
            $table->foreign('to_location')->references('id')->on('geolocations')->cascadeOnUpdate()->cascadeOnDelete();
            $table->string('date');
            $table->string('start_time');
            $table->string('status')->default('padding');
            $table->integer('Distance');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('private_trips');
    }
};
