<?php

namespace App\Models\Policy\CancelTrip;

use App\Models\Trip;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class CanceledTrip extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at'
    ];

    protected $fillable = ['trip_id', 'description'];

    public function trip()
    {
        return $this->belongsTo(Trip::class);
    }

    public function cancellationReasons()
    {
        return $this->hasMany(CancellationReason::class);
    }
}
