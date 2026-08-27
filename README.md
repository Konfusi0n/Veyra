<p align="center">
  <img src="internal/webui/static/logo.svg" width="116" alt="Root Glass">
</p>

<h1 align="center">ROOT GLASS</h1>

<p align="center"><strong>See what has authority over your machine.</strong></p>

<p align="center">
  Windows-first · local-only · read-only · evidence-backed · single executable
</p>

---

Root Glass is a glass-box Windows authority inspector. It turns fragmented machine facts—services, processes, scheduled tasks, startup entries, executable trust, filesystem permissions, Defender exclusions, IFEO, AppInit, WMI persistence, and live network sockets—into a small number of inspectable causal chains.

It does **not** call itself an antivirus, declare that a machine is compromised, upload files, or mutate the host in v0.1.

The core question is simpler and more useful:

> **What has authority on this computer, why does it have that authority, what changed, and what evidence supports the conclusion?**

## What v0.1 already does

### Trust Overview

Compresses hundreds of raw rows into at most five priority conditions. A condition is never just “unsigned file.” Root Glass correlates independent facts such as:

```text
AUTOMATIC SERVICE
      ↓ launches
EXECUTABLE
      ↓ executes as
LOCAL SYSTEM
      ↓ spawned
PROCESS TREE
      ↓ opened
EXTERNAL CONNECTION
```

### Authority Graph

Normalizes persistence, executable artifacts, identities, processes, and network endpoints into a causal graph. Every edge names the collector evidence that established it.

### Investigation Mode

Open a condition to see:

- the deterministic claim;
- exact observations;
- why the combined chain matters;
- what remains unknown;
- the highest-leverage next action;
- the evidence source for every observation;
- a copyable investigation brief for Codex or another analyst.

### Timeline / Delta

Stores local snapshots and reports material changes between runs:

- services added, removed, or changed;
- startup entries changed;
- scheduled task authority changed;
- Defender exclusions changed;
- IFEO, AppInit, or WMI persistence changed;
- executable hash or signature state changed.

### Intent Ledger

Machine capability and user permission are separate facts. Each condition can be marked:

- **Recognized** — expected authority;
- **Review** — unresolved;
- **Rejected** — authority the user does not consent to.

The label never erases the underlying evidence.

### Evidence Inventory

Searchable local tables retain the raw facts behind the compressed interface:

- processes and ancestry;
- services and execution identities;
- scheduled tasks and actions;
- startup registrations;
- TCP surfaces and owning PIDs;
- executable paths, hashes, signers, versions, and write zones;
- Defender exclusions;
- IFEO interception;
- enabled AppInit DLL injection;
- WMI permanent consumers.

### Local exports

Exports the complete snapshot as JSON or a human-readable Markdown report. Nothing is sent to a cloud service.

## Run it

### Fastest path

Double-click:

```text
RootGlass.cmd
```

The launcher starts the prebuilt single-file application:

```text
dist\RootGlass.exe
```

Root Glass opens in an Edge or Chrome app window when available, otherwise in the default browser. The executable binds only to a random loopback port and requires a random per-run API token.

### Fuller protected evidence

A normal user token cannot read every protected process path or security setting. To run the same read-only collectors with an administrator token:

```text
RootGlass.cmd admin
```

Windows will display a UAC prompt. Elevation increases visibility; it does not enable remediation.

### Development mode

```text
RootGlass.cmd dev
```

This runs directly from source with the installed Go toolchain.

### Build

```text
RootGlass.cmd build
```

The build gate formats source, parses every embedded PowerShell collector with the native AST parser, enforces a forbidden-mutation command policy, runs tests and vetting, builds a self-contained Windows x64 executable, and prints its SHA-256.

### Test

```text
RootGlass.cmd test
```

## Single-file release architecture

The distributed application is one executable because Go embeds the complete HTML/CSS/JavaScript interface at compile time.

```text
RootGlass.exe
  ├── loopback-only application server
  ├── embedded interface
  ├── deterministic Windows collectors
  ├── artifact enrichment
  ├── correlation / rule engine
  ├── authority graph compiler
  ├── intent ledger
  ├── baseline diff engine
  └── JSON / Markdown exporters
```

There is no Node runtime, Python runtime, .NET runtime, package installation, account, or cloud dependency.

The source tree remains conventional and easy for Codex to extend:

```text
cmd/rootglass/          application entry point
internal/app/           loopback server, lifecycle, and API boundary
internal/collector/     read-only Windows collectors and demo collector
internal/engine/        deterministic authority rules and graph compiler
internal/baseline/      local snapshots and delta engine
internal/intent/        user-intent ledger
internal/model/         versioned evidence contracts
internal/report/        local report / investigation brief generation
internal/webui/         embedded cinematic interface
```

## Deterministic doctrine

Root Glass deliberately keeps four layers separate:

```text
OBSERVATION
A collected machine fact.

CLAIM
A deterministic rule interpreting multiple observations.

UNKNOWN
A boundary the evidence has not resolved.

INTENT
The user's recognition or rejection of that authority.
```

A model may eventually explain or prioritize a structured evidence packet. A model must not silently convert uncertainty into machine truth or authorize host mutation.

## Read-only guarantee in v0.1

The application does not:

- stop or kill processes;
- stop, disable, create, or delete services;
- register or remove scheduled tasks;
- modify startup entries or the registry;
- add or remove Defender exclusions;
- quarantine or delete files;
- add firewall rules;
- upload files, hashes, command lines, or snapshots;
- install tools;
- inspect packet contents;
- load a kernel driver.

It writes only its own local evidence, intent, and log files beneath:

```text
%LOCALAPPDATA%\RootGlass\
```

Set `ROOTGLASS_DATA_DIR` or use `-data-dir` to override that location.

## Important trust caveats

- The included alpha binary is **not Authenticode-signed**. Windows SmartScreen may warn because no commercial code-signing certificate was available for this build.
- Root Glass uses built-in Windows PowerShell as a read-only collection bridge. Collector bodies are compiled into the executable and passed only to the child process through a temporary environment variable; the command line contains a fixed bridge rather than the collector text. Endpoint controls may still scrutinize PowerShell activity.
- Authenticode status requires interpretation. Package-managed WindowsApps executables and catalog-signed Windows components can differ from ordinary embedded signatures.
- A live-host snapshot cannot rule out firmware compromise, kernel-memory-only implants, protected-process injection, offline artifacts, or evidence altered during collection.
- “No finding” means only that the current deterministic rule pack did not compile a material condition from the evidence it could access.

See [SECURITY.md](SECURITY.md) for the complete boundary.

## Highest-yield next slices

The current release intentionally cuts antivirus scanning, deletion, cloud reputation, packet inspection, kernel drivers, EDR fleet management, and autonomous remediation.

The next valuable work is narrower:

1. **Authority Timeline v0.2** — correlate first-seen service/task/executable state with Windows event history and installer provenance.
2. **Investigation Recursion v0.3** — recursively resolve “what created this?”, “what launches it?”, “what does it launch?”, and “what trusts or ignores it?”
3. **Evidence Packs v0.4** — versioned, shareable, privacy-redacted investigation bundles.
4. **Bounded Remediation v0.5** — explicit proposed action, effects, rollback, execution receipt, reboot proof, and no ambient mutation authority.

See [ROADMAP.md](ROADMAP.md).

## Current release identity

```text
Version: 0.1.1-alpha
Target:  Windows 10/11 x64
Mode:    Read-only
Runtime: Self-contained Go executable
```

Build the binary locally before treating any hash in a release note as authoritative.
