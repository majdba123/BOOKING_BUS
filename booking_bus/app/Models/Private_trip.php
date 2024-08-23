<?php

namespace App\Models;

use App\Models\Geolocation;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Private_trip extends Model
{
    use HasFactory;
    protected $fillable = [
        'user_id',
        'from',
        'to',
        'date',
        'geolocation_id',
        'start_time',
        'status',
        'Distance'
    ];
    protected $appends = ['latitude', 'longitude'];
    protected $hidden = ['geolocation', 'geolocation_id'];
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
    public function order_private_trip()
    {
        return $this->hasMany(Order_Private_trip::class);
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
