<?php

namespace Database\Seeders;

use App\Models\Geolocation;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class geolocationseeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Geolocation::factory()->count(3)->create();
    }
}
