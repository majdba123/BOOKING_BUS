<?php

namespace Database\Seeders;

use App\Models\Profile;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ProfileSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $userEmails = [
            'd@gmail.com',
            'c@gmail.com',
            'user@gmail.com',
            'a@info.com',
        ];

        foreach ($userEmails as $email) {
            $user = User::where('email', $email)->first();
            if ($user) {
                Profile::create([
                    'user_id' => $user->id,
                    'phone' => fake()->phoneNumber,
                    'image' => 'default.jpg',
                ]);
            }
        }
    }
}
