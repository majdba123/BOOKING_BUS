<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use Illuminate\Database\Eloquent\SoftDeletes;

class Breaks_trip extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at',
    ];
    protected $fillable = [
        'id',
        'breaks_id',
        'trip_id',

    ];

    public function Pivoit()
    {
        return $this->hasMany(Pivoit::class);
    }
    public function trip()
    {
        return $this->belongsTo(Trip::class,'trip_id');
    }
    public function break()
    {
        return $this->belongsTo(Breaks::class,'breaks_id');
    }


}
