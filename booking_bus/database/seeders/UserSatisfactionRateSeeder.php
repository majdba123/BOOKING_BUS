<?php

namespace Database\Seeders;

use App\Models\Policy\SatisfactionRate\UserSatisfactionRate;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class UserSatisfactionRateSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        UserSatisfactionRate::factory()->count(50)->create();
    }
}
