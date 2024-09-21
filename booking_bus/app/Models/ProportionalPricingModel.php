<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProportionalPricingModel extends Model
{
    use HasFactory;
    protected $fillable = ['RatePerKm', 'cost'];

    public function busTrips()
    {
        return $this->morphMany(Bus_Trip::class, 'pricingModel');
    }
}
