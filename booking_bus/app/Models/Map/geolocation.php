<?php

namespace App\Models\Map;

use App\Models\Area;
use App\Models\Breaks;
use App\Models\Path;
use App\Models\Private_trip;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class geolocation extends Model
{
    use HasFactory;


    protected $fillable = [ 'latitude', 'longitude'];

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
