<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use Illuminate\Database\Eloquent\SoftDeletes;

class Rate_Trips extends Model
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
        'user_id',
        'trip_id',
        'rating',

    ];
    public function user()
    {
        return $this->belongsTo(User::class , 'user_id');
    }
    public function trip()
    {
        return $this->belongsTo(Trip::class , 'trip_id');
    }
}
