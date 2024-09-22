<?php

use App\Models\Company;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('companies', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignIdFor(User::class)->constrained()->cascadeOnDelete()->cascadeOnUpdate();
            $table->string('name_company');
            $table->timestamps();
            $table->softDeletes();
        });
        $this->createCompanyUser();
    }
    protected function createCompanyUser(): void
    {
        // Create a new user
        $user = User::create([
            'name' => 'Company Owner',
            'email' => 'c@gmail.com',
            'password' => Hash::make('123456789'),
        ]);

        // Create a company associated with the user
        Company::create([
            'id' => (string) \Illuminate\Support\Str::uuid(),
            'user_id' => $user->id,
            'name_company' => 'Sample Company',
        ]);
    }
    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('companies');
    }
};
