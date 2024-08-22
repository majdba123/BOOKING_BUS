<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\Area;
use App\Models\Map\geolocation;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('breaks', function (Blueprint $table) {
            $table->id();
            $table->foreignIdFor(Area::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->string('name');
            $table->foreignIdFor(geolocation::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->timestamps();
        });
        DB::table('breaks')->insert([
            [
                'area_id' => 1,
                'name' => 'start',
                'geolocation_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),

            ],
            [
                'area_id' => 1,
                'name' => 'end',
                'geolocation_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),

            ],
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('breaks');
    }
};
