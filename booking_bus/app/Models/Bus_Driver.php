<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use Illuminate\Database\Eloquent\SoftDeletes;

class Bus_Driver extends Model
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
        'bus_id',
        'driver_id',
        'status',

    ];
    public function bus()
    {
        return $this->belongsTo(Bus::class,'bus_id');
    }
    public function driver()
    {
        return $this->belongsTo(Driver::class,'driver_id');
    }
}
