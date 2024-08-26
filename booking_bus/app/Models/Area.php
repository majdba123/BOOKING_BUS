<?php

namespace App\Models;

use App\Models\Geolocation;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Log;

class Area extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'geolocation_id'
    ];
    protected $appends = ['latitude', 'longitude'];
    protected $hidden = ['geolocation', 'geolocation_id'];

    public function breaks()
    {
        return $this->hasMany(Breaks::class);
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
