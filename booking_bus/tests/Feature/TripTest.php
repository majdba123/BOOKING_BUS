<?php

namespace Tests\Feature;

use App\Models\Breaks;
use App\Models\Breaks_trip;
use App\Models\Bus;
use App\Models\Bus_Driver;
use App\Models\Bus_Trip;
use App\Models\Company;
use App\Models\Driver;
use App\Models\Geolocation;
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


        // Create breaks

        // Create buses
        $bus1 = Bus::factory()->create([
            'status' => 'available',
            "company_id" => $company->id
        ]);
        $bus2 = Bus::factory()->create([
            'status' => 'available',
            "company_id" => $company->id
        ]);

        $data1 = [
            'company_id' => $company->id,  // Assuming you have a factory for Company
            'from' => 'barzeh222',
            'to' =>'masaken22222',
            'lat_from' => 0.0012,  // Assuming you have a factory for Geolocation
            'long_from' => 0.0012,
            'lat_to' => 0.0012,
            'long_to' => 0.0012,    // Assuming you have a factory for Geolocation
            'lat_start' => 0.0012,  // Assuming you have a factory for Geolocation
            'long_start' => 0.0012,
            'lat_end' => 0.0012,  // Assuming you have a factory for Geolocation
            'long_end' => 0.0012,
            'Distance' => 700,

        ];
        $headers = [
            'Authorization' => 'Bearer ' . $token,
        ];
        $response = $this->postJson('/api/company/path_store', $data1, $headers);

        $response->assertStatus(200);
    //    dd($response);
        $break1 = Breaks::factory()->create(['path_id' =>'2' ]);
        $break2 = Breaks::factory()->create(['path_id' =>'2' ]);

        // Create request data
        $data = [
            'path_id' => 2,
            'price' => '10.00',
            'bus_ids' => [
                [
                    'bus_id' => $bus1->id,
                    'type' => 'all',
                    "from_time_going" => "08:00",
                    "to_time_going" => "18:00",
                    "from_time_return" => "08:00",
                    "to_time_return" => "18:00",
                    "date_start" => "2022-01-10",
                    "date_end"=> "2022-01-19",
                ],
                [
                    'bus_id' => $bus2->id,
                    'type' => 'all',
                    "from_time_going" => "08:00",
                    "to_time_going" => "18:00",
                    "from_time_return" => "08:00",
                    "to_time_return" => "18:00",
                    "date_start" => "2022-01-10",
                    "date_end"=> "2022-01-19",
                ],
            ],
        ];

        // Make the request
        $response = $this->postJson('/api/company/store_trip', $data, $headers);

        $response->assertStatus(201);


        $this->assertDatabaseHas('trips', [
            'path_id' => 2,
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
        //dd($response->json());
        $this->assertEquals(4, Breaks_trip::where('trip_id', $response->json()['id'])->count()); // Check that two break trips were created

        foreach ($data['bus_ids'] as $busData) {
            $this->assertDatabaseHas('bus__trips', [
                'trip_id' =>$response->json()['id'],
                'from_time_going' => $busData['from_time_going'],
                'to_time_going' => $busData['to_time_going'],
                'from_time_return' => $busData['from_time_return'],
                'to_time_return' => $busData['to_time_return'],
                'date_end' => $busData['date_end'],
                'date_start' => $busData['date_start'],
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
            'bus_ids' => [
                [
                    'bus_id' => 'invalid_bus_id',
                    'type' => 'invalid',
                    "from_time_going" => "invalid",
                    "to_time_going" => "invalid",
                    "from_time_return" => "invalid",
                    "to_time_return" => "invalid",
                    "date_start" => "invalid",
                    "date_end"=> "invalid",
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
                    'type' => 'invalid',
                    "from_time_going" => "invalid",
                    "to_time_going" => "invalid",
                    "from_time_return" => "invalid",
                    "to_time_return" => "invalid",
                    "date_start" => "invalid",
                    "date_end"=> "invalid",
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

        $break1 = Breaks::factory()->create([
            
            "path_id"  =>$path->id
        ]);

        $break2 = Breaks::factory()->create([
            
            "path_id"  =>$path->id
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
            'status' => "pending",
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
            'breaks_id' =>$break1->id,
        ]);
        $breakTrip2 = Breaks_Trip::factory()->create([
            'trip_id' => $trip->id,
            'breaks_id' => $break2->id,
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
            'deleted_at' =>"NULL",
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
                    'deleted_at' =>"NULL",

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

