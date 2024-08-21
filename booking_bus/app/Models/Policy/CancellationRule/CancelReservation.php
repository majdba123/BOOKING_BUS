<?php

namespace App\Models\Policy\CancellationRule;

use App\Models\Reservation;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CancelReservation extends Model
{
    use HasFactory;
    protected $fillable = [
        'reservation_id',
        'cancellation_rule_id',
        'refund_amount',
    ];

    public function Reservation()
    {
        return $this->belongsTo(Reservation::class);
    }



    public function cancellationRule()
    {
        return $this->belongsTo(CancellationRule::class);
    }
}
