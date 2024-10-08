<?php

namespace App\Console\Commands;
use App\Models\Bus_Trip;
use Illuminate\Console\Command;

class ImportCsvBus_trip extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_Bus_trip';

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
        $filename = base_path('\public\bus_trips.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $bus_trip = new Bus_Trip();
            $bus_trip->id = $data['id']; // Use the id from the CSV file
            $bus_trip->trip_id = $data['trip_id'];
            $bus_trip->bus_id = $data['bus_id'];
            $bus_trip->from_time_going = $data['from_time_going'];
            $bus_trip->to_time_going = $data['to_time_going'];
            $bus_trip->from_time_return = $data['from_time_return'];
            $bus_trip->to_time_return = $data['to_time_return'];
            $bus_trip->date_start = $data['date_start'];
            $bus_trip->date_end = $data['date_end'];
            $bus_trip->status = $data['status'];
            $bus_trip->type = $data['type'];
            $bus_trip->event = $data['event'];
            $bus_trip->save();
        }
        fclose($file);
        $this->info('Import Bus Trip completed successfully!');
    }
}
