<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Favourite extends Model
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
}
