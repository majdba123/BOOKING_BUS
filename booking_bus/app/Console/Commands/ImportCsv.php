<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\User;
class ImportCsv extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_User';

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
        $filename = base_path('\public\users.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $user = new User();
            $user->id = $data['id']; // Use the id from the CSV file
            $user->name = $data['name'];
            $user->type = $data['type'];
            $user->email = $data['email'];
            $user->point = $data['point'];
            $user->password = $data['password'];
            $user->email_verified_at = $data['email_verified_at'];
            $user->save();
        }
        fclose($file);
        $this->info('Import User completed successfully!');
    }
}
