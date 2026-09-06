class AppConfig {
  AppConfig._();

  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
  );

  static String requireGoogleMapsApiKey() {
    if (googleMapsApiKey.isEmpty) {
      throw StateError(
        'GOOGLE_MAPS_API_KEY is required. Provide it with '
        '--dart-define=GOOGLE_MAPS_API_KEY=<restricted-client-key>.',
      );
    }

    return googleMapsApiKey;
  }
}
