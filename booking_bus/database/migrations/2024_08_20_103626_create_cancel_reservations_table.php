<?php

use App\Models\Policy\CancellationRule\CancellationRule;
use App\Models\Reservation;
use App\Models\User;
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
        Schema::create('cancel_reservations', function (Blueprint $table) {
            $table->id();
            $table->foreignIdFor(Reservation::class)->constrained()->cascadeOnDelete();
            $table->foreignIdFor(CancellationRule::class)->constrained()->cascadeOnDelete();
            $table->decimal('refund_amount', 10, 2);
            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cancel_reservations');
    }
};
