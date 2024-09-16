<?php

namespace App\Models\Policy\SatisfactionRate;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class UserSatisfactionRate extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at'
    ];
    protected $table = 'user_satisfaction_rate';

    protected $fillable = [
        'user_id',
        'satisfaction_rate_id',

    ];


    public function user()
    {
        return $this->belongsTo(User::class);
    }


    public function satisfactionRate()
    {
        return $this->belongsTo(SatisfactionRate::class);
    }
}
