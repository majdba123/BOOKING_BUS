<?php

namespace App\Models\Policy\CancellationRule;

use App\Models\Company;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CancellationRule extends Model
{
    use HasFactory;
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
