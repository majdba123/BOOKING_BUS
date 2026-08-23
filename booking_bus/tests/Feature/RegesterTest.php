<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class RegesterTest extends TestCase
{
    use RefreshDatabase;

    public function test_it_registers_a_new_user(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => 'John Doe',
            'email' => 'johndoe2@example.com',
            'password' => 'password123',
        ]);

        $response->assertStatus(200);
        $response->assertJson(['message' => 'User Created ']);
        $this->assertDatabaseCount('users', 1);
        $this->assertDatabaseHas('users', [
            'name' => 'John Doe',
            'email' => 'johndoe2@example.com',
        ]);
    }

    public function test_Regester_validates_the_request_data(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => '',
            'email' => '',
            'password' => '',
        ]);

        $response->assertStatus(422);
        $response->assertJsonStructure(['error']);
        $this->assertDatabaseCount('users', 0);
    }

    public function test_returns_an_error_if_email_is_already_taken(): void
    {
        User::factory()->create(['email' => 'johndoe@example.com']);

        $response = $this->postJson('/api/register', [
            'name' => 'John Doe',
            'email' => 'johndoe@example.com',
            'password' => 'password123',
        ]);

        $response->assertStatus(422);
        $response->assertJson(['error' => 'Email has already been taken']);
        $this->assertDatabaseCount('users', 1);
    }
}
