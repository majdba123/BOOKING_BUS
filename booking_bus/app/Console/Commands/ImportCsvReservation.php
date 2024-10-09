<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Reservation;
class ImportCsvReservation extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_reservation';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Execute the console command.
     */
    public function handle() {
        $filename = base_path('\public\reservations.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $reservation = new Reservation();
            $reservation->id = $data['id']; // Use the id from the CSV file
            $reservation->user_id = $data['user_id'];
            $reservation->pivoit_id = $data['pivoit_id'];
            $reservation->bus__trip_id = $data['bus__trip_id'];
            $reservation->price = $data['price'];
            $reservation->type = $data['type'];
            $reservation->status = $data['status'];
            $reservation->save();
        }
        fclose($file);
        $this->info('Import Reservation completed successfully!');
    }
}
