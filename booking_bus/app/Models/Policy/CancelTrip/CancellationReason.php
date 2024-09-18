<?php

namespace App\Models\Policy\CancelTrip;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class CancellationReason extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at'
    ];
    protected $fillable = ['reason', 'canceled_trip_id'];

    public function canceledTrip()
    {
        return $this->belongsTo(CanceledTrip::class);
    }
}
