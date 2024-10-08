<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Driver;
class ImportCsvDriver extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_Driver';

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
        $filename = base_path('\public\Driver.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $driver = new Driver();
            $driver->id = $data['id']; // Use the id from the CSV file
            $driver->user_id = $data['user_id'];
            $driver->company_id = $data['company_id'];
            $driver->status = $data['status'];
            $driver->Wages = $data['Wages'];
            $driver->save();
        }
        fclose($file);
        $this->info('Import Driver completed successfully!');
    }
}
