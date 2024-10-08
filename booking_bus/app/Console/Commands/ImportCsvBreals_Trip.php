<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Breaks_trip;
class ImportCsvBreals_Trip extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_Breaks_trip';

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
        $filename = base_path('\public\breaks_trips.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $breaks_trip = new Breaks_trip();
            $breaks_trip->id = $data['id']; // Use the id from the CSV file
            // other columns...
            $breaks_trip->id = $data['id'];
            $breaks_trip->trip_id = $data['trip_id'];
            $breaks_trip->break_id = $data['break_id'];
        }
        fclose($file);
        $this->info('Import Breaks Trip completed successfully!');
    }
}
