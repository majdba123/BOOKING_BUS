<?php

namespace App\Models;

use App\Models\Geolocation;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Breaks extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'path_id',
        'geolocation_id',
    ];

    protected $appends = ['latitude', 'longitude'];
    protected $hidden = ['geolocation', 'geolocation_id'];

    public function break_trip()
    {
        return $this->hasMany(Breaks_trip::class);
    }
    public function path()
    {
        return $this->belongsTo(Path::class, 'path_id');
    }
    public function geolocation()
    {

        return $this->belongsTo(Geolocation::class);
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
