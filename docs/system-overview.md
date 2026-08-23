# System Overview

## Product Definition

Transportation ERP Platform is a multi-company transportation management and booking ecosystem. It combines ERP-style operational management for transportation companies with passenger-facing booking and mobile workflows.

The system is not limited to ticket booking. Its current source tree contains workflows for transportation companies, fleets, buses, drivers, routes, stations, trips, seats, reservations, private trips, maintenance and insurance-related costs, reporting/profit-oriented views, passenger profiles, favorites, ratings, notifications, and real-time features.

## Main Actors

### Platform Administration

Administrative flows manage platform-level data and oversee transportation-company operations exposed by the backend.

### Transportation Companies

Company-oriented workflows cover operational entities such as buses, drivers, routes, trips, reservations, maintenance, insurance-related costs, and reporting views.

### Drivers

The mobile application contains driver-oriented dashboard and trip workflows, including map/location functionality.

### Passengers

Passenger-facing functionality includes trip discovery, booking/reservation flows, private trips, favorites, profile/address management, ratings, notifications, and mobile map-based experiences.

## Main Domains

- Company administration
- Fleet and bus management
- Driver management
- Routes and stations
- Trip scheduling and operations
- Seat management
- Reservations and bookings
- Private trips
- Passenger services
- Maintenance and insurance-related costs
- Pricing and operational-cost workflows
- Profit/reporting-oriented workflows
- Notifications and real-time communication

## Applications

### Laravel Backend

The Laravel application provides the central REST API and business logic. Authentication is handled with Laravel Sanctum, and protected routes apply role/authorization controls where implemented by the existing application.

### Vue Web Application

The Vue application provides browser-based management interfaces and dashboards. It consumes backend APIs and includes mapping, charting, and real-time integrations used by operational workflows.

### Flutter Mobile Application

The Flutter application contains passenger and driver experiences, including booking-oriented screens, private-trip workflows, map/geolocation functionality, QR/barcode tooling, and real-time integration.

## Repository Professionalization Scope

The current professionalization phase is intentionally limited to repository presentation, documentation, configuration hygiene, and safe structural cleanup. Full dependency installation, runtime verification, automated test execution, build validation, and application-level bug fixing belong to the next phase.
