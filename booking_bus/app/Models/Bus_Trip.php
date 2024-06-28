<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Bus_Trip extends Model
{
    use HasFactory;

    protected $fillable = [
        'trip_id',
        'bus_id',
        'status',
        'from_time',
        'to_time',
        'type',
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
        return $this->belongsTo(Bus::class,'bus_id');
    }

    public function trip()
    {
        return $this->belongsTo(Trip::class,'trip_id');
    }
}
