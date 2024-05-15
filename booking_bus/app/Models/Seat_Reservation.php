<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Seat_Reservation extends Model
{
    use HasFactory;

    protected $fillable = [
        'seat_id',
        'reservation_id',
        'status',

    ];
    public function seat()
    {
        return $this->belongsTo(Seat::class , 'seat_id');
    }
    public function reservation()
    {
        return $this->belongsTo(Reservation::class , 'reservation_id');
    }
}
