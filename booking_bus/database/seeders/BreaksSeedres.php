<?php

namespace Database\Seeders;

use App\Models\Breaks;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class BreaksSeedres extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Breaks::factory()->count(3)->create();
    }
}
