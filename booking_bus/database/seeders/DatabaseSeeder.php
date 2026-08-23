<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        if (app()->environment('production')) {
            $this->command?->warn('Demo data seeding is disabled in production.');
            return;
        }

        $this->call([
            TransportationDemoSeeder::class,
        ]);
    }
}
