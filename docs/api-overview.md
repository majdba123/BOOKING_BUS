# API Overview

This document summarizes the API surface that is registered in `booking_bus/routes/api.php`.

It is an architectural reference, not a substitute for generated API documentation or request/response schemas. Endpoint behavior, validation rules, and payload shapes remain defined by the Laravel routes and controllers.

## Authentication

The backend uses Laravel Sanctum for authenticated API access. Public authentication routes include user registration, login, logout, and transportation-company registration.

## API Areas

### Company operations

The `/api/company` route group is protected by company middleware, Sanctum authentication, and request throttling.

The registered company-facing capabilities include:

- driver registration, listing, update, deletion, and status filtering
- fleet/bus creation, update, deletion, listing, and status filtering
- driver-to-bus assignment and cancellation
- seat management
- route/path and stop/break management
- trip creation, update, cancellation, deletion, filtering, and bus replacement
- trip and driver ratings
- private-trip order handling
- company favourites visibility
- company profile and address management
- reservation dashboards and filtering
- trip and bus-trip profit calculations
- rewards management
- cancellation-rule management
- dynamic-pricing calculations
- insurance-cost management
- maintenance-cost management

### Administration

The `/api/admin` route group is protected by admin middleware, Sanctum authentication, and request throttling.

The registered administrative capabilities include:

- geographic/government management
- balance-charge request review
- inquiry management
- user inspection and reservation/trip history
- company inspection
- company driver, fleet, trip, reservation, and profitability views
- administrative dashboard statistics
- profile and address management

### Passenger/user services

The `/api/user` route group is protected by Sanctum authentication and request throttling.

The registered passenger capabilities include:

- trip discovery and path-based trip filtering
- bus-trip and seat lookup
- reservation creation and cancellation
- trip rating
- private-trip creation, update, deletion, and offer selection
- balance-charge requests
- favourite companies
- driver ratings
- profile and address management
- reservation history and status filtering
- inquiries
- company and driver discovery
- reservation-location lookup
- company cancellation-rule lookup

### Driver operations

The `/api/driver` route group is protected by Sanctum authentication and request throttling.

The registered driver capabilities include:

- assigned bus lookup
- pending and historical trips
- trip start and stop/break progression
- QR-based reservation completion/checking
- driver profile and address management
- completed-trip history
- ratings
- live trip geolocation updates through an application event

## Real-Time Features

The route layer publishes driver geolocation updates using `tripgeolocationEvent`. The repository also contains Pusher integration for broadcasting/realtime communication.

## Security Notes

- Authenticated groups use Laravel Sanctum.
- Company and admin groups include role-specific middleware.
- Major protected route groups include throttling (`throttle:70,1`).
- Secrets and environment-specific credentials should be supplied through environment configuration, never committed to source control.

## Source of Truth

For the exact current endpoints, HTTP methods, middleware, and controller bindings, use:

- `booking_bus/routes/api.php`
- the corresponding controllers under `booking_bus/app/Http/Controllers/`

The legacy `booking_bus/api.txt` file was removed during repository cleanup because it duplicated only part of the route surface, used local URLs, and contained example credentials.