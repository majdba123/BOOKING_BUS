<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MaintenanceCost extends Model
{
    use HasFactory;
    protected $fillable = [
        'bus_id',
        'cost',
        'maintenance_date',
        'description',
    ];

    public function bus()
    {
        return $this->belongsTo(Bus::class);
    }
}
