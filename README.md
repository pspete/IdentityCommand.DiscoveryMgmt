![Logo][Logo]

[Logo]: /docs/media/images/IdentityCommand.DiscoveryMgmt.png

# IdentityCommand.DiscoveryMgmt

**IdentityCommand.DiscoveryMgmt** is a PowerShell module that provides a set of easy-to-use commands, allowing you to interact with the API for **CyberArk Privilege Cloud Discovery** (scan definitions, scan resources, scan instances, remediation rule sets, and discovered accounts) from within the PowerShell environment.

| Main Branch              | CodeFactor                 | Coverage                     | PowerShell Gallery        | License                      |
| ------------------------ | -------------------------- | ---------------------------- | ------------------------- | ---------------------------- |
| [![build][]][build-site] | [![codefactor][]][cf-site] | [![codecov][]][codecov-link] | [![psgallery][]][ps-site] | [![license][]][license-link] |

[build]: https://github.com/pspete/IdentityCommand.DiscoveryMgmt/actions/workflows/ci.yml/badge.svg?branch=main&event=push
[build-site]: https://github.com/pspete/IdentityCommand.DiscoveryMgmt/actions/workflows/ci.yml?query=branch%3Amain
[psgallery]: https://img.shields.io/powershellgallery/v/IdentityCommand.DiscoveryMgmt.svg
[ps-site]: https://www.powershellgallery.com/packages/IdentityCommand.DiscoveryMgmt
[downloads]: https://img.shields.io/powershellgallery/dt/IdentityCommand.DiscoveryMgmt.svg?color=blue
[cf-site]: https://www.codefactor.io/repository/github/pspete/IdentityCommand.DiscoveryMgmt
[codefactor]: https://www.codefactor.io/repository/github/pspete/IdentityCommand.DiscoveryMgmt/badge
[codecov]: https://codecov.io/gh/pspete/IdentityCommand.DiscoveryMgmt/branch/main/graph/badge.svg
[codecov-link]: https://codecov.io/gh/pspete/IdentityCommand.DiscoveryMgmt
[license]: https://img.shields.io/github/license/pspete/IdentityCommand.DiscoveryMgmt.svg
[license-link]: https://github.com/pspete/IdentityCommand.DiscoveryMgmt/blob/main/LICENSE

## Background

CyberArk's PrivilegeCloud Discovery feature manages scans (scan definitions, scan resources, scan instances) on its own SaaS host:

- `https://<subdomain>.discoverymgmt.cyberark.cloud`

These functions were originally developed in [psPAS](https://github.com/pspete/psPAS), but as this is a
SaaS-only capability with its own host, separate from psPAS's PVWA/ISPSS-oriented session, they have been
migrated into this standalone module - following the same pattern as
[IdentityCommand.SIA](https://github.com/pspete/IdentityCommand.SIA) and the other IdentityCommand.\* companion modules.

[psPAS](https://github.com/pspete/psPAS) covers the discovered accounts and remediation rule sets, which are served by Privilege Cloud.

## Using the Module

The module requires authentication to the CyberArk Identity platform using the `IdentityCommand` module.

The `IdentityCommand` module must be installed and available in order to use `IdentityCommand.DiscoveryMgmt`.

### Authentication

Authenticate with the `IdentityCommand` module, using `New-IDSession` (interactive user, including any MFA challenges) or `New-IDPlatformToken` (non-interactive service user). Commands find the Discovery Management and Privilege Cloud service urls from the Identity session on first use - no separate connection step is needed:

```powershell
# Interactive user authentication
New-IDSession -subdomain sometenant -Credential $Credential

# Or non-interactive service user authentication via an OAuth platform token
New-IDPlatformToken -subdomain sometenant -Credential $ServiceUserCredential

Get-DMDiscoveryScanDefinition
```

Commands follow the current Identity session: a later `New-IDSession` or `New-IDPlatformToken` is used by the next command, and after `Close-IDSession` commands fail until you authenticate again.

## List Of Commands

| Function                                   | Description                                                 |
| ------------------------------------------ | ----------------------------------------------------------- |
| `Add-DMDiscoveryScanDefinition`            | Adds a new discovery scan definition                        |
| `Get-DMDiscoveryScanDefinition`            | Get scan definitions and their details                      |
| `Remove-DMDiscoveryScanDefinition`         | Delete a scan definition                                    |
| `Set-DMDiscoveryScanDefinition`            | Updates an existing discovery scan definition               |
| `Add-DMDiscoveryScanResource`              | Defines a new discovery scan resource                       |
| `Get-DMDiscoveryScanResource`              | Get scan resource details                                   |
| `New-DMDiscoveryScanResourceCloudObject`   | Creates a cloud infrastructure scan resource content object |
| `New-DMDiscoveryScanResourceMachineObject` | Creates a machine list entry object for a scan resource     |
| `Start-DMDiscoveryScan`                    | Starts a discovery scan                                     |
| `Get-DMDiscoveryScan`                      | Get scan instance details                                   |
| `Get-DMDiscoveryScanLog`                   | Get scan instance logs URL                                  |

## Installation

### Prerequisites

- Requires Powershell Core (recommended), or Windows PowerShell (version 5.1)
- A CyberArk Identity tenant with the PrivilegeCloud Discovery service enabled
- An Account to Access CyberArk Identity

### Install Options

Users can install IdentityCommand.DiscoveryMgmt from GitHub or the PowerShell Gallery.

#### Option 1: Install from PowerShell Gallery

```powershell
Install-Module -Name IdentityCommand.DiscoveryMgmt -Scope CurrentUser
```

#### Option 2: Manual Install

The module files can be manually copied to one of your PowerShell module directories.

Use the following command to get the paths to your local PowerShell module folders:

```powershell

$env:PSModulePath.split(';')

```

The module files must be placed in one of the listed directories, in a folder called `IdentityCommand.DiscoveryMgmt`.

More: [about_PSModulePath](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath)

#### Verification

Validate Install:

```powershell

Get-Module -ListAvailable IdentityCommand.DiscoveryMgmt

```

Import the module:

```powershell

Import-Module IdentityCommand.DiscoveryMgmt

```

List Module Commands:

```powershell

Get-Command -Module IdentityCommand.DiscoveryMgmt

```

## Changelog

All notable changes to this project will be documented in the [Changelog](CHANGELOG.md)

## Author

- **Pete Maan** - [pspete](https://github.com/pspete)

## License

This project is [licensed under the MIT License](LICENSE).

## Contributing

Any and all contributions to this project are appreciated.

See the [CONTRIBUTING.md](CONTRIBUTING.md) for a few more details.

## Support

_IdentityCommand.DiscoveryMgmt_ is neither developed nor supported by CyberArk; any official support channels offered by the vendor are not appropriate for seeking help with the _IdentityCommand.DiscoveryMgmt_ module.

Help and support should be sought by [opening an issue][new-issue].

[new-issue]: https://github.com/pspete/IdentityCommand.DiscoveryMgmt/issues/new
