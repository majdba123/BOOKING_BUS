# Architecture

## High-Level Architecture

The project follows a multi-client architecture with a Laravel backend serving web and mobile clients through REST APIs.

```text
┌────────────────────────────┐
│       Vue Web Client       │
│ dashboards / operations    │
└──────────────┬─────────────┘
               │
               │ REST / realtime integrations
               │
┌──────────────▼─────────────┐
│        Laravel API         │
│ auth / domain workflows    │
│ business logic / data      │
└──────────────┬─────────────┘
               │
               │ ORM / migrations
               │
┌──────────────▼─────────────┐
│     Relational Database    │
└────────────────────────────┘
               ▲
               │ REST / realtime integrations
               │
┌──────────────┴─────────────┐
│    Flutter Mobile Client   │
│ passengers / drivers/maps  │
└────────────────────────────┘
```

## Backend

The backend is a Laravel 10 application responsible for the REST API, authentication, authorization checks, transportation-domain business logic, persistence, and external integrations.

Observed backend domains include:

- authentication and profiles
- transportation companies
- buses and fleet operations
- drivers and driver assignments
- routes, stations, and breaks
- trips and seat availability
- reservations/bookings
- private trips
- ratings and favorites
- maintenance and insurance-related records
- pricing, operational costs, and profit/reporting-oriented workflows
- notifications and real-time functionality

Laravel Sanctum is used for authenticated API access. Pusher is integrated for real-time functionality.

## Web Application

The browser client is implemented with Vue 3 and uses Vue Router, Vuex, Axios, mapping libraries/integrations, charting, and Pusher-facing functionality.

The current repository stores the Vue project under the Laravel directory. Repository cleanup may relocate it to a clearer top-level web boundary, but this professionalization phase does not redesign the client architecture.

## Mobile Application

The mobile client is implemented in Flutter/Dart and contains both passenger-oriented and driver-oriented screens. The current dependency and source layout show functionality for HTTP/API communication, state management, Google Maps, device location/geolocation, camera and QR/barcode tooling, PDF support, and Pusher-based real-time communication.

## Data Flow

1. A web or mobile client authenticates against the Laravel API.
2. The client calls protected or public REST endpoints depending on the workflow.
3. Laravel controllers/services/models execute domain operations and persist state through the relational database layer.
4. Selected workflows use Pusher for real-time communication.
5. Mapping/location functionality is consumed by web/mobile clients for route, trip, or driver-oriented experiences.

## Security Boundary

Secrets used by the backend must remain server-side and be provided through environment configuration. Client-side provider keys that must be exposed at runtime, such as browser/mobile mapping keys, must still be environment-specific and restricted by the provider to the intended applications, APIs, bundle IDs, package names, origins, or signing certificates.

Hardcoded local development endpoints and credentials are not considered portable repository configuration and are being removed from tracked source during repository professionalization.

## Validation Boundary

This document describes architecture evidenced by the current source tree. It does not claim production scale, uptime, deployment topology, benchmark results, or successful clean builds. Those items require separate runtime validation.
