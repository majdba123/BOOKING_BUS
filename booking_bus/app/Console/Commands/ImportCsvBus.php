<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Bus;
class ImportCsvBus extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_Bus';

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
        $filename = base_path('\public\buses.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $bus = new Bus();
            $bus->id = $data['id']; // Use the id from the CSV file
            $bus->company_id = $data['company_id'];
            $bus->Brand = $data['Brand'];
            $bus->number_bus = $data['number_bus'];
            $bus->number_passenger = $data['number_passenger'];
            $bus->status = $data['status'];
            $bus->purchase_date = $data['purchase_date'];
            $bus->purchase_price = $data['purchase_price'];
            $bus->lifespan_years = $data['lifespan_years'];
            $bus->bus_consumption = $data['bus_consumption'];
            $bus->fuel_consumption = $data['fuel_consumption'];
            $bus->save();
        }
        fclose($file);
        $this->info('Import Bus completed successfully!');
    }
}
