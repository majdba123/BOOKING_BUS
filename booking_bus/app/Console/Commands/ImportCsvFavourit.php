<?php

namespace App\Console\Commands;

use App\Models\Breaks;
use App\Models\Favourite;
use Illuminate\Console\Command;

class ImportCsvFavourit extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_favourit';

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
        $filename = base_path('\public\favourites.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $fav = new Favourite();
            $fav->id = $data['id']; // Use the id from the CSV file
            $fav->user_id = $data['user_id'];
            $fav->company_id = $data['company_id'];
            $fav->rating = $data['rating'];
            $fav->save();
        }
        fclose($file);
        $this->info('Import favourite completed successfully!');
    }
}
