<?php

namespace App\Models;

use App\Models\Policy\CancellationRule\CancelReservation;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use Illuminate\Database\Eloquent\SoftDeletes;

class Reservation extends Model
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
        'user_id',
        'pivoit_id',
        'bus__trip_id',
        'price',
        'type',
        'status',

    ];
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
    public function pivoit()
    {
        return $this->belongsTo(Pivoit::class, 'pivoit_id');
    }
    public function bus_trip()
    {
        return $this->belongsTo(Bus_Trip::class, 'bus__trip_id');
    }
    public function seat_reservation()
    {
        return $this->hasMany(Seat_Reservation::class);
    }
    //code by hamza
    public function cancelReservation()
    {
        return $this->belongsTo(CancelReservation::class);
    }
}
