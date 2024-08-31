<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Geolocation extends Model
{
    use HasFactory;

    protected $fillable = ['latitude', 'longitude'];

    public function area()
    {

        return $this->hasOne(Area::class);
    }


    public function path()
    {

        return $this->hasOne(Path::class);
    }


    public function break()
    {

        return $this->hasOne(Breaks::class);
    }
    public function privateTrip()
    {

        return $this->hasOne(Private_trip::class);
    }
}
