<?php

namespace Database\Seeders;

use App\Models\Rate_Driver;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class RateDriverSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Rate_Driver::factory()->count(10)->create();
    }
}
