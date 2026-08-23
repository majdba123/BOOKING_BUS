# Transportation ERP Backend

Laravel backend and REST API for the Transportation ERP Platform.

## Responsibilities

This application contains the server-side domain logic for transportation-company operations and passenger services, including:

- authentication with Laravel Sanctum
- company, admin, passenger, and driver API areas
- fleet and bus management
- driver management and vehicle assignment
- routes, stops, trips, and seats
- reservations and cancellation flows
- private-trip workflows
- ratings and favourites
- balance-charge workflows
- rewards and cancellation rules
- dynamic-pricing calculations
- maintenance and insurance cost records
- dashboard and profit-related operations
- realtime event/broadcast integration

The exact registered API surface is defined in `routes/api.php`.

## Requirements

- PHP version supported by the repository's `composer.json`
- Composer
- MySQL-compatible database for the current test configuration
- Node.js/npm only where required by Laravel-side frontend tooling

## Local Setup

```bash
composer install
cp .env.example .env
php artisan key:generate
```

Configure the database and any required broadcast/Pusher values in `.env`, then run migrations as appropriate for the environment.

```bash
php artisan migrate
php artisan serve
```

Do not commit real credentials or production environment files.

## Tests

The repository includes Laravel Feature and Unit tests under `tests/`.

```bash
php artisan test
```

The current PHPUnit configuration expects a MySQL test database named `booking_test`; full test execution and test-environment hardening are handled in the runtime-validation phase.

## API Reference

Project-level API documentation is available at:

- `../docs/api-overview.md`

For exact endpoint definitions, middleware, and controller bindings, treat `routes/api.php` as the source of truth.

## Project Documentation

See the repository root for the full platform overview and architecture documentation.