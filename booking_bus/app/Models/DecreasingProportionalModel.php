<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DecreasingProportionalModel extends Model
{
    use HasFactory;
    protected $fillable = ['number_of_station', 'Rate_of_Km', 'min_price_for_Km', 'cost'];

    public function busTrips()
    {
        return $this->morphMany(Bus_Trip::class, 'pricingModel');
    }
}
