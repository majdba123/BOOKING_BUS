<?php

namespace App\Models;

use App\Models\Policy\CancellationRule\CancellationRule;
use App\Models\Policy\Reward\Reward;
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
        return $this->hasMany(Order_Private_trip::class);
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
        return $this->belongsTo(User::class, 'user_id');
    }

    //code by hamza
    public function rewards()
    {
        return $this->hasMany(Reward::class);
    }
    public function cancellationRules()
    {
        return $this->hasMany(CancellationRule::class);
    }
}
