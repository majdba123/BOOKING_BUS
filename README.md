# Transportation ERP Platform

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

The backend exposes authenticated API flows for different platform actors, including administrative, transportation-company, driver, and passenger-oriented workflows. Laravel Sanctum is used for API authentication, with authorization checks applied to protected operations.

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

## Current Repository Layout

```text
.
├── booking_bus/             # Laravel backend and current Vue web application
│   └── booking_bus_front/   # Vue web application
├── Mobile_App/
│   └── mobile_app/          # Flutter mobile application
└── docs/                    # Project-level technical documentation
```

A follow-up repository-structure cleanup will normalize these directories into clearer `backend/`, `web/`, and `mobile/` boundaries without changing business logic.

## Engineering Highlights

- Multi-company transportation domain rather than a single-operator booking flow
- Backend API covering fleet, drivers, routes, trips, seats, reservations, pricing, and operational workflows
- Separate web and mobile clients consuming the backend
- Passenger and driver mobile flows
- Real-time integration through Pusher
- Existing Laravel Feature and Unit tests for authentication, reservations, trips, and selected business logic

## Configuration & Security

Runtime credentials and environment-specific values should be supplied through environment configuration rather than committed directly to the repository. Public API keys must be appropriately restricted at the provider level even when technically exposed to client applications.

No production credentials should be committed to this repository.

## Project Status

This repository is currently being professionalized for portfolio and engineering-review use. Repository presentation and configuration hygiene are being cleaned first; full runtime validation, dependency verification, builds, automated tests, and CI hardening are intentionally handled as a separate engineering phase.

## Documentation

- [System Overview](docs/system-overview.md)
- [Architecture](docs/architecture.md)

---

Built as a complete transportation-management ecosystem combining ERP-style operational workflows with passenger booking services.