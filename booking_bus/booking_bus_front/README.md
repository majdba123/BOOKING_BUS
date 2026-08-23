# Transportation ERP Web Application

Vue 3 web application for the Transportation ERP Platform.

## Purpose

The web client provides operational and administrative interfaces on top of the Laravel REST API. It includes transportation-company workflows, dashboards, fleet and trip management, mapping-related interfaces, reporting views, and other platform administration screens present in the source code.

## Stack

- Vue 3
- Vue Router
- Vuex
- Axios
- Chart.js
- Google Maps integration
- Pusher / realtime client integration
- Vue CLI

## Setup

```bash
npm install
cp .env.example .env.local
npm run serve
```

Environment-specific values should be stored in `.env.local` or another ignored environment file rather than committed to source control.

## Available Commands

```bash
npm run serve
npm run build
npm run test:unit
npm run lint
```

## Configuration

The repository now includes `.env.example` as a safe template for API, Google Maps, and Pusher configuration.

Some legacy runtime configuration is still being migrated carefully to environment-based configuration. It is intentionally not removed until runtime validation confirms the replacement path so that existing behavior is not broken.

## Testing Status

A Vue unit-test setup exists in `tests/unit/`. Full compatibility and execution are validated in the dedicated runtime/testing phase rather than being assumed from repository structure alone.

## Platform Documentation

See the repository root `README.md` and `docs/` directory for the platform-level overview and architecture.