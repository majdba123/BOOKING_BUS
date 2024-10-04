<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class DecreasingProportionalModel extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at',
    ];
    protected $fillable = ['number_of_station', 'Rate_of_Km', 'min_price_for_Km', 'cost'];

    public function busTrips()
    {
        return $this->morphMany(Trip::class, 'pricingModel');
    }
}
