<?php

namespace Database\Seeders;

use App\Models\Address;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class AddressSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = [
            'd@gmail.com',
            'c@gmail.com',
            'user@gmail.com',
            'a@info.com',
        ];

        foreach ($users as $email) {
            $user = User::where('email', $email)->first();
            if ($user) {
                Address::factory()->create([
                    'user_id' => $user->id,
                    'city' => 'Example City',
                    'area' => 'Example Area',
                ]);
            }
        }
    }
}
