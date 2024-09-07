<?php

namespace App\Models;

use App\Models\Geolocation;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Path extends Model
{
    use HasFactory;

    protected $fillable = [
        'company_id',
        'from',
        'from_location',
        'to',
        'to_location',
        'Distance'
    ];
    protected $appends = ['from_latitude', 'from_longitude', 'to_latitude', 'to_longitude'];

    protected $hidden = ['geolocation_id', 'from_location', 'to_location', 'from_geolocation'];

    public function toArray()
    {
        $array = parent::toArray();
        /*
        مشان اخفي اوبجكت العلاقة تبع احداثيات
        to , form
        من response
        */
        unset($array['from_geolocation']);
        unset($array['to_geolocation']);
        return $array;
    }
    public function company()
    {
        return $this->belongsTo(Company::class, 'company_id');
    }
    public function trip()
    {
        return $this->hasMany(Trip::class);
    }
    public function geolocation()
    {

        return $this->belongsTo(Geolocation::class);
    }

    /*
        التوابع يلي تحت هني علاقات مع جدوول الاحداثيات مشان جيب الاحداثيات الخاصة ب
        from , to
                ألها احداثيات لحالها   from ال
                ألها احداثيات لحالها   to ال

        */
    public function fromgeolocation()
    {
        return $this->belongsTo(geolocation::class, 'from_location', 'id');
    }

    public function togeolocation()
    {
        return $this->belongsTo(geolocation::class, 'to_location', 'id');
    }

    /*

    Accessor   هدول يلي تحت اسمن
     مشان جيب واصفة من جدول بيحتوي على علاقة مشان اعرضها ك واصفة لحالها ما اعرض اوبجكت



    */
    public function getFromLatitudeAttribute()
    {  /*
        واصفة Latitude
       from الخاصة بل

       */
        return $this->fromGeolocation ? $this->fromGeolocation->latitude : null;
    }


    public function getFromLongitudeAttribute()
    {
        return $this->fromGeolocation ? $this->fromGeolocation->longitude : null;
    }


    public function getToLatitudeAttribute()
    {
        return $this->toGeolocation ? $this->toGeolocation->latitude : null;
    }


    public function getToLongitudeAttribute()
    {
        return $this->toGeolocation ? $this->toGeolocation->longitude : null;
    }

    public function breaks()
    {
        return $this->hasMany(Breaks::class);
    }

}
