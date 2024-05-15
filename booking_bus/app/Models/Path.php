<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Path extends Model
{
    use HasFactory;
    protected $fillable = [
        'company_id',
        'from',
        'to',

    ];

    public function company()
    {
        return $this->belongsTo(Company::class , 'company_id');
    }
    public function trip()
    {
        return $this->hasMany(Trip::class);
    }
}
