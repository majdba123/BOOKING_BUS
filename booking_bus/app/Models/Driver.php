<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Driver extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'company_id',

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
