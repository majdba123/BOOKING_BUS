<?php

namespace App\Models\Policy\CancellationRule;

use App\Models\Company;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class CancellationRule extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at'
    ];

    protected $fillable = [
        'company_id',
        'hours_before',
        'discount_percentage',
        'description',
    ];

    public function company()
    {
        return $this->belongsTo(Company::class);
    }
    public function cancellationReservations()
    {
        return $this->hasMany(CancelReservation::class);
    }
}
