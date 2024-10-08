<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Bus_Driver;
class ImportCsvBus_Driver extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_Bus_Driver';

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
        $filename = base_path('\public\bus_drivers.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $bus_driver = new Bus_Driver();
            $bus_driver->id = $data['id']; // Use the id from the CSV file
            $bus_driver->bus_id = $data['bus_id'];
            $bus_driver->driver_id = $data['driver_id'];
            $bus_driver->status = $data['status'];
            $bus_driver->save();
        }
        fclose($file);
        $this->info('Import Bus Driver completed successfully!');
    }
}
