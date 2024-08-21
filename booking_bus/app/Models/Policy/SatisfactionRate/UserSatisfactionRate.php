<?php

namespace App\Models\Policy\SatisfactionRate;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserSatisfactionRate extends Model
{
    use HasFactory;
    protected $table = 'user_satisfaction_rate'; // Specify the table name if it's different from the default

    protected $fillable = [
        'user_id',
        'satisfaction_rate_id',

    ];

    /**
     * Define the relationship with the User model.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Define the relationship with the SatisfactionRate model.
     */
    public function satisfactionRate()
    {
        return $this->belongsTo(SatisfactionRate::class);
    }
}
