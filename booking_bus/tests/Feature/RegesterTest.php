<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class RegesterTest extends TestCase
{
    /**
     * A basic feature test example.
     */
    use RefreshDatabase;

    public function test_it_registers_a_new_user()
    {
        $response = $this->postJson('/api/register', [
            'name' => 'John Doe',
            'email' => 'johndoe2@example.com', // use a different email address
            'password' => 'password123',
        ]);
        $response->assertStatus(200);
        $response->assertJson([ "message" => "User Created "]);
      //  dd($response);
       // $this->assertCount(1, User::all());
        $this->assertEquals(3,  User::count());
        $name = User::where('name' ,'John Doe' )->first();
        //dd($name->name);
        $this->assertEquals('John Doe', $name->name  );

        $this->assertEquals('johndoe2@example.com',  $name->email);
    }


    public function test_Regester_validates_the_request_data()
    {
        $response = $this->postJson('/api/register', [
            'name' => '',
            'email' => '',
            'password' => '',
        ]);
        $response->assertStatus(422);
        $response->assertJsonStructure(['error']);
        $this->assertEquals(1,  User::count());

        //dd($response);

    }



    public function test_returns_an_error_if_email_is_already_taken()
    {
        User::factory()->create(['email' => 'johndoe@example.com']);
        $response = $this->postJson('/api/register', [
            'name' => 'John Doe',
            'email' => 'johndoe@example.com',
            'password' => 'password123',
        ]);
        $response->assertStatus(422);
        $response->assertJson(["error" => "Email has already been taken"]);
        $this->assertEquals(2,  User::count());
    }
}
