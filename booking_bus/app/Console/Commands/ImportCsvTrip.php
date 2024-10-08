<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Trip;
class ImportCsvTrip extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_Trip';

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
        $filename = base_path('\public\trips.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $trip = new Trip();
            $trip->id = $data['id']; // Use the id from the CSV file
            $trip->company_id = $data['company_id'];
            $trip->path_id = $data['path_id'];
            $trip->status = $data['status'];
            $trip->pricing_id = $data['pricing_id'];
            $trip->pricing_type = $data['pricing_type'];
            $trip->save();
        }
        fclose($file);
        $this->info('Import Trip completed successfully!');
    }
}
