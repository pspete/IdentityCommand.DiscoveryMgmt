---
title: Getting Started
subtitle: Install IdentityCommand.DiscoveryMgmt and connect to Privilege Cloud Discovery
---

## Prerequisites

- Requires Powershell Core (recommended), or Windows PowerShell (version 5.1)
- An Idira Identity tenant with the PrivilegeCloud Discovery service enabled
- An Account to Access Idira Identity
- The `IdentityCommand` module.

## Install Options

Install from the PowerShell Gallery:

```powershell
Install-Module -Name IdentityCommand.DiscoveryMgmt -Scope CurrentUser
```

Or download the [latest release](https://github.com/pspete/IdentityCommand.DiscoveryMgmt/releases), unblock and extract the archive, and copy the `IdentityCommand.DiscoveryMgmt` folder into a path listed in `$env:PSModulePath`.

## Authentication

The module requires authentication to the Idira Identity platform using the `IdentityCommand` module.

The `IdentityCommand` module must be installed and available in order to use `IdentityCommand.DiscoveryMgmt`.

After authentication to an Identity tenant using the `IdentityCommand` module, the `Connect-DMTenant` command is used to initialise the session for module operations against the Discovery services:

```powershell
Connect-DMTenant -subdomain sometenant
```

This targets `https://sometenant.discoverymgmt.cyberark.cloud` and `https://sometenant.privilegecloud.cyberark.cloud` for subsequent module operations.
