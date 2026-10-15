---
title: IdentityCommand.DiscoveryMgmt
subtitle: PowerShell for Idira Privilege Cloud Discovery
hide_hero: true
---

<div class="has-text-centered mb-6">
  <img src="{{ '/DiscoveryMgmt/media/images/IdentityCommand.DiscoveryMgmt.png' | relative_url }}" alt="IdentityCommand.DiscoveryMgmt" width="471">
</div>

**IdentityCommand.DiscoveryMgmt** is a PowerShell module that provides a set of easy-to-use commands, allowing you to interact with the API for **Idira Privilege Cloud Discovery** (scan definitions, scan resources, scan instances, remediation rule sets, and discovered accounts) from within the PowerShell environment.

It builds on [IdentityCommand]({{ '/' | relative_url }}) for authentication - see [Getting Started]({{ '/DiscoveryMgmt/getting-started/' | relative_url }}) to install and connect, and the [command reference]({{ '/DiscoveryMgmt/commands/' | relative_url }}) for every command.

## Background

Idira's PrivilegeCloud Discovery feature manages scans (scan definitions, scan resources, scan instances) on its own SaaS host:

- `https://<subdomain>.discoverymgmt.cyberark.cloud`

These functions were originally developed in [psPAS](https://github.com/pspete/psPAS), but as this is a
SaaS-only capability with its own host, separate from psPAS's PVWA/ISPSS-oriented session, they have been
migrated into this standalone module - following the same pattern as
[IdentityCommand.DPA](https://github.com/pspete/IdentityCommand.DPA).

[psPAS](https://github.com/pspete/psPAS) covers the discovered accounts and remediation rule sets, which are served by Privilege Cloud.
