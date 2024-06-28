<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Breaks extends Model
{
    use HasFactory;
    protected $fillable = [
        'name',
    ];


    public function break_trip()
    {
        return $this->hasMany(Breaks_trip::class);
    }
    public function area()
    {
        return $this->belongsTo(Area::class,'area_id');
    }
}
