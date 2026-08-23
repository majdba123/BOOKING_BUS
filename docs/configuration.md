# Configuration and Secret Management

This repository contains a Laravel backend, a Vue web client, and a Flutter mobile client. Each component has different configuration requirements and should keep environment-specific values outside committed source code wherever the framework supports it.

## Laravel backend

A safe template is available at:

- `booking_bus/.env.example`

Local development should use a private `.env` file copied from that template.

Never commit real database credentials, Pusher secrets, mail credentials, cloud credentials, or production application keys.

## Vue web client

A safe template is available at:

- `booking_bus/booking_bus_front/.env.example`

Vue CLI exposes variables prefixed with `VUE_APP_` to client-side code. These values are bundled into the browser application and therefore must not be treated as server-side secrets.

Client-side provider keys such as Google Maps keys must be restricted using the provider's application/domain restrictions and API restrictions.

## Flutter mobile client

The API base URL supports a compile-time override through Dart defines:

```bash
flutter run --dart-define=API_BASE_URL=https://example.com/api/
```

The current implementation preserves the historical local-development URL as a fallback so the repository-cleanup phase does not unexpectedly break existing local workflows.

A later runtime-validation phase should replace that transitional fallback with environment-specific development/staging/production values after the target environments are confirmed.

## Google Maps key migration

The historical source currently contains a client-side Google Maps key in web/Android configuration. Removing it immediately would break map initialization for anyone relying on the existing setup.

The safe migration sequence is:

1. create/restrict or rotate the provider key externally;
2. configure the replacement through the web and Android build environments;
3. validate maps in both clients;
4. remove the historical hardcoded fallback;
5. verify the old key is disabled/restricted.

Because Git history remains public, deleting a key from the current tree does not revoke historical exposure. Provider-side restriction or rotation is required.

## Repository policy

- Commit example configuration only.
- Do not commit `.env`, `.env.local`, `local.properties`, credentials, private tokens, or signing secrets.
- Do not report sensitive values in issues, pull requests, documentation, or logs.
- Treat browser/mobile API keys as public client credentials and protect them with provider restrictions rather than secrecy alone.
