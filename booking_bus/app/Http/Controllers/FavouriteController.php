<?php

namespace App\Http\Controllers;

use App\Models\Favourite;
use App\Models\Company;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;

class FavouriteController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function all_company()
    {
        $companies = Company::with([
            'user.profile' => function ($query) {
                $query->select('profiles.*');
            },
            'user.address' => function ($query) {
                $query->select('addresses.*');
            },
        ])->get();

        if (!$companies) {
            return response()->json([
                'message' => 'company not found'
            ]);
        }

        $companies = $companies->map(function ($company) {
            $company->profile = $company->user->profile;
            $company->address = $company->user->address;
            unset($company->user);
            return $company;
        });

        return response()->json($companies);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function getUsersWhoFavouritedCompany()
    {
        $companyId = Auth::user()->Company->id;
        $favourites = Favourite::where('company_id', $companyId)->get();

        $users = [];

        foreach ($favourites as $favourite) {
            $users[] = $favourite->user;
        }

        return $users;
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'company_id' => 'required|exists:companies,id',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        $company_id = $request->input('company_id');

        // Get the authenticated user
        $user = auth()->user();
        $recentFavourite = $user->favourite()->where('company_id', $company_id)->latest()->first();

        if ($recentFavourite && $recentFavourite->created_at->gt(now()->subMinutes(10))) {

            return response()->json(['error' => 'You have already favorited this company recently'], 422);

        }

        // Create a new Favourite instance
        $favourite = new Favourite();

        // Set the user_id and company_id
        $favourite->user_id = $user->id;
        $favourite->company_id = $company_id;

        // Save the Favourite instance
        $favourite->save();

        // Return a success response
        return response()->json(['message' => 'Company added to favourites']);
    }
    /**
     * Display the specified resource.
     */
    public function show(Favourite $favourite)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function index_user()
    {
        $user = Auth::user();
        $favourites = Favourite::where('user_id', $user->id)->get();
        $data = [];

        foreach ($favourites as $favourite) {
            $data[] = [
                'id' => $favourite->id,
                'user_name' => $user->name,
                'user_id' => $favourite->user->id,
                'company_id' => $favourite->company->id,
                'company_name' => $favourite->company->name,
            ];
        }

        return response()->json($data);
    }

    /**
     * Update the specified resource in storage.
     */
    public function info_about_company($company_id)
    {
        $company = Company::with([
            'user.profile' => function ($query) {
                $query->select('profiles.*');
            },
            'user.address' => function ($query) {
                $query->select('addresses.*');
            },
        ])->find($company_id);

        if (!$company) {
            return response()->json([
                'message' => 'company not found'
            ]);
        }

        // Hide the user data from the response
        $company->user->makeHidden(['id', 'name', 'type', 'email', 'lang', 'lat', 'point', 'email_verified_at', 'created_at', 'updated_at']);

        return response()->json($company);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'company_id' => 'required|exists:companies,id',
        ]);

        if ($validator->fails()) {
            $errors = $validator->errors()->first();
            return response()->json(['error' => $errors], 422);
        }

        $company_id = $request->input('company_id');

        // Get the authenticated user
        $user = auth()->user();

        // Find the favourite instance to remove
        $favourite = $user->favourite()->where('company_id', $company_id)->first();

        if (!$favourite) {
            return response()->json(['error' => 'Favourite not found'], 404);
        }

        // Remove the favourite instance
        $favourite->delete();

        // Return a success response
        return response()->json(['message' => 'Company removed from favourites']);
    }
}
