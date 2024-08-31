<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Rate_Trips extends Model
{
    use HasFactory;
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
