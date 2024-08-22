<?php

use App\Models\Map\geolocation;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('areas', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->foreignIdFor(geolocation::class)->constrained()->onDelete('cascade')->onUpdate('cascade');
            $table->timestamps();
        });
        DB::table('areas')->insert([

            'name' => 'Nothing',
            'geolocation_id' => '1',
            'created_at' => now(),
            'updated_at' => now(),


        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('areas');
    }
};
