<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserApiController;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\CompanyController;
use App\Http\Controllers\BusController;
use App\Http\Controllers\PathController;
use App\Http\Controllers\DriverController;
use App\Http\Controllers\BusDriverController;
use App\Http\Controllers\SeatController;
use App\Http\Controllers\AreaController;
use App\Http\Controllers\BreaksController;
use App\Http\Controllers\TripController;
use App\Http\Controllers\BusTripController;

use App\Http\Controllers\ReservationController;










/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('register',[UserApiController::class,'register']);
Route::post('login',[UserApiController::class,'login']);
Route::post('logout',[UserApiController::class,'logout'])->middleware('auth:sanctum');


Route::post('register/company',[CompanyController::class,'register']);






Route::group(['prefix' => 'company' , 'middleware' => ['company','auth:sanctum']], function () {

    Route::get('/get_driver_by_status', [DriverController::class, 'get_driver_by_status']);
    Route::get('/all_driver', [DriverController::class, 'index']);
    Route::post('register/driver',[DriverController::class,'register_driver']);
    Route::delete('/delete_driver/{id}', [DriverController::class, 'destroy']);


    Route::get('/all_path', [PathController::class, 'index']);
    Route::post('/path_store', [PathController::class, 'store']);
    Route::put('/path_update/{id}', [PathController::class, 'update']);
    Route::delete('/path_delete/{id}', [PathController::class, 'destroy']);


    Route::get('/all_bus', [BusController::class, 'index']);
    Route::get('/get_bus_status', [BusController::class, 'get_bus_by_status']);
    Route::post('/store_bus', [BusController::class, 'store']);
    Route::put('/update_bus/{id}', [BusController::class, 'update']);
    Route::delete('/delete_bus/{id}', [BusController::class, 'destroy']);


    Route::post('/select_driver_to_bus/{id}', [BusDriverController::class, 'store']);
    Route::post('/cancelled_driver/{id}', [BusDriverController::class, 'cancelAssignment']);
    Route::get('/all_driver_with_bus', [BusDriverController::class, 'index']);

    Route::post('/all_seat_of_bus/{id}', [SeatController::class, 'index']);
    Route::post('/store_seat/{id}', [SeatController::class, 'store']);
    Route::put('/update_seat/{id}', [SeatController::class, 'update']);
    Route::delete('/delete_seat/{id}', [SeatController::class, 'destroy']);


    Route::get('/all_trips', [TripController::class, 'index']);
    Route::get('/all_trips_by_status', [TripController::class, 'index_status']);
    Route::post('/show_trip/{id}', [TripController::class, 'show']);
    Route::post('/store_trip', [TripController::class, 'store']);
    Route::put('/update_trip/{id}', [TripController::class, 'update']);
    Route::delete('/delete_trip/{id}', [TripController::class, 'destroy']);





});


Route::group(['prefix' => 'admin' , 'middleware' => ['checkAdmi','auth:sanctum']], function () {

    Route::get('/all_government', [AreaController::class, 'index']);
    Route::post('/store_government', [AreaController::class, 'store']);
    Route::put('/update_government/{id}', [AreaController::class, 'update']);
    Route::delete('/delete_government/{id}', [AreaController::class, 'destroy']);
    Route::post('/show_goverment/{id}', [AreaController::class, 'show']);


    Route::get('/all_breaks/{id}', [BreaksController::class, 'index']);
    Route::post('/store_breaks/{id}', [BreaksController::class, 'store']);
    Route::put('/update_breaks/{id}', [BreaksController::class, 'update']);
    Route::delete('/delete_breaks/{id}', [BreaksController::class, 'destroy']);
});






Route::group(['prefix' => 'user' , 'middleware' => ['auth:sanctum']], function () {

    Route::get('/trips', [TripController::class, 'index_user']);
    Route::get('/trip_by_path', [TripController::class, 'trip_user_by_path']);

    Route::post('/get_bus_trip/{id}', [BusTripController::class, 'getBusTripsByTripId']);
    Route::get('/get_bus_trip_fillter', [BusTripController::class, 'getBusTripsByFillter']);

    Route::post('/store_reservation/{id}', [ReservationController::class, 'store']);

});
