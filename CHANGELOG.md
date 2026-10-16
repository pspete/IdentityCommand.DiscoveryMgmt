# Change Log

All notable changes to this project will be documented in this file.

## Unreleased

- N/A

## [0.1.0] - 2026-10-16

### Added

- Initial release. Functions migrated from `psPAS` for CyberArk PrivilegeCloud Discovery (Scan Definitions, Scan
  Resources, Scan Instances), reworked to authenticate via
  `IdentityCommand` instead of a standalone `psPAS` session.
- Commands find the Discovery Management service url from the `IdentityCommand` session on first
  use, so no connection step is needed after `New-IDSession` or `New-IDPlatformToken`. Commands follow a later
  `New-IDSession` or `New-IDPlatformToken`, and fail after `Close-IDSession` until you authenticate again.

