<?php

$allowedOrigins = array_values(array_filter(array_map(
    static fn (string $origin): string => trim($origin),
    explode(',', (string) env('CORS_ALLOWED_ORIGINS', 'http://localhost:8080,http://localhost:5173'))
)));

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],

    'allowed_methods' => ['*'],

    'allowed_origins' => $allowedOrigins,

    // Allow arbitrary localhost ports only for local development. Production
    // clients must be explicitly configured through CORS_ALLOWED_ORIGINS.
    'allowed_origins_patterns' => env('APP_ENV', 'production') === 'local' ? [
        '/^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/',
    ] : [],

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => (int) env('CORS_MAX_AGE', 600),

    'supports_credentials' => (bool) env('CORS_SUPPORTS_CREDENTIALS', false),
];
