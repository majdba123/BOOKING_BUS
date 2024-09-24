<?php

namespace Database\Seeders;

use App\Models\Favourite;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class FavouriteSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $defaultUsers = [


            'user@gmail.com',

        ];

        foreach ($defaultUsers as $email) {
            $user = User::where('email', $email)->first();

            // Create a few favourites for each user
            for ($i = 0; $i < 1; $i++) {
                Favourite::factory()->create([
                    'user_id' => $user->id,
                ]);
            }
        }
    }
}
