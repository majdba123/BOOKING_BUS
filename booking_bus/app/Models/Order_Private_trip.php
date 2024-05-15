<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order_Private_trip extends Model
{
    use HasFactory;
    protected $fillable = [
        'private_trip_id',
        'company_id',
        'price',
        'status',

    ];
    public function private_trip()
    {
        return $this->belongsTo(Private_trip::class , 'private_trip_id');
    }
    public function company()
    {
        return $this->belongsTo(Company::class , 'company_id');
    }

}
