<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Pivoit;
class ImportCsvPivoit extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_pivoit';

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
        $filename = base_path('\public\pivoits.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $pivoit = new Pivoit();
            $pivoit->id = $data['id']; // Use the id from the CSV file
            $pivoit->bus__trip_id = $data['bus__trip_id'];
            $pivoit->breaks_trip_id = $data['breaks_trip_id'];
            $pivoit->status = $data['status'];
            $pivoit->save();
        }
        fclose($file);
        $this->info('Import Pivoit completed successfully!');
    }
}
