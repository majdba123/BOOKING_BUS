<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;


use App\Models\Map\geolocation;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // \App\Models\User::factory(10)->create();

        // \App\Models\User::factory()->create([
        //     'name' => 'Test User',
        //     'email' => 'test@example.com',
        // ]);
        $this->call(geolocationseeder::class);

        $this->call(UserSeedres::class);
        $this->call(AreaSeedres::class);
        $this->call(CompanySeedres::class);
        $this->call(DriverSeedres::class);
        $this->call(BusSeedres::class);
        $this->call(SeatSeedres::class);
        $this->call(PathSeedres::class);
        $this->call(TripSeedres::class);
        $this->call(BreaksSeedres::class);
        $this->call(Bus_DriverSeedres::class);
        $this->call(Bus_TTripSeedres::class);
        $this->call(Breaks_TripSeedres::class);
        $this->call(PiSeedres::class);
        $this->call(ReservationSeedres::class);
        $this->call(Seat_ReservationSeedres::class);
    }
}
