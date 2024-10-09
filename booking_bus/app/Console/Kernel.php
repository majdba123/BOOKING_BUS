<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    /**
     * Define the application's command schedule.
     */

    protected $commands = [

        \app\Console\Commands\ImportCsv::class,
        \app\Console\Commands\ImportCsvCompany::class,
        \app\Console\Commands\ImportCsvDriver::class,
        \app\Console\Commands\ImportCsvBus::class,
        \app\Console\Commands\ImportCsvSeat::class,
        \app\Console\Commands\ImportCsvBus_Driver::class,
        \app\Console\Commands\ImportCsvGeolocation::class,
        \app\Console\Commands\ImportCsvPath::class,
        \app\Console\Commands\ImportCsvBreaks::class,
        \app\Console\Commands\ImportCsvfixedprice::class,
        \app\Console\Commands\ImportCsvTrip::class,
        \app\Console\Commands\ImportCsvBreals_Trip::class,
        \app\Console\Commands\ImportCsvBus_trip::class,
        \app\Console\Commands\ImportCsvPivoit::class,
        \app\Console\Commands\ImportCsvReservation::class,
        \app\Console\Commands\ImportCsvSeatReservation::class,
        \app\Console\Commands\ImportCsvFavourit::class,

    ];

    protected function schedule(Schedule $schedule): void
    {
        // $schedule->command('inspire')->hourly();
    }

    /**
     * Register the commands for the application.
     */
    protected function commands(): void
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
}
