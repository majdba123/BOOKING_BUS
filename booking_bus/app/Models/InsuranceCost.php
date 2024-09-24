<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InsuranceCost extends Model
{
    use HasFactory;
    protected $fillable = ['bus_id', 'insurance_cost', 'insurance_date'];

    public function bus()
    {
        return $this->belongsTo(Bus::class);
    }
}
