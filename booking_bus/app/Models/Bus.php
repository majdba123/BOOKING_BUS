<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use Illuminate\Database\Eloquent\SoftDeletes;

class Bus extends Model
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
    // Auto generate UUID when creating data User if id is not set
    static::creating(function ($model) {
        if (!$model->id) {
            $model->id = Str::uuid();
        }
    });
}
    protected $fillable = [
        'id',
        'company_id',
        'Brand',
        'number_bus',
        'number_passenger',
        'status',
        'purchase_date',
        'purchase_price',
        'lifespan_years',
        'bus_consumption',
        'fuel_consumption',
    ];
    public function bus_trip()
    {
        return $this->hasMany(Bus_Trip::class);
    }
    public function bus_driver()
    {
        return $this->hasMany(Bus_Driver::class);
    }
    public function seat()
    {
        return $this->hasMany(Seat::class);
    }
    public function company()
    {
        return $this->belongsTo(Company::class, 'company_id');
    }

    //hamza!!!!
    public function reservations()
    {
        return $this->hasManyThrough(Reservation::class, Bus_Trip::class);
    }
    public function getNumberOfReservationsAttribute()
    {
        return $this->reservations()->count();
    }
    public function insuranceCosts()
    {
        return $this->hasMany(InsuranceCost::class);
    }
    public function maintenanceCosts()
    {
        return $this->hasMany(MaintenanceCost::class);
    }
}
