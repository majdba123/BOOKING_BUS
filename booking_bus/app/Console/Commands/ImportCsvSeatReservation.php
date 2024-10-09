<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Seat_Reservation;
class ImportCsvSeatReservation extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_Seat_reservation';

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
        $filename = base_path('\public\seat_reservations.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $seat_reservation = new Seat_Reservation();
            $seat_reservation->id = $data['id']; // Use the id from the CSV file
            $seat_reservation->seat_id = $data['seat_id'];
            $seat_reservation->reservation_id = $data['reservation_id'];
            $seat_reservation->status = $data['status'];
            $seat_reservation->save();
        }
        fclose($file);
        $this->info('Import Seat Reservation completed successfully!');
    }
}
