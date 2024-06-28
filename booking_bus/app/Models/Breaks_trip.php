<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Breaks_trip extends Model
{
    use HasFactory;
    protected $fillable = [
        'breaks_id',
        'trip_id',

    ];
    public function Reservation()
    {
        return $this->hasMany(Reservation::class);
    }
    public function Pivoit()
    {
        return $this->hasMany(Pivoit::class);
    }
    public function trip()
    {
        return $this->belongsTo(Trip::class,'trip_id');
    }
    public function break()
    {
        return $this->belongsTo(Breaks::class,'breaks_id');
    }


}
