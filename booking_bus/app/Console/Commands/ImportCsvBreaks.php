<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Breaks;
class ImportCsvBreaks extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_Breaks';

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
        $filename = base_path('\public\breaks.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $breaks = new Breaks();
            $breaks->id = $data['id']; // Use the id from the CSV file
            $breaks->path_id = $data['path_id'];
            $breaks->name = $data['name'];
            $breaks->geolocation_id = $data['geolocation_id'];
            $breaks->save();
        }
        fclose($file);
        $this->info('Import Breaks completed successfully!');
    }
}
