<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Path;
class ImportCsvPath extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_Path';

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
        $filename = base_path('\public\paths.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $path = new Path();
            $path->id = $data['id']; // Use the id from the CSV file
            $path->company_id = $data['company_id'];
            $path->from = $data['from'];
            $path->from_location = $data['from_location'];
            $path->to = $data['to'];
            $path->to_location = $data['to_location'];
            $path->Distance = $data['Distance'];
            $path->save();
        }
        fclose($file);
        $this->info('Import Path completed successfully!');
    }
}
