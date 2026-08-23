<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class DatabaseSeederTest extends TestCase
{
    use RefreshDatabase;

    public function test_demo_seed_builds_a_coherent_transportation_dataset(): void
    {
        $this->seed();

        $this->assertDatabaseHas('users', [
            'email' => 'admin@transport-demo.local',
            'type' => '1',
        ]);
        $this->assertDatabaseHas('companies', [
            'name_company' => 'TransRoute Demo',
        ]);
        $this->assertDatabaseCount('drivers', 2);
        $this->assertDatabaseCount('buses', 2);
        $this->assertDatabaseCount('seats', 36);
        $this->assertDatabaseCount('paths', 2);
        $this->assertDatabaseCount('trips', 2);
        $this->assertDatabaseCount('bus__trips', 2);
        $this->assertDatabaseHas('paths', [
            'from' => 'Damascus',
            'to' => 'Homs',
        ]);
    }
}
