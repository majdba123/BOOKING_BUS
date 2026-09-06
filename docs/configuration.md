# Configuration and Secret Management

This repository contains a Laravel backend, a Vue web client, and a Flutter mobile client. Environment-specific values are intentionally kept outside committed source code wherever the framework supports it.

## Laravel backend

A safe template is available at:

- `booking_bus/.env.example`

Local development should use a private `.env` file copied from that template.

Never commit real database credentials, Pusher secrets, mail credentials, cloud credentials, production application keys, or deployment tokens.

CORS is configured through `CORS_ALLOWED_ORIGINS`; production deployments should list only the trusted HTTPS web origins that need browser access to the API.

## Vue web client

A safe template is available at:

- `booking_bus/booking_bus_front/.env.example`

The Google Maps JavaScript loader reads:

```env
VUE_APP_GOOGLE_MAPS_API_KEY=<restricted-browser-key>
```

Vue CLI exposes variables prefixed with `VUE_APP_` to client-side code. They are bundled into the browser application and must never be treated as server-side secrets. Google Maps browser keys should be restricted in Google Cloud by permitted HTTP referrers and by the minimum required Maps APIs.

The application uses a centralized Maps loader so individual components do not embed provider keys or load the Maps SDK repeatedly.

## Flutter mobile client

Runtime Dart code reads the Maps key from a compile-time Dart define:

```bash
flutter run \
  --dart-define=API_BASE_URL=https://example.com/api/ \
  --dart-define=GOOGLE_MAPS_API_KEY=<restricted-mobile-key>
```

`lib/config/app_config.dart` validates that the Maps key is present before code paths that call Google Directions, Geocoding, Distance Matrix, or polyline services.

### Android Maps SDK key

The Android manifest uses a Gradle placeholder rather than a literal key. Configure it privately in `android/local.properties`:

```properties
google.maps.api.key=<restricted-android-key>
```

or expose `GOOGLE_MAPS_API_KEY` to the Gradle build environment.

`android/local.properties` is gitignored.

For Android, restrict the provider key by package name and signing-certificate SHA fingerprint, and enable only the APIs required by this application.

## Android release signing

Production release builds use `android/key.properties` and a private keystore. Both are excluded from source control.

Example `android/key.properties` structure:

```properties
storePassword=<private-store-password>
keyPassword=<private-key-password>
keyAlias=<release-key-alias>
storeFile=<absolute-or-project-relative-keystore-path>
```

Do not publish Android builds signed with debug credentials.

## Historical key exposure

Older public commits contained client-side Google Maps and realtime configuration values. The current tree no longer relies on those literals, but deleting them from the current tree does **not** revoke historical exposure.

Provider-side action is still required:

1. rotate or replace historically exposed keys where appropriate;
2. restrict active browser/mobile keys by application identity and API scope;
3. verify obsolete keys are disabled;
4. validate web and mobile maps using the replacement configuration.

## Repository policy

- Commit example configuration only.
- Do not commit `.env`, `.env.*`, `local.properties`, `key.properties`, keystores, credentials, private tokens, or signing secrets.
- Do not report sensitive values in issues, pull requests, documentation, screenshots, or logs.
- Treat browser/mobile API keys as public client credentials and protect them with strict provider restrictions rather than secrecy alone.
- Keep production CORS origins explicit; do not use wildcard browser origins for authenticated APIs.
