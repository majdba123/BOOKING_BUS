<?php

namespace App\Models;

use App\Models\Policy\CancelTrip\CanceledTrip;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Trip extends Model
{
    use HasFactory;
    protected $fillable = [
        'company_id',
        'path_id',
        'status',
        'price',
    ];
    public function company()
    {
        return $this->belongsTo(Company::class, 'company_id');
    }
    public function path()
    {
        return $this->belongsTo(Path::class, 'path_id');
    }
    public function rate_trip()
    {
        return $this->hasMany(Rate_Trips::class);
    }
    public function bus_trip()
    {
        return $this->hasMany(Bus_Trip::class);
    }
    public function breaks_trip()
    {
        return $this->hasMany(Breaks_trip::class);
    }

    //code by hamza
    public function canceledTrip()
    {
        return $this->hasOne(CanceledTrip::class);
    }
}
