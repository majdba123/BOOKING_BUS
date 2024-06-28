<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\Bus;
use App\Models\Trip;
return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('bus__trips', function (Blueprint $table) {
            $table->id();
            $table->foreignIdFor(Trip::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->foreignIdFor(Bus::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->string('from_time');
            $table->string('to_time');
            $table->enum('status', ['pending', 'active', 'completed'])->default('pending');
            $table->enum('type', ['all', 'going'])->default('all');
            $table->enum('event', ['stopped', 'started', 'arrived', 'departed'])->default('stopped');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('bus__trips');
    }
};
