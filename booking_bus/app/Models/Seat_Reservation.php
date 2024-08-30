<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Seat_Reservation extends Model
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
        'seat_id',
        'reservation_id',
        'status',

    ];
    public function seat()
    {
        return $this->belongsTo(Seat::class , 'seat_id');
    }
    public function reservation()
    {
        return $this->belongsTo(Reservation::class , 'reservation_id');
    }
}
