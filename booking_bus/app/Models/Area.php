<?php

namespace App\Models;

use App\Models\Geolocation;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Illuminate\Database\Eloquent\SoftDeletes;

class Area extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at'
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
        'name',
        'geolocation_id'
    ];
    protected $appends = ['latitude', 'longitude'];
    protected $hidden = ['geolocation', 'geolocation_id'];


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
