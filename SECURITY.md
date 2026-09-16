# Security Policy

## Supported Versions

JiVaio is currently maintained as a prototype project.

Security support is provided only for the latest version available on the `main` branch.

Older commits, branches, forks, experimental versions, and third-party modifications are not officially supported.

## Reporting a Vulnerability

Please do not disclose suspected security vulnerabilities through public
GitHub issues, pull requests, discussions, or other public channels.

Security vulnerabilities should be reported through GitHub Private
Vulnerability Reporting.

A vulnerability report should include, whenever possible:

- a clear description of the vulnerability;
- the affected component or feature;
- steps required to reproduce the issue;
- the potential security impact;
- relevant logs, screenshots, or technical details;
- any suggested mitigation or fix.

## Responsible Disclosure

Please allow the maintainers reasonable time to investigate and address a reported vulnerability before publishing technical details.

Do not intentionally exploit a vulnerability beyond what is strictly necessary to demonstrate its existence.

Do not attempt to:

* access, modify, or delete data belonging to other users;
* obtain credentials, authentication tokens, or private information;
* perform denial-of-service attacks;
* disrupt Firebase or other external services used by JiVaio;
* perform destructive testing against production services;
* publicly disclose an unresolved vulnerability without first contacting the maintainers.

## Sensitive Information

Credentials and sensitive information must never be committed to the repository.

This includes, but is not limited to:

* private keys;
* service-account credentials;
* passwords;
* authentication tokens;
* signing keys;
* private certificates;
* secrets used by CI/CD systems;
* private user data;
* server-side credentials.

Firebase client configuration values must not be considered a substitute for proper backend authorization.

Access to Firebase resources must be protected through appropriate Firebase Security Rules, authentication controls, API restrictions, and other applicable security mechanisms.

## Third-Party Services

JiVaio relies on third-party services and packages.

Security vulnerabilities affecting Flutter, Firebase, Google Sign-In, Firestore, or other external dependencies should also be reported to the corresponding maintainers when appropriate.

## Scope

This policy applies to the official JiVaio repository maintained by the JiVaio Development Team.

Forks, unofficial deployments, modified versions, and third-party distributions are outside the scope of this security policy.
