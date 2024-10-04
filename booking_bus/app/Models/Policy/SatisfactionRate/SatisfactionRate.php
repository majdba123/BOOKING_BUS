<?php

namespace App\Models\Policy\SatisfactionRate;
use Illuminate\Database\Eloquent\SoftDeletes;

use App\Models\Company;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SatisfactionRate extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at',
    ];
    protected $fillable = [
        'company_id',
        'rate',
        'description',
    ];

    // العلاقة مع الشركات
    public function company()
    {
        return $this->belongsTo(Company::class);
    }

    // العلاقة مع المستخدمين عبر جدول الوسيط
    public function users()
    {
        return $this->belongsToMany(User::class, 'user_satisfaction_rate');
    }
}
