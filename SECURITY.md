# Root Glass Security Boundary

## Purpose

Root Glass inspects a user-owned Windows machine. That makes the application security-sensitive even before it gains remediation capabilities.

v0.1 is deliberately read-only.

## Assets

Root Glass handles potentially sensitive local evidence:

- process command lines;
- usernames and service identities;
- executable paths and hashes;
- scheduled task actions;
- startup configuration;
- network endpoints;
- Defender exclusions;
- persistence registry paths;
- user intent notes.

All evidence stays local unless the user manually exports and shares it.

## Threats considered

### Malicious local webpage

A webpage could attempt to call a loopback service. Mitigations:

- random per-run API token;
- required custom header;
- loopback Host validation;
- Origin validation;
- no permissive CORS;
- no mutation API.

### Untrusted machine strings

Names, command lines, registry values, task actions, paths, and event text are untrusted data. The UI escapes all dynamic HTML. Collectors never evaluate collected strings.

### PowerShell collection bridge

The embedded scripts use read-only cmdlets and WMI/CIM queries. They are compiled into the Root Glass binary. At runtime the exact UTF-8 collector bytes are supplied only to the child PowerShell process through a temporary environment variable; a short fixed bridge decodes those bytes and creates the script block. The collector body does not appear in the process command line and Root Glass does not use `-EncodedCommand` or `ExecutionPolicy Bypass` for collection.

The Windows build/test gate parses all collector files with PowerShell's native AST parser and rejects a bounded list of mutation or network-download commands before producing a release binary.

Risks:

- endpoint controls may still scrutinize PowerShell process creation or script-block behavior;
- a compromised PowerShell runtime can falsify evidence;
- a hostile live process can race or alter observed state;
- current-user visibility can be incomplete.

Mitigations:

- no downloaded script;
- no remote content;
- collector source is AST-parse gated and mutation-command gated during Windows builds;
- the collector body is absent from the PowerShell command line;
- no execution of observed command lines;
- collector errors and missing process paths become explicit limitations;
- evidence is corroborated across independent Windows surfaces;
- future native collectors can replace high-value PowerShell paths without changing the evidence contract.

### Application lifetime

Root Glass installs no service, task, Run entry, or other persistence. The browser UI sends a local heartbeat while it is open. Once the visible UI disappears and no scan is active, the application retires its loopback server instead of remaining as an invisible background process.

### Local snapshot confidentiality

Snapshots are created with user-only file modes where supported and stored beneath local application data. Windows ACL inheritance still controls the final effective permissions.

Snapshots may contain secrets embedded in command lines. Do not publish raw exports without review.

### Browser application window

The UI is served from loopback and displayed through an installed browser app window. It is not remotely hosted and loads no external resources.

### Binary trust

The supplied alpha executable is not Authenticode-signed. Verify it using the release SHA-256 or build it from source. A future public release should use a protected code-signing key and reproducible release receipts.

## Explicit non-capabilities

v0.1 has no code path to:

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

## Future remediation admission gate

Mutation must not be added as a generic command executor.

Every future action requires:

1. typed action contract;
2. exact target identity;
3. preconditions;
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
