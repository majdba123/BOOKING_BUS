<?php

namespace Database\Seeders;

use App\Models\DecreasingProportionalModel;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DecreasingProportionalModelSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DecreasingProportionalModel::factory(10)->create();
    }
}
