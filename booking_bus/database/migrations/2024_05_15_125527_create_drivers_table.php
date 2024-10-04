<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\User;
use App\Models\Company;
use App\Models\Driver;
use Illuminate\Support\Facades\Hash;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('drivers', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->softDeletes();
            $table->foreignIdFor(User::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->foreignIdFor(Company::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->string('status')->default('pending');
            $table->integer('Wages');
            $table->timestamps();
        });
        $this->createDriverUser();
    }
    protected function createDriverUser(): void
    {
        // Create a new user
        $user = User::create([
            'name' => 'Driver User',
            'email' => 'd@gmail.com',
            'password' => Hash::make('123456789'),
        ]);

        // Fetch a company (you may need to adjust this based on your logic)
        $company = Company::first(); // Assuming you have a company already seeded

        // Create a driver associated with the user and company
        Driver::create([
            'id' => (string) \Illuminate\Support\Str::uuid(),
            'user_id' => $user->id,
            'company_id' => $company->id,
            'Wages' => 5000,
        ]);
    }
    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('drivers');
    }
};
