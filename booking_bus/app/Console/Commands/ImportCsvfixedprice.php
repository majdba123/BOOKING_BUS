<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\FixedPricingModel;
class ImportCsvfixedprice extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:csv_fixed_price';

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
        $filename = base_path('\public\fixed_pricing_models.csv');
        if (!file_exists($filename)) {
            $this->error('CSV file not found!'); return;
        }
        $file = fopen($filename, 'r');
        $header = fgetcsv($file);
        // Read the header row
        while (($row = fgetcsv($file)) !== false) {
            $data = array_combine($header, $row);
            $fixed_pricing_model = new FixedPricingModel();
            $fixed_pricing_model->id = $data['id']; // Use the id from the CSV file
            $fixed_pricing_model->cost = $data['cost'];
            $fixed_pricing_model->save();
        }
        fclose($file);
        $this->info('Import Fixed Pricing Model completed successfully!');
    }
}
