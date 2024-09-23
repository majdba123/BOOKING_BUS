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
        $this->call([
            geolocationseeder::class,
            UserSeedres::class,
            AreaSeedres::class,

            CompanySeedres::class,
            DriverSeedres::class,
            Private_tripseeder::class,
            BusSeedres::class,
            SeatSeedres::class,
            PathSeedres::class,
            TripSeedres::class,
            BreaksSeedres::class,
            Bus_DriverSeedres::class,
            ProfileSeeder::class,
            AddressSeeder::class,
            FavouriteSeeder::class,
            InquiresSeeder::class,
            ChargeBalanceSeeder::class,
            Breaks_TripSeedres::class,
            // CancellationRuleSeeder::class,
            // CanceledTripSeeder::class,

            PiSeedres::class,
            // RateTripSeeder::class,
            // RateDriverSeeder::class,
            ReservationSeedres::class,
            Seat_ReservationSeedres::class,
            InsuranceCostSeeder::class,
            MaintenanceCostSeeder::class,
            FixedPricingModelSeeder::class,
            ProportionalPricingModelSeeder::class,
            DecreasingProportionalModelSeeder::class,
            CappingPricingModelSeeder::class,
            Bus_TTripSeedres::class,
        ]);
    }
}
