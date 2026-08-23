# Legacy Data Import Notes

The original repository included a root-level `data_migration.txt` scratch file containing the following Artisan import sequence. It is preserved here as project documentation instead of root-level clutter.

```bash
php artisan import:csv_User
php artisan import:csv_Company
php artisan import:csv_Driver
php artisan import:csv_Bus
php artisan import:csv_Seat
php artisan import:csv_Bus_Driver
php artisan import:csv_geolocation
php artisan import:csv_Path
php artisan import:csv_Breaks
php artisan import:csv_fixed_price
php artisan import:csv_Trip
php artisan import:csv_Breaks_trip
php artisan import:csv_Bus_trip
php artisan import:csv_pivoit
php artisan import:csv_reservation
php artisan import:csv_Seat_reservation
php artisan import:csv_favourit
```

The same scratch file also referenced targeted Laravel tests:

```bash
php artisan test --filter=test_it_registers_a_new_user
php artisan test --filter=test_login_invalid_password
php artisan test --filter=test_login_invalid_email
```

These commands are retained for historical/reference purposes only. Their successful execution has not yet been re-validated in the current professionalization phase.
