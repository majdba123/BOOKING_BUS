<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Bus_Driver extends Model
{
    use HasFactory;

    protected $fillable = [
        'bus_id',
        'driver_id',
        'status',

    ];
    public function bus()
    {
        return $this->belongsTo(Bus::class,'bus_id');
    }
    public function driver()
    {
        return $this->belongsTo(Driver::class,'driver_id');
    }
}
