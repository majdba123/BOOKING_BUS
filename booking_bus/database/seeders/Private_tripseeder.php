<?php

namespace Database\Seeders;

use App\Models\Private_trip;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class Private_tripseeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Private_trip::factory()->count(10)->create();
    }
}
