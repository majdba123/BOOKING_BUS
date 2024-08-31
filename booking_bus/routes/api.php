<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Lock;
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
use App\Http\Controllers\RateTripsController;
use App\Http\Controllers\ReservationController;
use App\Http\Controllers\PrivateTripController;
use App\Http\Controllers\OrderPrivateTripController;
use App\Http\Controllers\ChargeBalanceController;
use App\Http\Controllers\FavouriteController;
use App\Http\Controllers\RateDriverController;
use App\Http\Controllers\AddressController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\InquiresController;
use App\Http\Controllers\DriverProfileController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\AdminDashBoardController;
use App\Http\Controllers\CancellationRuleController;
use App\Http\Controllers\RewardController;
use App\Events\tripgeolocationEvent;



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

Route::post('register', [UserApiController::class, 'register']);
Route::post('login', [UserApiController::class, 'login']);
Route::post('logout', [UserApiController::class, 'logout'])->middleware('auth:sanctum');


Route::post('register/company', [CompanyController::class, 'register']);


Route::get('all_user', [AdminDashBoardController::class, 'all_user']);



Route::group(['prefix' => 'company', 'middleware' => ['company', 'auth:sanctum', 'throttle:30,1']], function () {

    Route::get('/get_driver_by_status', [DriverController::class, 'get_driver_by_status']);
    Route::get('/all_driver', [DriverController::class, 'index']);
    Route::post('register/driver', [DriverController::class, 'register_driver']);
    Route::delete('/delete_driver/{id}', [DriverController::class, 'destroy']);


    Route::get('/all_breaks/{path_id}', [BreaksController::class, 'index']);
    Route::post('/store_breaks/{id}', [BreaksController::class, 'store']);
    Route::put('/update_breaks/{id}', [BreaksController::class, 'update']);
    Route::delete('/delete_breaks/{id}', [BreaksController::class, 'destroy']);


    Route::get('/all_path', [PathController::class, 'index']);
    Route::post('/path_store', [PathController::class, 'store']);
    Route::put('/path_update/{id}', [PathController::class, 'update']);
    Route::delete('/path_delete/{id}', [PathController::class, 'destroy']);


    Route::get('/all_bus', [BusController::class, 'index']);
    Route::get('/get_bus_status', [BusController::class, 'get_bus_by_status']);
    Route::post('/store_bus', [BusController::class, 'store']);
    Route::put('/update_bus/{id}', [BusController::class, 'update']);
    Route::delete('/delete_bus/{id}', [BusController::class, 'destroy']);

    Route::post('/get_bus_trip/{id}', [BusTripController::class, 'getBusTripsByTripId']);
    Route::get('/get_bus_trip_fillter', [BusTripController::class, 'get_fillter_bus_trip']);

    Route::post('/select_driver_to_bus/{id}', [BusDriverController::class, 'store']);
    Route::post('/cancelled_driver/{id}', [BusDriverController::class, 'cancelAssignment']);
    Route::get('/all_driver_with_bus', [BusDriverController::class, 'index']);

    Route::post('/all_seat_of_bus/{id}', [SeatController::class, 'index']);
    Route::post('/store_seat/{id}', [SeatController::class, 'store']);
    Route::put('/update_seat/{id}', [SeatController::class, 'update']);
    Route::delete('/delete_seat/{id}', [SeatController::class, 'destroy']);


    Route::get('/all_trips', [TripController::class, 'index']);
    Route::get('/all_trips_by_status', [TripController::class, 'index_status']);
    Route::post('/store_trip', [TripController::class, 'store']);
    Route::post('/show_trip/{id}', [TripController::class, 'show']);

    Route::put('/update_trip/{id}', [TripController::class, 'update']);
    Route::delete('/delete_trip/{id}', [TripController::class, 'destroy']);
    Route::post('/trips/cancel', [TripController::class, 'cancelTrip']); //hamza
    Route::post('/replace-bus-trip', [BusTripController::class, 'replaceBusTrip']); //hamza

    Route::get('/all_trip_rating', [RateTripsController::class, 'index']);
    Route::post('/all_trip_rating_by_trip_id/{trip_id}', [RateTripsController::class, 'rate_trip__by_id']);

    Route::get('/private_trips', [PrivateTripController::class, 'index']);

    Route::post('/accept_private_order/{private_order_id}', [OrderPrivateTripController::class, 'store']);
    Route::get('/my_ordes_for_private_trip', [OrderPrivateTripController::class, 'my_orders']);

    Route::get('/our_favourite', [FavouriteController::class, 'getUsersWhoFavouritedCompany']);


    Route::get('/all_driver_rating', [RateDriverController::class, 'index']);
    Route::post('/all_driver_rating_by_driver_id/{driver_id}', [RateDriverController::class, 'rate_driver__by_id']);


    /* Route::get('/all_breaks/{area_id}', [BreaksController::class, 'index']);

    Route::get('/all_government', [AreaController::class, 'index']);
    Route::post('/show_goverment/{id}', [AreaController::class, 'show']);*/


    Route::get('/my_info', [ProfileController::class, 'index']);
    Route::post('/store_profile_info', [ProfileController::class, 'store']);
    Route::post('/update_profile_info', [ProfileController::class, 'update']);
    Route::put('/update_password', [ProfileController::class, 'update_password']);


    Route::get('/all_my_address', [AddressController::class, 'index']);
    Route::post('/store_address', [AddressController::class, 'store']);
    Route::put('/update_address/{address_id}', [AddressController::class, 'update']);



    Route::get('/all_reservation', [DashboardController::class, 'all_reservation']);
    Route::get('/all_reservation_by_status', [DashboardController::class, 'all_reservation_by_status']);
    Route::post('/all_reservation_by_bus_trip/{bus_trip_id}', [DashboardController::class, 'all_reservation_by_bus_trip']);
    Route::post('/all_reservation_by_pivoit_id/{pivoit_id}', [DashboardController::class, 'reser_by_break']);


    Route::get('/dashboard_company', [DashboardController::class, 'my_dash_boad']);
    Route::post('/get_profit_bus_trip/{bus_trip_id}', [DashboardController::class, 'get_profit_bus_trip']);
    Route::post('/get_profit_trip/{bus_trip_id}', [DashboardController::class, 'get_profit_trip']);
    Route::post('/user_infomation_id/{user_id}', [DashboardController::class, 'user_info']);

    Route::prefix('rewards')->group(function () {   //hamza
        Route::get('/', [RewardController::class, 'index']);
        Route::get('/{id}', [RewardController::class, 'show']);
        Route::post('/store', [RewardController::class, 'store']);
        Route::put('/{id}', [RewardController::class, 'update']);
        Route::delete('/{id}', [RewardController::class, 'destroy']);
    });
    Route::prefix('cancellation-rules')->group(function () {    //hamza
        Route::get('/', [CancellationRuleController::class, 'index']);
        Route::get('/{id}', [CancellationRuleController::class, 'show']);
        Route::post('/store', [CancellationRuleController::class, 'store']);
        Route::put('/{id}', [CancellationRuleController::class, 'update']);
        Route::delete('/{id}', [CancellationRuleController::class, 'destroy']);
    });

    Route::post('/get_profit_1', [DashboardController::class, 'getPriceData']);

});


Route::group(['prefix' => 'admin', 'middleware' => ['checkAdmi', 'auth:sanctum', 'throttle:30,1']], function () {

    Route::get('/all_government', [AreaController::class, 'index']);
    Route::post('/store_government', [AreaController::class, 'store']);
    Route::put('/update_government/{id}', [AreaController::class, 'update']);
    Route::delete('/delete_government/{id}', [AreaController::class, 'destroy']);
    Route::post('/show_goverment/{id}', [AreaController::class, 'show']);





    Route::get('/charge_balance_padding', [ChargeBalanceController::class, 'index']);
    Route::get('/charge_balance_by_status', [ChargeBalanceController::class, 'index1']);
    Route::post('/show_order_balance/{balance_id}', [ChargeBalanceController::class, 'show']);
    Route::post('/accepted_order_balance/{balance_id}', [ChargeBalanceController::class, 'accepted']);
    Route::post('/cancelled_order_balance/{balance_id}', [ChargeBalanceController::class, 'cancelled']);
    /**<img src="{{ asset('storage/photo.jpg') }}" alt="My Photo"> */


    Route::get('/all_inquires', [InquiresController::class, 'admin_index']);
    Route::get('/all_inquires_admin_by_stauts', [InquiresController::class, 'admin_by_status']);

    Route::get('/all_user', [AdminDashBoardController::class, 'all_user']);
    Route::get('/show_user_details/{user_id}', [AdminDashBoardController::class, 'user_details']);
    Route::get('/fillter_user', [AdminDashBoardController::class, 'fillter_user']);
    Route::post('/user_reservation_info/{user_id}', [AdminDashBoardController::class, 'user_reservation']);
    Route::post('/user_reservation_by_status/{user_id}', [AdminDashBoardController::class, 'user_reservation_by_status']);
    Route::post('/all_trip_history_of_user/{user_id}', [AdminDashBoardController::class, 'all_trip_history_of_user']);
    Route::post('/all_trip_history_of_user_fillter/{user_id}', [AdminDashBoardController::class, 'all_trip_history_of_user_fillter']);
    Route::post('/favourite_company_of_user/{user_id}', [AdminDashBoardController::class, 'favourite_company_of_user']);
    Route::post('/private_order_of_user/{user_id}', [AdminDashBoardController::class, 'private_order_of_user']);
    Route::post('/private_order_of_user_by_fillter/{user_id}', [AdminDashBoardController::class, 'private_order_of_user_fillter']);


    Route::get('/all_company', [AdminDashBoardController::class, 'all_company']);
    Route::post('/company_by_id/{company_id}', [AdminDashBoardController::class, 'company_by_id']);
    Route::post('/fillter_by_name_email', [AdminDashBoardController::class, 'fillter_company']);
    Route::post('/all_driver_by_company/{company_id}', [AdminDashBoardController::class, 'all_driver_by_id_company']);
    Route::post('/all_bus_by_id_company/{company_id}', [AdminDashBoardController::class, 'all_bus_by_id_company']);
    Route::post('/all_driver_status_by_id_company/{company_id}', [AdminDashBoardController::class, 'all_driver_status_by_id_company']);
    Route::post('/all_bus_status_by_id_company/{company_id}', [AdminDashBoardController::class, 'all_bus_status_by_id_company']);
    Route::post('/all_trip_of_company/{company_id}', [AdminDashBoardController::class, 'all_trip_of_company']);
    Route::post('/trip_by_status_of_company/{company_id}', [AdminDashBoardController::class, 'trip_by_status_of_company']);
    Route::post('/fillter_all_trip', [AdminDashBoardController::class, 'fillter_all_trip']);


    Route::post('/get_all_BusTripsByTripId/{company_id}', [AdminDashBoardController::class, 'get_all_BusTripsByTripId']);
    Route::post('/get_all_BusTripsByFillter', [AdminDashBoardController::class, 'get_all_BusTripsByFillter']);

    Route::post('/all_reservation_of_company/{company_id}', [AdminDashBoardController::class, 'all_reservation_of_company']);
    Route::post('/all_reservation_of_company__by_status/{company_id}', [AdminDashBoardController::class, 'all_reservation_of_company__by_status']);
    Route::post('/all_reservation_by_bus_trip/{company_id}', [AdminDashBoardController::class, 'all_reservation_by_bus_trip']);
    /**_____________________________________ */
    Route::post('/get_profit_bus_trip/{bus_trip_id}', [AdminDashBoardController::class, 'get_profit_bus_trip']);
    Route::post('/get_profit_trip/{bus_trip_id}', [AdminDashBoardController::class, 'get_profit_trip']);
    Route::post('/user_infomation_id/{user_id}', [AdminDashBoardController::class, 'user_info']);
    Route::post('/company_all_info/{company_id}', [AdminDashBoardController::class, 'company_all_info']);

    Route::get('/dashboard_Admin', [AdminDashBoardController::class, 'statiesticle_dash']);

    //hamza

    //  Route::get('/all_breaks', [BreaksController::class, 'allbreaks']);


    Route::post('/get_profit_/{company_id}', [AdminDashBoardController::class, 'getPriceData1']);
});





Route::group(['prefix' => 'user', 'middleware' => ['auth:sanctum', 'throttle:30,1']], function () {

    Route::get('/trips', [TripController::class, 'index_user']);
    Route::get('/trip_by_path', [TripController::class, 'trip_user_by_path']);

    Route::post('/get_bus_trip/{id}', [BusTripController::class, 'getBusTripsByTripId']);
    Route::post('/seatOfBus/{id}', [SeatController::class, 'seatOfBus']);
    Route::get('/get_bus_trip_fillter', [BusTripController::class, 'getBusTripsByFillter']);

    Route::post('/store_reservation/{id}', [ReservationController::class, 'store']);
    Route::post('/cancel_Reservation/{id}', [ReservationController::class, 'cancelReservation']);

    Route::post('/rate_trip/{trip_id}', [RateTripsController::class, 'store']);

    Route::post('/store_private_trip', [PrivateTripController::class, 'store']);
    Route::put('/update_private_trip/{private_trip_id}', [PrivateTripController::class, 'update']);
    Route::delete('/delete_private_trip/{private_trip_id}', [PrivateTripController::class, 'destroy']);
    Route::get('/get_my_private_order_by_status', [PrivateTripController::class, 'getPrivateTripsByStatus']);

    Route::get('/OrderPrivateTripController/{private_trip_id}', [OrderPrivateTripController::class, 'index']);
    Route::post('/accept_company_for_private/{oreder_private_id}', [OrderPrivateTripController::class, 'accept']);


    Route::post('/charge_blance', [ChargeBalanceController::class, 'store']);
    Route::get('/all_my_charge_balance', [ChargeBalanceController::class, 'all_my_charge_balance']);
    Route::get('/all_my_charge_balance_by_status', [ChargeBalanceController::class, 'all_my_charge_balance_by_status']);



    Route::get('/all_my_favourite_company', [FavouriteController::class, 'index_user']);
    Route::post('/add_company_to_favourite', [FavouriteController::class, 'store']);
    Route::delete('/remove_company_from_favourite', [FavouriteController::class, 'destroy']);
    Route::post('/show_info_about_company/{company_id}', [FavouriteController::class, 'info_about_company']);
    Route::get('/get_all_company', [FavouriteController::class, 'all_company']);


    Route::post('/rate_driver/{driver_id}', [RateDriverController::class, 'store']);


    Route::get('/all_my_address', [AddressController::class, 'index']);
    Route::post('/store_address', [AddressController::class, 'store']);
    Route::put('/update_address/{address_id}', [AddressController::class, 'update']);


    // Route::get('/all_breaks/{area_id}', [BreaksController::class, 'index']);


    Route::get('/my_info', [ProfileController::class, 'index']);
    Route::post('/store_profile_info', [ProfileController::class, 'store']);
    Route::post('/update_profile_info', [ProfileController::class, 'update']);
    Route::put('/update_password', [ProfileController::class, 'update_password']);
    Route::get('/all_my_reservation', [ProfileController::class, 'my_reserva']);
    Route::get('/all_my_reservation_by_status', [ProfileController::class, 'my_reserva_by_status']);


    Route::get('/all_my_inquires', [InquiresController::class, 'index']);
    Route::get('/inquires_by_status', [InquiresController::class, 'by_status']);
    Route::post('/store_quastion', [InquiresController::class, 'store']);
    Route::delete('/delete_inquires/{inquires_id}', [InquiresController::class, 'destroy']);

    Route::get('/get_all_company', [UserApiController::class, 'get_all_company']);
    Route::get('/get_all_driver', [UserApiController::class, 'get_all_driver']);
});




Route::group(['prefix' => 'driver', 'middleware' => ['auth:sanctum', 'throttle:30,1']], function () {

    Route::get('/my_bus', [DriverController::class, 'my_bus']);
    Route::get('/my_pending_trip', [DriverController::class, 'my_pending_trip']);
    Route::get('/specificPendingTrip/{bus_trip_id}', [DriverController::class, 'specificPendingTrip']);
    Route::get('/history', [DriverController::class, 'history']);

    Route::get('/start_trip', [DriverController::class, 'start_trip']);
    Route::post('/finish_breaks/{id}', [DriverController::class, 'finish_breaks']);
    Route::post('/access_to_break/{id}', [DriverController::class, 'access_break']);


    Route::post('/Qr_for_complete/{reservation_id}', [DriverController::class, 'check_reservation']);

    Route::get('/info_profile_driver', [DriverProfileController::class, 'index']);
    Route::post('/store_profile_info', [DriverProfileController::class, 'store']);
    Route::post('/update_profile_info', [DriverProfileController::class, 'update']);
    Route::put('/update_password', [DriverProfileController::class, 'update_password']);

    Route::get('/all_my_address', [AddressController::class, 'index']);
    Route::post('/store_address', [AddressController::class, 'store']);
    Route::put('/update_address/{address_id}', [AddressController::class, 'update']);

    Route::get('/my_finished_going_trip', [DriverController::class, 'my_finished_going_trip']);
    Route::get('/my_finished_trip', [DriverController::class, 'my_finished_trip']);

    Route::get('/all_my_bus', [BusDriverController::class, 'bus_driveer']);
    Route::get('/all_my_rate', [RateDriverController::class, 'all_my_rate']);


    Route::post('/geolocation/{bus_trip_id}', function (Request $request, $busTripId) {

        $lang = $request->input('lang');
        $lat = $request->input('lat');

        event(new tripgeolocationEvent($lang, $lat, $busTripId));
        return response()->json(['message' => 'Geolocation updated successfully']);
    });

    /*!! Hamza!! */

    Route::get('/first-trip', [BusDriverController::class, 'getFirstTrip']);
    Route::get('/point', [BusDriverController::class, 'getPointofDriver']);
});
