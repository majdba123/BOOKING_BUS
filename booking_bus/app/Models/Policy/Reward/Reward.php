<?php

namespace App\Models\Policy\Reward;
use Illuminate\Database\Eloquent\SoftDeletes;

use App\Models\Company;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reward extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at',
    ];

    protected $fillable = ['company_id', 'Reservation_Costs', 'reward_percentage'];

    public function users()
    {
        return $this->belongsToMany(User::class, 'reward_user')->withTimestamps();
    }

    public function company()
    {
        return $this->belongsTo(Company::class);
    }
}
