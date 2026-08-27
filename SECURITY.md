# Veyra Security Boundary

> [!IMPORTANT]
> This document records the **declared design boundary** of the imported v0.1.1-alpha package. The public repository currently contains the portable binary and release documents, not the Go source used to build it. These properties therefore cannot be independently source-audited from this checkout. A source-bound rebuild, exact-artifact verification, and Windows-native receipt are required to promote the declaration into verified release proof.

**Veyra** is the current product identity. The imported executable and some implementation paths retain the earlier **Root Glass** name.

## Purpose

Veyra inspects a user-owned Windows machine. That makes the application security-sensitive even before it gains remediation capabilities.

The documented v0.1 contract is deliberately read-only.

## Sensitive assets

Veyra can handle potentially sensitive local evidence:

- process command lines;
- usernames and service identities;
- executable paths and hashes;
- scheduled task actions;
- startup configuration;
- network endpoints;
- Defender exclusions;
- persistence registry paths;
- user intent notes.

The imported design states that evidence stays local unless the user manually exports and shares it. Raw exports should be reviewed before publication because command lines, paths, usernames, and endpoints can contain secrets or identifying data.

## Threats considered by the imported design

### Malicious local webpage

A webpage could attempt to call a loopback service. Documented mitigations:

- random per-run API token;
- required custom header;
- loopback Host validation;
- Origin validation;
- no permissive CORS;
- no mutation API.

### Untrusted machine strings

Names, command lines, registry values, task actions, paths, and event text are untrusted data. The imported design states that the UI escapes dynamic HTML and collectors never evaluate collected strings.

### PowerShell collection bridge

The imported alpha reports embedded scripts that use read-only cmdlets and WMI/CIM queries. At runtime, the exact UTF-8 collector bytes are reported to reach the child PowerShell process through a temporary environment variable; a short fixed bridge decodes those bytes and creates the script block. The collector body is not intended to appear in the process command line, and the design does not use `-EncodedCommand` or `ExecutionPolicy Bypass` for collection.

The separate source package reportedly includes a Windows build/test gate that parses collector files with PowerShell's native AST parser and rejects a bounded list of mutation or network-download commands. That source and gate are not present in this repository and cannot be rerun here.

Risks:

- endpoint controls may scrutinize PowerShell process creation or script-block behavior;
- a compromised PowerShell runtime can falsify evidence;
- a hostile live process can race or alter observed state;
- current-user visibility can be incomplete;
- an unsigned, source-unbound binary cannot independently establish its own read-only behavior.

Documented mitigations:

- no downloaded collector script;
- no remote interface content;
- no execution of observed command lines;
- collector errors and missing process paths become explicit limitations;
- evidence is corroborated across independent Windows surfaces;
- future native collectors can replace high-value PowerShell paths without changing the evidence contract.

### Application lifetime

The imported design states that Veyra installs no service, task, Run entry, or other persistence. The browser UI sends a local heartbeat while open; once the visible UI disappears and no scan is active, the application is intended to retire its loopback server rather than remain invisible in the background.

This behavior remains part of the required Windows-native proof.

### Local snapshot confidentiality

Snapshots are reported to use user-only file modes where supported and to live beneath local application data. Windows ACL inheritance still controls the final effective permissions.

The legacy alpha currently uses `%LOCALAPPDATA%\RootGlass\`. A future Veyra rename must migrate that state without orphaning snapshots or silently weakening ACLs.

### Browser application window

The UI is reported to be served from loopback and displayed through an installed browser app window. It is not remotely hosted and is designed to load no external resources.

### Binary trust

The supplied alpha executable is not Authenticode-signed. Windows SmartScreen may warn.

Compute its SHA-256 locally before evaluation:

```powershell
Get-FileHash .\RootGlass.exe -Algorithm SHA256
```

Exact-head Windows CI independently verifies that the tracked binary matches `CHECKSUMS.txt`, `RELEASE_MANIFEST.json`, the declared byte size, the AMD64 PE32+ Windows GUI target, and unsigned Authenticode status. The imported `VERIFICATION.md` receipt names a different hash and is preserved as historical evidence for another or earlier artifact. Because source is absent and collector execution is not part of that package gate, treat the alpha as package-coherent but source- and runtime-provenance-limited.

## Declared non-capabilities

The v0.1 design declares no code path to:

- terminate processes;
- change service or task state;
- modify the registry;
- delete or quarantine files;
- change Defender or firewall settings;
- download or upload files;
- contact reputation services;
- inspect packet payloads;
- install a driver;
- persist itself.

Because source is not present, this list is a release claim—not source-auditable proof from the current checkout.

## Future remediation admission gate

Mutation must not be added as a generic command executor.

Every future action requires:

1. typed action contract;
2. exact target identity;
3. fresh preconditions;
4. proposed effects;
5. explicit non-effects;
6. user authorization;
7. least privilege;
8. bounded execution;
9. mutation receipt;
10. rollback data;
11. immediate verification;
12. reboot verification when persistence is involved.

The model may explain a proposed action. It may not authorize it.

## Reporting

Do not publish raw machine exports in a public issue. Redact usernames, command lines, paths, endpoints, tokens, and other private evidence. Until a private reporting channel is published, provide only the smallest reproducible, sanitized description necessary to establish the defect.
