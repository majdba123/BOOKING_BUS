<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Seat extends Model
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
        'bus_id',
        'status',

    ];
    public function bus()
    {
        return $this->belongsTo(Bus::class , 'bus_id');
    }
    public function seat_reservation()
    {
        return $this->hasMany(Seat_Reservation::class);
    }
}
