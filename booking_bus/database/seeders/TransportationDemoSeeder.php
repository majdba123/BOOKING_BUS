<?php

namespace Database\Seeders;

use App\Models\FixedPricingModel;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class TransportationDemoSeeder extends Seeder
{
    public function run(): void
    {
        $now = now();
        $password = Hash::make(env('DEMO_USER_PASSWORD', 'DemoOnly!123'));

        $users = [
            'admin' => '00000000-0000-4000-8000-000000000001',
            'operator' => '00000000-0000-4000-8000-000000000002',
            'driver1' => '00000000-0000-4000-8000-000000000003',
            'driver2' => '00000000-0000-4000-8000-000000000004',
            'passenger1' => '00000000-0000-4000-8000-000000000005',
            'passenger2' => '00000000-0000-4000-8000-000000000006',
        ];

        $companyId = '10000000-0000-4000-8000-000000000001';
        $driverIds = [
            '20000000-0000-4000-8000-000000000001',
            '20000000-0000-4000-8000-000000000002',
        ];
        $busIds = [
            '30000000-0000-4000-8000-000000000001',
            '30000000-0000-4000-8000-000000000002',
        ];

        $this->seedUsers($users, $password, $now);
        $this->seedProfilesAndAddresses($users, $now);
        $this->seedCompany($companyId, $users['operator'], $now);
        $this->seedDrivers($driverIds, $users, $companyId, $now);
        $this->seedBuses($busIds, $companyId, $now);
        $this->seedSeats($busIds, $now);
        $this->seedDriverAssignments($driverIds, $busIds, $now);
        $this->seedNetworkAndTrips($companyId, $busIds, $now);
    }

    private function seedUsers(array $users, string $password, $now): void
    {
        $records = [
            [$users['admin'], 'Demo Administrator', 'admin@transport-demo.local', '1', '1000'],
            [$users['operator'], 'Demo Operator', 'operator@transport-demo.local', '0', '1000'],
            [$users['driver1'], 'Omar Driver', 'driver.one@transport-demo.local', '0', '250'],
            [$users['driver2'], 'Khaled Driver', 'driver.two@transport-demo.local', '0', '250'],
            [$users['passenger1'], 'Lina Passenger', 'passenger.one@transport-demo.local', '0', '500'],
            [$users['passenger2'], 'Sami Passenger', 'passenger.two@transport-demo.local', '0', '500'],
        ];

        foreach ($records as [$id, $name, $email, $type, $point]) {
            DB::table('users')->updateOrInsert(
                ['id' => $id],
                [
                    'name' => $name,
                    'email' => $email,
                    'type' => $type,
                    'point' => $point,
                    'email_verified_at' => $now,
                    'password' => $password,
                    'deleted_at' => null,
                    'updated_at' => $now,
                    'created_at' => $now,
                ]
            );
        }
    }

    private function seedProfilesAndAddresses(array $users, $now): void
    {
        $profiles = [
            [$users['operator'], '+963900000001', 'Damascus', 'Central'],
            [$users['driver1'], '+963900000002', 'Damascus', 'Central'],
            [$users['driver2'], '+963900000003', 'Homs', 'Central'],
            [$users['passenger1'], '+963900000004', 'Damascus', 'Central'],
            [$users['passenger2'], '+963900000005', 'Aleppo', 'Central'],
        ];

        foreach ($profiles as $index => [$userId, $phone, $city, $area]) {
            $suffix = str_pad((string) ($index + 1), 12, '0', STR_PAD_LEFT);
            DB::table('profiles')->updateOrInsert(
                ['id' => "40000000-0000-4000-8000-{$suffix}"],
                ['user_id' => $userId, 'phone' => $phone, 'image' => 'null', 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]
            );
            DB::table('addresses')->updateOrInsert(
                ['id' => "50000000-0000-4000-8000-{$suffix}"],
                ['user_id' => $userId, 'city' => $city, 'area' => $area, 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]
            );
        }
    }

    private function seedCompany(string $companyId, string $operatorId, $now): void
    {
        DB::table('companies')->updateOrInsert(
            ['id' => $companyId],
            ['user_id' => $operatorId, 'name_company' => 'TransRoute Demo', 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]
        );
    }

    private function seedDrivers(array $driverIds, array $users, string $companyId, $now): void
    {
        foreach ([[$driverIds[0], $users['driver1'], 850], [$driverIds[1], $users['driver2'], 900]] as [$id, $userId, $wages]) {
            DB::table('drivers')->updateOrInsert(
                ['id' => $id],
                ['user_id' => $userId, 'company_id' => $companyId, 'status' => 'active', 'Wages' => $wages, 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]
            );
        }
    }

    private function seedBuses(array $busIds, string $companyId, $now): void
    {
        $buses = [
            [$busIds[0], 'Mercedes', 'BUS001', 18, '2024-01-15', 95000, 12, 280, 24],
            [$busIds[1], 'Volvo', 'BUS002', 18, '2023-06-10', 90000, 12, 300, 26],
        ];

        foreach ($buses as [$id, $brand, $number, $passengers, $purchaseDate, $price, $lifespan, $consumption, $fuel]) {
            DB::table('buses')->updateOrInsert(
                ['id' => $id],
                [
                    'company_id' => $companyId,
                    'Brand' => $brand,
                    'number_bus' => $number,
                    'number_passenger' => $passengers,
                    'status' => 'active',
                    'purchase_date' => $purchaseDate,
                    'purchase_price' => $price,
                    'lifespan_years' => $lifespan,
                    'bus_consumption' => $consumption,
                    'fuel_consumption' => $fuel,
                    'deleted_at' => null,
                    'created_at' => $now,
                    'updated_at' => $now,
                ]
            );
        }
    }

    private function seedSeats(array $busIds, $now): void
    {
        foreach ($busIds as $busIndex => $busId) {
            for ($seat = 1; $seat <= 18; $seat++) {
                $suffix = str_pad((string) (($busIndex * 100) + $seat), 12, '0', STR_PAD_LEFT);
                DB::table('seats')->updateOrInsert(
                    ['id' => "60000000-0000-4000-8000-{$suffix}"],
                    ['bus_id' => $busId, 'status' => 0, 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]
                );
            }
        }
    }

    private function seedDriverAssignments(array $driverIds, array $busIds, $now): void
    {
        foreach ([0, 1] as $index) {
            $suffix = str_pad((string) ($index + 1), 12, '0', STR_PAD_LEFT);
            DB::table('bus__drivers')->updateOrInsert(
                ['id' => "70000000-0000-4000-8000-{$suffix}"],
                ['bus_id' => $busIds[$index], 'driver_id' => $driverIds[$index], 'status' => 'active', 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]
            );
        }
    }

    private function seedNetworkAndTrips(string $companyId, array $busIds, $now): void
    {
        $locations = [
            1001 => [33.51380000, 36.27650000],
            1002 => [34.73240000, 36.71370000],
            1003 => [36.20210000, 37.13430000],
        ];
        foreach ($locations as $id => [$lat, $lng]) {
            DB::table('geolocations')->updateOrInsert(
                ['id' => $id],
                ['latitude' => $lat, 'longitude' => $lng, 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]
            );
        }

        foreach ([
            ['80000000-0000-4000-8000-000000000001', 'Damascus', 1001],
            ['80000000-0000-4000-8000-000000000002', 'Homs', 1002],
            ['80000000-0000-4000-8000-000000000003', 'Aleppo', 1003],
        ] as [$id, $name, $locationId]) {
            DB::table('areas')->updateOrInsert(
                ['id' => $id],
                ['name' => $name, 'geolocation_id' => $locationId, 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]
            );
        }

        DB::table('paths')->updateOrInsert(
            ['id' => 1001],
            ['company_id' => $companyId, 'from' => 'Damascus', 'from_location' => 1001, 'to' => 'Homs', 'to_location' => 1002, 'Distance' => 165, 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]
        );
        DB::table('paths')->updateOrInsert(
            ['id' => 1002],
            ['company_id' => $companyId, 'from' => 'Homs', 'from_location' => 1002, 'to' => 'Aleppo', 'to_location' => 1003, 'Distance' => 190, 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]
        );

        foreach ([
            [1001, 1001, 'Damascus Station', 1001], [1002, 1001, 'Homs Station', 1002],
            [1003, 1002, 'Homs Station', 1002], [1004, 1002, 'Aleppo Station', 1003],
        ] as [$id, $pathId, $name, $locationId]) {
            DB::table('breaks')->updateOrInsert(
                ['id' => $id],
                ['path_id' => $pathId, 'name' => $name, 'geolocation_id' => $locationId, 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]
            );
        }

        DB::table('fixed_pricing_models')->updateOrInsert(['id' => 1001], ['cost' => 12.00, 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]);
        DB::table('fixed_pricing_models')->updateOrInsert(['id' => 1002], ['cost' => 15.00, 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]);

        $pricingType = FixedPricingModel::class;
        DB::table('trips')->updateOrInsert(['id' => 1001], ['company_id' => $companyId, 'path_id' => 1001, 'status' => 'active', 'pricing_id' => 1001, 'pricing_type' => $pricingType, 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]);
        DB::table('trips')->updateOrInsert(['id' => 1002], ['company_id' => $companyId, 'path_id' => 1002, 'status' => 'active', 'pricing_id' => 1002, 'pricing_type' => $pricingType, 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]);

        foreach ([[1001, 1001], [1002, 1002], [1003, 1002], [1004, 1001]] as [$breakId, $tripId]) {
            DB::table('breaks_trips')->updateOrInsert(
                ['trip_id' => $tripId, 'breaks_id' => $breakId],
                ['deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]
            );
        }

        $start = now()->addDays(2)->toDateString();
        $end = now()->addMonths(3)->toDateString();
        DB::table('bus__trips')->updateOrInsert(['id' => 1001], ['trip_id' => 1001, 'bus_id' => $busIds[0], 'from_time_going' => '08:00', 'to_time_going' => '10:30', 'from_time_return' => '16:00', 'to_time_return' => '18:30', 'date_start' => $start, 'date_end' => $end, 'status' => 'active', 'type' => 'all', 'event' => 'stopped', 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]);
        DB::table('bus__trips')->updateOrInsert(['id' => 1002], ['trip_id' => 1002, 'bus_id' => $busIds[1], 'from_time_going' => '09:00', 'to_time_going' => '12:00', 'from_time_return' => '17:00', 'to_time_return' => '20:00', 'date_start' => $start, 'date_end' => $end, 'status' => 'active', 'type' => 'all', 'event' => 'stopped', 'deleted_at' => null, 'created_at' => $now, 'updated_at' => $now]);
    }
}
