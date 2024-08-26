<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Bus extends Model
{
    use HasFactory;
    protected $fillable = [
        'company_id',
        'number_bus',
        'number_passenger',
        'status',
    ];
    public function bus_trip()
    {
        return $this->hasMany(Bus_Trip::class);
    }
    public function bus_driver()
    {
        return $this->hasMany(Bus_Driver::class);
    }
    public function seat()
    {
        return $this->hasMany(Seat::class);
    }
    public function company()
    {
        return $this->belongsTo(Company::class, 'company_id');
    }

    //hamza!!!!
    public function reservations()
    {
        return $this->hasManyThrough(Reservation::class, Bus_Trip::class);
    }
    public function getNumberOfReservationsAttribute()
    {
        return $this->reservations()->count();
    }
}
