<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pivoit extends Model
{
    use HasFactory;
    protected $fillable = [
        'bus__trip_id',
        'breaks_trip_id',
        'status',
    ];

    public function bus_trip()
    {
        return $this->belongsTo(Bus_Trip::class,'bus__trip_id');
    }
    public function break_trip()
    {
        return $this->belongsTo(Breaks_trip::class,'breaks_trip_id');
    }

}
