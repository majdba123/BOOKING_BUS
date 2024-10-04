<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class MaintenanceCost extends Model
{
    use HasFactory;
    use SoftDeletes;
    protected $dates = [
        'deleted_at',
    ];
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
