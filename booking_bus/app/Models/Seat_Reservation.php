<?php

namespace App\Models;
use Illuminate\Database\Eloquent\SoftDeletes;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Seat_Reservation extends Model
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
