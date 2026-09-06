# Security Policy

## Reporting a vulnerability

Please report suspected vulnerabilities privately to **majdbayer77@gmail.com**.

Do not open a public issue containing live credentials, access tokens, private keys, personal data, exploitable authorization details, or production infrastructure secrets.

Include the affected component, reproducible steps, impact, authentication/role context, and sanitized evidence when possible.

## Priority areas

High-priority reports include authentication or role-bypass issues, reservation or passenger-data exposure, driver/fleet authorization failures, unsafe location handling, injection, secret leakage, mobile/client API-key misuse, and vulnerabilities affecting real-time or production deployment paths.

## Secrets and client keys

Server credentials belong in environment configuration or provider/GitHub secret stores and must not be committed.

Mobile/web client keys must be restricted at their providers by package/bundle identifier, origin, API scope, and quota where supported.

If a key or credential has ever appeared in Git history, rotate/revoke it at the provider. Removing the literal from the current source tree does not invalidate historical exposure.

## Supported code

Security remediation targets the current default branch and maintained application paths. Historical revisions are not supported production baselines.
