<?php

namespace Database\Seeders;

use App\Models\inquires;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class InquiresSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $defaultUsers = [
            'd@gmail.com',
            'c@gmail.com',
            'user@gmail.com',
            'a@info.com',
        ];

        foreach ($defaultUsers as $email) {
            inquires::factory()->create([
                'user_id' => User::where('email', $email)->first()->id, // Get the user ID
                'email' => $email,
                'quastion' => 'Sample question for ' . $email,
            ]);
        }
    }
}
