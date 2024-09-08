<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Bus_Trip extends Model
{
    use HasFactory;
    protected $table = 'bus__trips';

    protected $fillable = [
        'id',
        'trip_id',
        'bus_id',
        'status',
        'from_time_going',
        'to_time_going',
        'from_time_return',
        'to_time_return',
        'type',
        'date_start',
        'date_end',
        'event',
    ];
    public function Reservation()
    {
        return $this->hasMany(Reservation::class);
    }
    public function Pivoit()
    {
        return $this->hasMany(Pivoit::class);
    }
    public function bus()
    {
        return $this->belongsTo(Bus::class, 'bus_id');
    }

    public function trip()
    {
        return $this->belongsTo(Trip::class, 'trip_id');
    }
}
