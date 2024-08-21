<?php

namespace App\Models\Policy\CancelTrip;

use App\Models\Trip;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CanceledTrip extends Model
{
    use HasFactory;

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
