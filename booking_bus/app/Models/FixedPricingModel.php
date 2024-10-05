<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class FixedPricingModel extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at',
    ];
    protected $fillable = ['cost'];

    public function busTrips()
    {
        return $this->morphMany(Trip::class, 'pricingModel');
    }
}
