<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Breaks_trip extends Model
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
        'breaks_id',
        'trip_id',

    ];

    public function Pivoit()
    {
        return $this->hasMany(Pivoit::class);
    }
    public function trip()
    {
        return $this->belongsTo(Trip::class,'trip_id');
    }
    public function break()
    {
        return $this->belongsTo(Breaks::class,'breaks_id');
    }


}
