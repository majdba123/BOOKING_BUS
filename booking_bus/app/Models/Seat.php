<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Seat extends Model
{
    use HasFactory;
    protected $fillable = [
        'bus_id',
        'number_seat',
        'location_seat',
        'status',

    ];
    public function bus()
    {
        return $this->belongsTo(Bus::class , 'bus_id');
    }
    public function seat_reservation()
    {
        return $this->hasMany(Seat_Reservation::class);
    }
}
