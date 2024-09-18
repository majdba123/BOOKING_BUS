<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\Geolocation;
use App\Models\Path;
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
            $table->foreignIdFor(Path::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->string('name');
            $table->foreignIdFor(Geolocation::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->timestamps();
        });
        DB::table('breaks')->insert([
            [
               
                'path_id' => 1,
                'name' => 'start',
                'geolocation_id' => 1,
                'created_at' => now(),
                'updated_at' => now(),

            ],
            [
               
                'path_id' => 1,
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
