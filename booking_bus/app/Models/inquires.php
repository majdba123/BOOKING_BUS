<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class inquires extends Model
{
    use HasFactory;
    protected $fillable = [
        'user_id',
        'email',
        'quastion',

    ];
    public function user()
    {
        return $this->belongsTo(User::class , 'user_id');
    }
}
