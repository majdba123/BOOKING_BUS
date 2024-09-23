<?php

namespace App\Models\Policy\CancelTrip;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CancellationReason extends Model
{
    use HasFactory;
    protected $fillable = ['reason', 'canceled_trip_id'];

    public function canceledTrip()
    {
        return $this->belongsTo(CanceledTrip::class);
    }
}
