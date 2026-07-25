# IdentityCommand.DiscoveryMgmt

**IdentityCommand.DiscoveryMgmt** is a PowerShell module that provides a set of easy-to-use commands, allowing you to interact with the API for **CyberArk Privilege Cloud Discovery** (scan definitions, scan resources, scan instances, remediation rule sets, and discovered accounts) from within the PowerShell environment.

## Background

CyberArk's PrivilegeCloud Discovery feature is served across two SaaS hosts:

- `https://<subdomain>.discoverymgmt.cyberark.cloud` - scan definitions, scan resources, scan instances
- `https://<subdomain>.privilegecloud.cyberark.cloud` - discovered accounts, remediation rule sets

These functions were originally developed in [psPAS](https://github.com/pspete/psPAS), but as this is a
SaaS-only capability with its own hosts, separate from psPAS's PVWA/ISPSS-oriented session, they have been
migrated into this standalone module - following the same pattern as
[IdentityCommand.DPA](https://github.com/pspete/IdentityCommand.DPA).

## Using the Module

The module requires authentication to the CyberArk Identity platform using the `IdentityCommand` module.

The `IdentityCommand` module must be installed and available in order to use `IdentityCommand.DiscoveryMgmt`.

### Authentication

After authentication to an Identity tenant using the `IdentityCommand` module, the `Connect-DMTenant` command is used to initialise the session for module operations against the Discovery services:

```powershell
Connect-DMTenant -subdomain sometenant
```

This targets `https://sometenant.discoverymgmt.cyberark.cloud` and `https://sometenant.privilegecloud.cyberark.cloud` for subsequent module operations.

## List Of Commands

| Function                                  | Description                                                          |
|--------------------------------------------|------------------------------------------------------------------------|
| `Connect-DMTenant`                        | Obtains a Bearer token from an authenticated `IdentityCommand` session |
| `Add-DMDiscoveryScanDefinition`           | Adds a new discovery scan definition                                   |
| `Get-DMDiscoveryScanDefinition`           | Get scan definitions and their details                                 |
| `Remove-DMDiscoveryScanDefinition`        | Delete a scan definition                                                |
| `Set-DMDiscoveryScanDefinition`           | Updates an existing discovery scan definition                           |
| `Add-DMDiscoveryScanResource`             | Defines a new discovery scan resource                                   |
| `Get-DMDiscoveryScanResource`             | Get scan resource details                                               |
| `New-DMDiscoveryScanResourceCloudObject`  | Creates a cloud infrastructure scan resource content object             |
| `New-DMDiscoveryScanResourceMachineObject`| Creates a machine list entry object for a scan resource                 |
| `Start-DMDiscoveryScan`                   | Starts a discovery scan                                                 |
| `Get-DMDiscoveryScan`                     | Get scan instance details                                               |
| `Get-DMDiscoveryScanLog`                  | Get scan instance logs URL                                              |
| `Get-DMRemediationRuleSet`                | Get information about remediation rule sets                             |
| `Remove-DMRemediationRuleSet`             | Delete a remediation rule set                                           |
| `Add-DMDiscoveredLocalAccount`            | Add a discovered local endpoint account to the Discovered Accounts list |
| `Get-DMDiscoveredLocalAccount`            | List discovered unmanaged local Windows, macOS, and Linux accounts      |
| `Remove-DMDiscoveredLocalAccount`         | Delete a discovered local account                                       |
| `Clear-DMDiscoveredLocalAccount`          | Deletes all discovered local endpoint accounts                          |
| `Test-DMDiscoveredLocalAccount`           | Check discovered account existence                                      |
| `Get-DMDiscoveredLocalAccountActivity`    | Get discovery rule activities of a discovered account                   |
| `Publish-DMDiscoveredLocalAccount`        | Onboard a discovered local account                                      |
| `New-DMDiscoveredAccountObject`           | Creates a discovered account object for use with `Test-DMDiscoveredLocalAccount` |
| `Get-DMDiscoveredAccountTypeMap`          | Returns reference data describing identifiers expected per account Type/SubType |

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
