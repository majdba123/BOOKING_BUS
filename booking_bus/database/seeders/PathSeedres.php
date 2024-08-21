<?php

namespace Database\Seeders;

use App\Models\Path;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class PathSeedres extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Path::factory()->count(3)->create();

    }
}
