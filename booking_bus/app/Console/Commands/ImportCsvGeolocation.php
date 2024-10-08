<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Geolocation;
class ImportCsvGeolocation extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_geolocation';

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

        #$filename = base_path('public/GSM_final.csv');
        $filename=base_path('\public\geolocations.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            Geolocation::create(array_combine($header, $row));
        }
        fclose($file);
        $this->info('Import  User completed successfully!');
      }
}
