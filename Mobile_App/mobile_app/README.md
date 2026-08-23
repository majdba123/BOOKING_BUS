# Transportation ERP Mobile Application

Flutter mobile client for passenger and driver workflows in the Transportation ERP Platform.

## Purpose

The mobile application connects to the Laravel API and contains mobile experiences for transportation users and drivers. The source tree includes trip and reservation flows, mapping/location features, private-trip workflows, profile screens, driver trip operations, and QR/barcode-related tooling.

## Stack

- Flutter / Dart
- Provider
- Dio / HTTP
- Google Maps and geolocation tooling
- Pusher realtime integration
- Camera / QR / barcode tooling
- PDF-related packages

## API Configuration

The API base URL can now be overridden without editing source code:

```bash
flutter run --dart-define=API_BASE_URL=https://example.com/api/
```

For backward compatibility, running without `API_BASE_URL` still uses the original local-development endpoint currently defined as the default in `lib/constants.dart`.

This fallback is intentional during repository professionalization so existing local behavior is not broken before full runtime validation.

## Setup

```bash
flutter pub get
flutter run
```

Platform-specific Google Maps credentials must be configured safely for the target environment. Public client keys should be restricted at the provider level and should not be treated as server-side secrets.

## Validation

Full `flutter analyze`, tests, and platform builds are part of the dedicated runtime-validation phase. This README does not claim successful builds before those checks are executed.

## Platform Documentation

See the repository root `README.md` and `docs/` directory for the full system overview and architecture.