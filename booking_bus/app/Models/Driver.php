<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use Illuminate\Database\Eloquent\SoftDeletes;

class Driver extends Model
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
        'company_id',
        'status',
        'Wages',

    ];
    public function user()
    {
        return $this->belongsTo(User::class , 'user_id');
    }
    public function company()
    {
        return $this->belongsTo(Company::class , 'company_id');
    }

    public function bus_driver()
    {
        return $this->hasMany(Bus_Driver::class);
    }
    public function rate_driver()
    {
        return $this->hasMany(Rate_Driver::class);
    }
}
