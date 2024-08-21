<?php

namespace Database\Seeders;
use App\Models\Company;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CompanySeedres extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run()
    {
        Company::factory()->count(3)->create();
    }
}
