<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\pusherCntroller;
use Illuminate\Support\Facades\Auth;
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});


Route::get('/trip', function () {
    return view('trip');
});


Route::get('/seat', function () {
    return view('seat');
})->middleware('auth');

Route::get('/geolocation', function () {
    return view('geolocation');
})->middleware('auth');

Route::get('/notification', function () {
    return view('notification');
});

Route::get('/foruser', function () {
    return view('foruser');
})->middleware('auth');


Route::get('/breaktrip', function () {
    return view('breakTrip');
})->middleware('auth');

Auth::routes();

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');



