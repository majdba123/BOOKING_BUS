<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\Company;
use App\Models\Geolocation;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('paths', function (Blueprint $table) {
            $table->id();
            $table->foreignIdFor(Company::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->string('from');
            $table->unsignedBigInteger('from_location');
            $table->foreign('from_location')->references('id')->on('geolocations')->cascadeOnUpdate()->cascadeOnDelete();
            $table->string('to');
            $table->unsignedBigInteger('to_location');
            $table->foreign('to_location')->references('id')->on('geolocations')->cascadeOnUpdate()->cascadeOnDelete();
            $table->integer('Distance');
            $table->softDeletes();
            $table->timestamps();
        });

        $company = Company::factory()->create();
        $fromLocation = Geolocation::factory()->create();
        $toLocation = Geolocation::factory()->create();
        DB::table('paths')->insert([
            'company_id' => $company->id,
            'from' => 'Nothing',
            'from_location' =>$fromLocation->id,
            'to' => 'Nothing',
            'to_location' => $toLocation->id,
            'Distance' => 0, // or some default value
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }



    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('paths');
    }
};
