# Transportation ERP Platform

[English](README.md) | [العربية](README_AR.md)

> Multi-company transportation management and booking ecosystem for fleet operations, drivers, routes, trips, reservations, operational costs, and passenger services across web and mobile applications.

## Overview

Transportation ERP Platform is a full-stack transportation management system designed around the operational needs of bus transportation companies while also providing passenger-facing booking services.

The repository combines a Laravel REST API, a Vue web application, and a Flutter mobile application. The platform covers transportation-company operations as well as customer booking workflows, making it broader than a standalone bus-ticketing application.

## Platform Scope

### Transportation Company Operations

- Company and operational administration
- Fleet and bus management
- Driver management and driver-to-bus assignment
- Route, station, and trip management
- Seat and reservation workflows
- Maintenance and insurance-related cost tracking
- Operational dashboards and profit-related reporting workflows

### Booking & Passenger Services

- Trip discovery and booking flows
- Seat reservations
- Private-trip workflows
- Passenger profiles and addresses
- Favorites and ratings
- Notifications and real-time features
- Mobile experiences for passenger and driver workflows

### Administration & Access Control

The backend exposes authenticated API flows for different platform actors, including administrative, transportation-company, driver, and passenger-oriented workflows. Laravel Sanctum is used for API authentication, with role-specific middleware and protected route groups in the API layer.

## Architecture

```text
Client Applications
├── Vue Web Application
└── Flutter Mobile Application
          │
          ▼
Laravel REST API
├── Authentication & authorization
├── Transportation-company operations
├── Fleet & driver management
├── Routes, stations & trips
├── Reservations & passenger services
├── Operational-cost workflows
└── Real-time / notification integrations
          │
          ▼
Relational Database
```

See [System Overview](docs/system-overview.md) and [Architecture](docs/architecture.md) for more detail.

## Technology Stack

| Layer | Technologies |
| --- | --- |
| Backend | PHP, Laravel 10, REST APIs, Laravel Sanctum |
| Web | Vue 3, Vue Router, Vuex, Axios, Chart.js, Google Maps integration |
| Mobile | Flutter, Dart, Provider, Dio/HTTP, Google Maps, geolocation, QR/barcode tooling |
| Real-time | Pusher |
| Database | Relational database through Laravel ORM/migrations |
| Testing | PHPUnit / Laravel Feature & Unit tests, Vue unit-test setup |
| CI | GitHub Actions validation for backend and web client |

## CI Validation

The repository contains [`.github/workflows/validate-backend-web.yml`](.github/workflows/validate-backend-web.yml) for pull-request and manual validation.

The current workflow validates two application layers independently:

- **Laravel backend:** starts a MySQL 8 test service, prepares a testing environment, verifies application boot/routes, and runs the Laravel test suite.
- **Vue web client:** uses deterministic `npm ci`, then runs linting, unit tests, and a production bundle build.

This gives repository-level evidence for the **testing, GitHub Actions, CI/CD, environment configuration, and production-oriented delivery practices** described in my CV without claiming deployment or runtime results that have not been directly observed.

## Current Repository Layout

```text
.
├── .github/workflows/       # CI validation
├── booking_bus/             # Laravel backend and current Vue web application
│   └── booking_bus_front/   # Vue web application
├── Mobile_App/
│   └── mobile_app/          # Flutter mobile application
└── docs/                    # Project-level technical documentation
```

The current source-directory names are intentionally preserved because changing historical project paths without full runtime validation can break tooling, references, and deployment assumptions.

## Engineering Highlights

- Multi-company transportation domain rather than a single-operator booking flow
- Backend API covering fleet, drivers, routes, trips, seats, reservations, pricing, and operational workflows
- Separate web and mobile clients consuming the backend
- Passenger and driver mobile flows
- Real-time integration through Pusher
- Existing Laravel Feature and Unit tests for authentication, reservations, trips, and selected business logic
- GitHub Actions validation for backend and Vue web layers
- Centralized Google Maps configuration for Vue and Flutter clients instead of hardcoded provider keys
- Environment-driven CORS allowlists instead of wildcard browser origins
- Dedicated Android release-signing configuration rather than debug signing for production builds

## Configuration & Security

Runtime credentials and environment-specific values are kept outside committed source code through framework-appropriate configuration.

- Laravel uses private `.env` configuration with a safe committed template.
- Browser CORS origins are controlled through `CORS_ALLOWED_ORIGINS`.
- Vue reads its Maps key from `VUE_APP_GOOGLE_MAPS_API_KEY` through a centralized loader.
- Flutter reads service keys through `--dart-define` via `lib/config/app_config.dart`.
- Android injects its Maps SDK key through Gradle/local configuration rather than a manifest literal.
- Android release signing uses private `key.properties`/keystore configuration, both excluded from source control.
- Environment variants and local secret files are excluded by `.gitignore` patterns.

Older public commits contained client-side provider values. Current-source cleanup does not revoke historical exposure; historically exposed keys still require provider-side rotation/restriction and validation.

See [Configuration and Secret Management](docs/configuration.md) for the exact setup and rotation policy and [`SECURITY.md`](SECURITY.md) for vulnerability reporting.

## Project Status

The repository has been cleaned up for portfolio presentation and configuration hygiene without claiming runtime guarantees that have not been observed.

Repository documentation, secret handling, CORS configuration, Maps-key handling, Android release-signing configuration, and CI validation definitions have been hardened. Actual workflow-run status and full end-to-end runtime behavior should still be evaluated from executable validation rather than inferred from documentation alone.

## Documentation

- [System Overview](docs/system-overview.md)
- [Architecture](docs/architecture.md)
- [API Overview](docs/api-overview.md)
- [Configuration & Secret Management](docs/configuration.md)
- [Legacy Data Import Reference](docs/data-import.md)
- [Security Policy](SECURITY.md)

---

Built as a transportation-management ecosystem combining ERP-style operational workflows with passenger booking services.
