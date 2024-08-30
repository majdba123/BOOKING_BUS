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
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class TripTest extends TestCase
{
    /**
     * A basic feature test example.
     */
    use RefreshDatabase;



    public function test_trip_store()
    {
        // Create a user and company
        $user = User::factory()->create();
        $company = Company::factory()->create(['user_id' => $user->id]);

        // Login as the user
        $response = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password',
        ]);
        $token = $response->json()['access_token'];

        // Create a path
        $path = Path::factory()->create([
            "company_id" => $company->id
        ]);

        // Create breaks
        $break1 = Breaks::factory()->create(['path_id' =>$path->id ]);
        $break2 = Breaks::factory()->create(['path_id' =>$path->id ]);

        // Create buses
        $bus1 = Bus::factory()->create([
            'status' => 'available',
            "company_id" => $company->id
        ]);
        $bus2 = Bus::factory()->create([
            'status' => 'available',
            "company_id" => $company->id
        ]);

        // Create request data
        $data = [
            'path_id' => $path->id,
            'price' => '10.00',
            'bus_ids' => [
                [
                    'bus_id' => $bus1->id,
                    'type' => 'all',
                    'start_time' => '10:00',
                    'end_time' => '12:00',
                    'date' => '2023-03-01',
                ],
                [
                    'bus_id' => $bus2->id,
                    'type' => 'all',
                    'start_time' => '13:00',
                    'end_time' => '15:00',
                    'date' => '2023-03-01',
                ],
            ],
        ];
        $headers = [
            'Authorization' => 'Bearer ' . $token,
        ];
        // Make the request
        $response = $this->postJson('/api/company/store_trip', $data, $headers);

        $response->assertStatus(201);

        $this->assertDatabaseHas('trips', [
            'path_id' => $path->id,
            'company_id' => $company->id,
            'price' => '10.00',
        ]);
        $this->assertEquals(1,  Trip::count());
  /*      foreach ($data['breaks_ids'] as $breakId) {
            $this->assertDatabaseHas('breaks_trips', [
                'trip_id' =>$response->json()['id'],
                'breaks_id' => $breakId,
            ]);
        }*/
        $this->assertEquals(4, Breaks_trip::where('trip_id', $response->json()['id'])->count()); // Check that two break trips were created
        foreach ($data['bus_ids'] as $busData) {
            $this->assertDatabaseHas('bus__trips', [
                'trip_id' =>$response->json()['id'],
                'bus_id' => $busData['bus_id'],
                'type' => $busData['type'],
                'from_time' => $busData['start_time'],
                'to_time' => $busData['end_time'],
                'date' => $busData['date'],
            ]);
        }
        $this->assertEquals(2, Bus_Trip::where('trip_id', $response->json()['id'])->count()); // Check that two bus trips were created
        $tripId = $response->json()['id'];
        $busTrips = Bus_Trip::where('trip_id', $tripId)->get();
        $breakTrips = Breaks_trip::where('trip_id', $tripId)->get();
        foreach ($busTrips as $busTrip) {
            foreach ($breakTrips as $breakTrip) {
                $this->assertDatabaseHas('pivoits', [
                    'bus__trip_id' => $busTrip->id,
                    'breaks_trip_id' => $breakTrip->id,
                ]);
            }
        }
        $this->assertEquals(8, Pivoit::count()); // Check that four pivoits were created
    }


    public function test_store_trip_with_invalid_data()
    {
        $user = User::factory()->create();
        $company = Company::factory()->create(['user_id' => $user->id]);

        $response = $this->postJson('/api/company/store_trip', [
            'path_id' => 'invalid_path_id',
            'price' => 'invalid_price',
            'breaks_ids' => ['invalid_break_id'],
            'bus_ids' => [
                [
                    'bus_id' => 'invalid_bus_id',
                    'type' => 'invalid_type',
                    'start_time' => 'invalid_start_time',
                    'end_time' => 'invalid_end_time',
                    'date' => 'invalid_date',
                ],
            ],
        ]);
        $user = User::factory()->create();
        $company = Company::factory()->create(['user_id' => $user->id]);

        // Login as the user
        $response = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password',
        ]);
        $token = $response->json()['access_token'];



        // Create request data
        $data = [
            'path_id' => 'invalid_path_id',
            'price' => 'invalid_price',
            'breaks_ids' => ['invalid_break_id'],
            'bus_ids' => [
                [
                    'bus_id' => 'invalid_bus_id',
                    'type' => 'invalid_type',
                    'start_time' => 'invalid_start_time',
                    'end_time' => 'invalid_end_time',
                    'date' => 'invalid_date',
                ],
            ],
        ];
        $headers = [
            'Authorization' => 'Bearer ' . $token,
        ];
        // Make the request
        $response = $this->postJson('/api/company/store_trip', $data, $headers);

        $response->assertStatus(422);
    }




    public function test_delete_trip()
    {
        // Create a user with a company
        $user = User::factory()->create();
        $company = Company::factory()->create(['user_id' => $user->id]);
        $path = Path::factory()->create([
            "company_id" => $company->id
        ]);

        // Login as the user
        $response = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password',
        ]);
        $token = $response->json()['access_token'];

        // Create a trip associated with the company
        $trip = Trip::factory()->create([
            'path_id' => $path->id,
            'company_id' => $company->id,
        ]);

        // Create bus trips and breaks trips associated with the trip
        $busTrip1 = Bus_Trip::factory()->create([
            'trip_id' => $trip->id,
            'bus_id' => Bus::factory()->create(['company_id' => $company->id])->id,
        ]);
        $busTrip2 = Bus_Trip::factory()->create([
            'trip_id' => $trip->id,
            'bus_id' => Bus::factory()->create(['company_id' => $company->id])->id,
        ]);
        $breakTrip1 = Breaks_Trip::factory()->create([
            'trip_id' => $trip->id,
            'breaks_id' => Breaks::factory()->create()->id,
        ]);
        $breakTrip2 = Breaks_Trip::factory()->create([
            'trip_id' => $trip->id,
            'breaks_id' => Breaks::factory()->create()->id,
        ]);

        // Make the request to delete the trip
        $busTrips = Bus_Trip::where('trip_id',  $trip->id)->get();
        $breakTrips = Breaks_trip::where('trip_id', $trip->id)->get();

        $response = $this->deleteJson('/api/company/delete_trip/' . $trip->id, [], [
            'Authorization' => 'Bearer ' . $token,
        ]);
       // dd($response->json());
        $response->assertStatus(200);

        // Assert that the trip is deleted
        $this->assertDatabaseMissing('trips', [
            'id' => $trip->id,
        ]);


        foreach ($busTrips as $busTrip) {
            foreach ($breakTrips as $breakTrip) {
                $this->assertDatabaseMissing('pivoits', [
                    'bus__trip_id' => $busTrip->id,
                    'breaks_trip_id' => $breakTrip->id,
                ]);
            }
        }

        foreach ($busTrips as $busTrip) {
                $this->assertDatabaseMissing('bus__trips', [
                    'id' => $busTrip->id,

                ]);
        }


        // Assert that the buses are updated to available status
        $buses = Bus::whereIn('id', [$busTrip1->bus_id, $busTrip2->bus_id])->get();
        foreach ($buses as $bus) {
            $this->assertEquals('available', $bus->status);
        }

        // Assert that the drivers are updated to available status
        $drivers = Driver::whereIn('id', Bus_Driver::whereIn('bus_id', [$busTrip1->bus_id, $busTrip2->bus_id])->pluck('driver_id'))->get();
        foreach ($drivers as $driver) {
            $this->assertEquals('available', $driver->status);
        }
    }
}

