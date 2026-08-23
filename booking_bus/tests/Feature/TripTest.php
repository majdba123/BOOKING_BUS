<?php

namespace Tests\Feature;

use App\Models\Breaks;
use App\Models\Breaks_trip;
use App\Models\Bus;
use App\Models\Bus_Driver;
use App\Models\Bus_Trip;
use App\Models\Company;
use App\Models\Driver;
use App\Models\Path;
use App\Models\Pivoit;
use App\Models\Trip;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TripTest extends TestCase
{
    use RefreshDatabase;

    public function test_trip_store(): void
    {
        $user = User::factory()->create();
        $company = Company::factory()->create(['user_id' => $user->id]);

        $login = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password',
        ]);
        $token = $login->json()['access_token'];
        $headers = ['Authorization' => 'Bearer ' . $token];

        $bus1 = Bus::factory()->create([
            'status' => 'available',
            'company_id' => $company->id,
        ]);
        $bus2 = Bus::factory()->create([
            'status' => 'available',
            'company_id' => $company->id,
        ]);

        $pathResponse = $this->postJson('/api/company/path_store', [
            'company_id' => $company->id,
            'from' => 'barzeh222',
            'to' => 'masaken22222',
            'lat_from' => 0.0012,
            'long_from' => 0.0012,
            'lat_to' => 0.0012,
            'long_to' => 0.0012,
            'lat_start' => 0.0012,
            'long_start' => 0.0012,
            'lat_end' => 0.0012,
            'long_end' => 0.0012,
            'Distance' => 700,
        ], $headers);

        $pathResponse->assertStatus(200);
        $path = Path::where('company_id', $company->id)->latest('id')->firstOrFail();

        Breaks::factory()->count(2)->create(['path_id' => $path->id]);

        $data = [
            'path_id' => $path->id,
            'pricing_type' => 'fixed',
            'cost' => '10.00',
            'bus_ids' => [
                [
                    'bus_id' => $bus1->id,
                    'type' => 'all',
                    'from_time_going' => '08:00',
                    'to_time_going' => '18:00',
                    'from_time_return' => '08:00',
                    'to_time_return' => '18:00',
                    'date_start' => '2022-01-10',
                    'date_end' => '2022-01-19',
                ],
                [
                    'bus_id' => $bus2->id,
                    'type' => 'all',
                    'from_time_going' => '08:00',
                    'to_time_going' => '18:00',
                    'from_time_return' => '08:00',
                    'to_time_return' => '18:00',
                    'date_start' => '2022-01-10',
                    'date_end' => '2022-01-19',
                ],
            ],
        ];

        $response = $this->postJson('/api/company/store_trip', $data, $headers);
        $response->assertStatus(201);

        $this->assertDatabaseHas('trips', [
            'path_id' => $path->id,
            'company_id' => $company->id,
            'pricing_type' => $response->json()['pricing_type'],
            'pricing_id' => $response->json()['pricing_id'],
        ]);
        $this->assertDatabaseCount('trips', 1);
        $this->assertEquals(4, Breaks_trip::where('trip_id', $response->json()['id'])->count());
        $this->assertEquals(2, Bus_Trip::where('trip_id', $response->json()['id'])->count());
        $this->assertDatabaseCount('pivoits', 8);
    }

    public function test_store_trip_with_invalid_data(): void
    {
        $user = User::factory()->create();
        Company::factory()->create(['user_id' => $user->id]);

        $login = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password',
        ]);
        $token = $login->json()['access_token'];

        $response = $this->postJson('/api/company/store_trip', [
            'path_id' => 'invalid_path_id',
            'pricing_type' => 'fixed',
            'cost' => '1987',
            'breaks_ids' => ['invalid_break_id'],
            'bus_ids' => [[
                'bus_id' => 'invalid_bus_id',
                'type' => 'invalid',
                'from_time_going' => 'invalid',
                'to_time_going' => 'invalid',
                'from_time_return' => 'invalid',
                'to_time_return' => 'invalid',
                'date_start' => 'invalid',
                'date_end' => 'invalid',
            ]],
        ], ['Authorization' => 'Bearer ' . $token]);

        $response->assertStatus(422);
    }

    public function test_delete_trip(): void
    {
        $user = User::factory()->create();
        $company = Company::factory()->create(['user_id' => $user->id]);
        $path = Path::factory()->create(['company_id' => $company->id]);
        $break1 = Breaks::factory()->create(['path_id' => $path->id]);
        $break2 = Breaks::factory()->create(['path_id' => $path->id]);

        $login = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password',
        ]);
        $token = $login->json()['access_token'];

        $trip = Trip::factory()->create([
            'path_id' => $path->id,
            'company_id' => $company->id,
            'status' => 'pending',
        ]);

        $busTrip1 = Bus_Trip::factory()->create([
            'trip_id' => $trip->id,
            'bus_id' => Bus::factory()->create(['company_id' => $company->id])->id,
            'event' => 'stopped',
        ]);
        $busTrip2 = Bus_Trip::factory()->create([
            'trip_id' => $trip->id,
            'bus_id' => Bus::factory()->create(['company_id' => $company->id])->id,
            'event' => 'stopped',
        ]);
        Breaks_trip::factory()->create(['trip_id' => $trip->id, 'breaks_id' => $break1->id]);
        Breaks_trip::factory()->create(['trip_id' => $trip->id, 'breaks_id' => $break2->id]);

        $busTrips = Bus_Trip::where('trip_id', $trip->id)->get();
        $breakTrips = Breaks_trip::where('trip_id', $trip->id)->get();

        $response = $this->deleteJson('/api/company/delete_trip/' . $trip->id, [], [
            'Authorization' => 'Bearer ' . $token,
        ]);
        $response->assertStatus(200);

        $this->assertSoftDeleted('trips', ['id' => $trip->id]);

        foreach ($busTrips as $busTrip) {
            foreach ($breakTrips as $breakTrip) {
                $this->assertDatabaseMissing('pivoits', [
                    'bus__trip_id' => $busTrip->id,
                    'breaks_trip_id' => $breakTrip->id,
                ]);
            }
            $this->assertSoftDeleted('bus__trips', ['id' => $busTrip->id]);
        }

        $buses = Bus::whereIn('id', [$busTrip1->bus_id, $busTrip2->bus_id])->get();
        foreach ($buses as $bus) {
            $this->assertEquals('available', $bus->status);
        }

        $drivers = Driver::whereIn(
            'id',
            Bus_Driver::whereIn('bus_id', [$busTrip1->bus_id, $busTrip2->bus_id])->pluck('driver_id')
        )->get();
        foreach ($drivers as $driver) {
            $this->assertEquals('available', $driver->status);
        }
    }
}
