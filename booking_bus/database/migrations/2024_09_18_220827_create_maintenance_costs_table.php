<?php

use App\Models\Bus;
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
        Schema::create('maintenance_costs', function (Blueprint $table) {
            $table->id();
            $table->softDeletes();
            $table->decimal('cost', 10, 2);
            $table->foreignIdFor(Bus::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->date('maintenance_date');
            $table->text('description');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('maintenance_costs');
    }
};
