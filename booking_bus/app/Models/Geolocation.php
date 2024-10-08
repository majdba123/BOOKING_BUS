<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use Illuminate\Database\Eloquent\SoftDeletes;

class Geolocation extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at',
    ];


    protected $fillable = ['id','latitude', 'longitude'];

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
