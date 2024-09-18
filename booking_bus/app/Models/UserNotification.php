<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use Illuminate\Database\Eloquent\SoftDeletes;

class UserNotification extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at'
    ];

    protected $fillable = [
        'user_id',
        'notification',
        'status'


    ];
    public function user()
    {
        return $this->belongsTo(User::class , 'user_id');
    }
}
