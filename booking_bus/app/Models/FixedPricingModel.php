<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FixedPricingModel extends Model
{
    use HasFactory;
    protected $fillable = ['cost'];

    public function busTrips()
    {
        return $this->morphMany(Trip::class, 'pricingModel');
    }
}
