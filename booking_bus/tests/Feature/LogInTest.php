<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\Auth;
use Tests\TestCase;

class LogInTest extends TestCase
{
    /**
     * A basic feature test example.
     */
    use RefreshDatabase;

    public function test_login()
    {
        $user = User::factory()->create();
        // Act
        $response = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password',
        ]);
        // Assert
        $response->assertStatus(200);
        $response->assertJsonStructure([
            'access_token',
            'type_user',
        ]);
        $this->assertNotNull($response->json('access_token'));
        $this->assertNotNull($response->json('type_user'));
    }

    public function test_login_invalid_password()
    {
        $user = User::factory()->create();
        // Act
        $response = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'invalid_password', // invalid password
        ]);
        // Assert
        $response->assertStatus(401); // unauthorized
        $response->assertJsonStructure([
            'message',
        ]);
        $response->assertJson([ "message"=> "Invalid Credentials"]);
    }

    public function test_login_invalid_email()
    {
        $user = User::factory()->create();
        // Act
        $response = $this->postJson('/api/login', [
            'email' => "dwdw@gmail.com",
            'password' => 'password', // invalid password
        ]);
        // Assert
        $response->assertStatus(401); // unauthorized
        $response->assertJsonStructure([
            'message',
        ]);
        $response->assertJson([ "message"=> "Invalid Credentials"]);
    }
}
