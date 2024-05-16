<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reservation extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'breaks_trip_id',
        'bus_trip_id',
        'price',
        'type',
        'status',

    ];
    public function user()
    {
        return $this->belongsTo(User::class , 'user_id');
    }
    public function breaks_trip()
    {
        return $this->belongsTo(Breaks_trip::class , 'breaks_trip_id');
    }
    public function bus_trip()
    {
        return $this->belongsTo(Bus_Trip::class , 'bus_trip_id');
    }
    public function seat_reservation()
    {
        return $this->hasMany(Seat_Reservation::class);
    }
}
