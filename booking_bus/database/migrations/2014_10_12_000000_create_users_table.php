<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('name');
            $table->string('type')->default(0);
            $table->string('email')->unique();
            $table->string('point')->default(200);
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->softDeletes();
            $table->rememberToken();
            $table->timestamps();
        });
        DB::table('users')->insert([
            [
                'id' => Str::uuid(),
                'name' => 'hamza',
                'type' => 0,
                'email' => 'user@gmail.com',
                'password' => Hash::make('123456789'),
                'email_verified_at' => now()
            ]
        ]);
        DB::table('users')->insert([
            [
                'id' => Str::uuid(),
                'name' => 'robert',
                'type' => 1,
                'email' => 'a@info.com',
                'password' => Hash::make('123456789'),
                'email_verified_at' => now()
            ]
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
