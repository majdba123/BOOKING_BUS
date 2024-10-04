<?php

namespace Tests\Feature;

use App\Models\Bus_Trip;
use App\Models\Reservation;
use App\Models\Seat_Reservation;
use App\Models\User;
use App\Models\Bus;
use App\Models\Pivoit;
use App\Models\Seat;
use App\Models\Trip;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class ResevationTest extends TestCase
{
    /**
     * A basic feature test example.
     */
    use RefreshDatabase;
    public function test_reservation_store()
    {
        // Create a user and bus trip
        $user = User::factory()->create([
            'point' =>  '1000.00'
        ]);
        $bus1 = Bus::factory()->create([
            'status' => 'available',
        ]);
        $seat1 =Seat::factory()->create([
            'bus_id' => $bus1->id ,
            'status' => 0
        ]);
        $seat2 =Seat::factory()->create([
            'bus_id' => $bus1->id ,
            'status' => 0
        ]);



        $busTrip = Bus_Trip::factory()->create([
            'bus_id' => $bus1->id
        ]);

        $pivoit = Pivoit::factory()->create(['bus__trip_id' => $busTrip->id]);
       // dd($busTrip->Pivoit);
        // Login as the user
        $response = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password',
        ]);
        $token = $response->json()['access_token'];

        // Create request data
        $data = [
            'type' => 1,
            'seat' => [$seat2->id, $seat1->id],
            'break_id' => $pivoit->id,
        ];
        $headers = [
            'Authorization' => 'Bearer ' . $token,
        ];

        // Make the request
        $response = $this->postJson('/api/user/store_reservation/' . $busTrip->id, $data, $headers);
        dd($response);
        $response->assertStatus(200);

        $this->assertDatabaseHas('reservations', [
            'user_id' => $user->id,
            'bus__trip_id' => $busTrip->id,
        ]);
        $this->assertEquals(1, Reservation::count());

        foreach ($data['seat'] as $seatId) {
            $this->assertDatabaseHas('seat__reservations', [
                'reservation_id' =>$response->json()['reservation_id'],
                'seat_id' => $seatId,
            ]);
        }
        $this->assertEquals(2, Seat_Reservation::where('reservation_id', $response->json()['reservation_id'])->count());
    }
}
