<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'lang',
        'lat',
        'password',
        'type',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];

    public function rate_driver()
    {
        return $this->hasMany(Rate_Driver::class);
    }

    public function rate_trips()
    {
        return $this->hasMany(Rate_Trips::class);
    }

    public function Reservation()
    {
        return $this->hasMany(Reservation::class);
    }

    public function Charge_balance()
    {
        return $this->hasMany(Charge_Balance::class);
    }

    public function private_trip()
    {
        return $this->hasMany(Private_trip::class);
    }

    public function address()
    {
        return $this->hasMany(Address::class);
    }

    public function inquires()
    {
        return $this->hasMany(inquires::class);
    }

    public function favourite()
    {
        return $this->hasMany(Favourite::class);
    }

    public function Driver()
    {
        return $this->hasOne(Driver::class);
    }

    public function profile()
    {
        return $this->hasOne(Profile::class);
    }

    public function Company()
    {
        return $this->hasOne(Company::class);
    }
}
