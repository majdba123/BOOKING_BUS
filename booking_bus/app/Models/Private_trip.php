<?php

namespace App\Models;

use App\Models\Geolocation;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use Illuminate\Database\Eloquent\SoftDeletes;

class Private_trip extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at',
    ];
    protected $keyType = 'string'; // Set the key type to UUID
    public $incrementing = false; // Disable auto-incrementing

    public static function boot() {
        parent::boot();
        // Auto generate UUID when creating data User
        static::creating(function ($model) {
            $model->id = Str::uuid();
        });
    }
    protected $fillable = [
        'user_id',
        'from',
        'to',
        'date',
        'from_location',
        'to_location',
        'start_time',
        'status',
        'Distance'
    ];
    protected $appends = ['from_latitude', 'from_longitude', 'to_latitude', 'to_longitude'];
    // protected $hidden = ['geolocation_id', 'from_location', 'to_location', 'from_geolocation'];
    public function toArray()
    {
        $array = parent::toArray();
        /*
        مشان اخفي اوبجكت العلاقة تبع احداثيات
        to , form
        من response
        */
        unset($array['from_geolocation']);
        unset($array['to_geolocation']);
        return $array;
    }
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

    public function fromgeolocation()
    {
        return $this->belongsTo(geolocation::class, 'from_location', 'id');
    }

    public function togeolocation()
    {
        return $this->belongsTo(geolocation::class, 'to_location', 'id');
    }

    public function getFromLatitudeAttribute()
    {  /*
        واصفة Latitude
       from الخاصة بل

       */
        return $this->fromGeolocation ? $this->fromGeolocation->latitude : null;
    }


    public function getFromLongitudeAttribute()
    {
        return $this->fromGeolocation ? $this->fromGeolocation->longitude : null;
    }


    public function getToLatitudeAttribute()
    {
        return $this->toGeolocation ? $this->toGeolocation->latitude : null;
    }


    public function getToLongitudeAttribute()
    {
        return $this->toGeolocation ? $this->toGeolocation->longitude : null;
    }
}
