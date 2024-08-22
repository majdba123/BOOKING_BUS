<?php

namespace App\Models;

use App\Models\Map\geolocation;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Breaks extends Model
{
    use HasFactory;
    protected $fillable = [
        'name',
        'area_id',
        'geolocation_id',
    ];

    protected $appends = ['latitude', 'longitude'];
    protected $hidden = ['geolocation', 'geolocation_id'];

    public function break_trip()
    {
        return $this->hasMany(Breaks_trip::class);
    }
    public function area()
    {
        return $this->belongsTo(Area::class, 'area_id');
    }
    public function geolocation()
    {

        return $this->belongsTo(geolocation::class);
    }

    public function getlatitudeAttribute()
    {

        $geolocation = $this->geolocation;

        return $geolocation ? $geolocation->latitude : null;
    }


    public function getlongitudeAttribute()
    {
        return $this->geolocation ? $this->geolocation->longitude : null;
    }
}
