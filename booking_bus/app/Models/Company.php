<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Company extends Model
{
    use HasFactory;
    protected $fillable = [
        'user_id',
        'name_company',
    ];
    public function favourite()
    {
        return $this->hasMany(Favourite::class);
    }
    public function order_private()
    {
        return $this->hasMany(Order_Private::class);
    }
    public function bus()
    {
        return $this->hasMany(Bus::class);
    }
    public function path()
    {
        return $this->hasMany(Path::class);
    }
    public function trip()
    {
        return $this->hasMany(Trip::class);
    }
    public function driver()
    {
        return $this->hasMany(Driver::class);
    }
    public function user()
    {
        return $this->belongsTo(User::class , 'user_id');
    }

}
