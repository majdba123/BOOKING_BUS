<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Seat;
class ImportCsvSeat extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_Seat';

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
        $filename = base_path('\public\seats.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $seat = new Seat();
            $seat->id = $data['id']; // Use the id from the CSV file
            $seat->bus_id = $data['bus_id'];
            $seat->status = $data['status'];
            $seat->save();
        }
        fclose($file);
        $this->info('Import Seat completed successfully!');
    }
}
