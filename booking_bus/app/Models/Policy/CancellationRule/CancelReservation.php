<?php

namespace App\Models\Policy\CancellationRule;

use App\Models\Reservation;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class CancelReservation extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at',
    ];
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
