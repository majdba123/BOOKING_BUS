<?php

namespace App\Models;

use App\Models\Policy\CancellationRule\CancelReservation;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Reservation extends Model
{
    use HasFactory;
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
