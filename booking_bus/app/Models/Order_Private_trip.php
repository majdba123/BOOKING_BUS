<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;

class Order_Private_trip extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at',
    ];
    protected $hidden = [
        'pricing_id',
        'pricing_type'
    ];
    protected $keyType = 'string'; // Set the key type to UUID
    public $incrementing = false; // Disable auto-incrementing

    public static function boot()
    {
        parent::boot();
        // Auto generate UUID when creating data User
        static::creating(function ($model) {
            $model->id = Str::uuid();
        });
    }
    protected $fillable = [
        'private_trip_id',
        'company_id',
        'pricing_id',
        'pricing_type',
        'status',

    ];
    public function private_trip()
    {
        return $this->belongsTo(Private_trip::class, 'private_trip_id');
    }
    public function company()
    {
        return $this->belongsTo(Company::class, 'company_id');
    }
    public function pricing()
    {
        return $this->morphTo();
    }

    public function getPriceAttribute()
    {
        $pricingModel = $this->pricing_type::find($this->pricing_id);

        if ($pricingModel) {
            return $pricingModel->cost;
        }

        return null;
    }
}
