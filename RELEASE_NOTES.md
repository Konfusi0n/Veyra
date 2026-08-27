# Root Glass v0.1.1-alpha — Authority Snapshot

**Root Glass makes the hidden authority structure of a Windows machine visible, understandable, and inspectable.**

**Hotfix:** v0.1.1-alpha fixes a PowerShell runtime compatibility failure that could abort the first `core.ps1` collection after evidence was successfully gathered. The failure was caused by the PowerShell array-subexpression binder interacting with `Generic.List` values created via `New-Object`. All collector list boundaries now use direct constructors plus explicit `ToArray()` materialization, and regression gates prevent the pattern from returning.


This is the first working release, built around one product promise:

> Within roughly 30–60 seconds, show what has meaningful authority on this computer, why it matters, what changed, and the exact evidence supporting each conclusion.

## What ships

- **Trust Overview** capped at five priority conditions instead of hundreds of undifferentiated rows.
- **Authority Graph** connecting persistence, executable artifacts, identities, process trees, sockets, exclusions, and timeline changes.
- **Investigation Mode** with claim, confidence, compound reasoning, explicit unknowns, source-attributed observations, and a copyable Codex brief.
- **Timeline / Delta** for services, startup entries, scheduled tasks, Defender exclusions, IFEO, AppInit, WMI consumers, and artifact identity changes.
- **Evidence Inventory** with searchable raw process, service, task, startup, socket, signature, hash, ACL-zone, exclusion, IFEO, AppInit, and WMI evidence.
- **Intent Ledger** that keeps user recognition/rejection separate from collected facts and deterministic claims.
- **Local export** to versioned JSON and human-readable Markdown.
- **Single-file Windows application** with the entire UI embedded and no Node, Python, .NET, installer, account, or cloud dependency.
- **Codex-ready source tree** with `AGENTS.md`, architecture/security contracts, tests, and `.cmd` launch/build/test/development commands.

## Trust model

v0.1 is aggressively read-only.

Collectors establish observations. Pure Go rules correlate observations into claims. Unknowns remain explicit. User intent is stored separately. No model declares compromise, authorizes mutation, or silently changes the host.

Root Glass does not stop processes, change services or tasks, modify the registry, remove exclusions, delete/quarantine files, install drivers, upload evidence, or call a reputation service.

## Run

Portable package:

1. Extract the ZIP.
2. Double-click `RootGlass.cmd` or `RootGlass.exe`.
3. Use `RootGlass.cmd admin` for fuller protected evidence after approving the UAC prompt.

Source package:

- `RootGlass.cmd dev` — run from source.
- `RootGlass.cmd test` — execute deterministic tests, vetting, the native PowerShell parser/policy gate, and a Windows cross-build.
- `RootGlass.cmd build` — produce `dist\RootGlass.exe` and its SHA-256.

## Known alpha limitations

- The supplied executable is not Authenticode-signed, so SmartScreen may warn.
- Actual Windows collection quality depends on token elevation and OS access controls.
- A live-host snapshot cannot rule out firmware, kernel-memory-only, protected-process, or offline compromise.
- No finding means only that the current rule pack did not compile a material condition from accessible evidence.
- Root Glass does not inspect packet contents or establish remote endpoint ownership.
- Remediation is intentionally absent until typed actions, rollback, receipts, and reboot verification exist.
