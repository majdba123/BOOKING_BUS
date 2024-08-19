<?php

namespace Database\Seeders;

use App\Models\Pivoit ;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class PiSeedres extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Pivoit::factory()->count(3)->create();
    }
}
