<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pivoit extends Model
{
    use HasFactory;
    protected $fillable = [
        'bus_trip_id',
        'break_trip_id',
        'from_time',
        'to_time',
        'status',
    ];

    public function bus_trip()
    {
        return $this->belongsTo(Bus_Trip::class,'path_id');
    }
    public function break_trip()
    {
        return $this->belongsTo(Breaks_trip::class,'path_id');
    }

}
