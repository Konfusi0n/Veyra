# Veyra v0.1.1-alpha — Imported Authority Snapshot

> [!IMPORTANT]
> **Veyra** is the current product identity. The imported binary and implementation lineage retain the earlier **Root Glass** name. This repository contains a portable Windows package and release documents, not the Go source or build tooling described by the original package.

## Hotfix lineage

v0.1.1-alpha is reported to fix a PowerShell runtime compatibility failure that could abort the first `core.ps1` collection after evidence was gathered.

The reported root cause was PowerShell's array-subexpression binder interacting with `Generic.List` values created through `New-Object` at the final ordered-result boundary. The separate source package reportedly changed collector list construction to direct constructors plus explicit `ToArray()` materialization and added regression gates against the old pattern.

The current public repository does not contain that source or those tests. Post-hotfix Windows-native execution remains pending in the imported verification receipt.

## Product promise

> **Within roughly 30–60 seconds, show what has meaningful authority on this computer, why it matters, what changed, and the exact evidence supporting each conclusion.**

## Documented alpha surfaces

- **Trust Overview** capped at five priority conditions instead of hundreds of undifferentiated rows.
- **Authority Graph** connecting persistence, executable artifacts, identities, process trees, sockets, exclusions, and timeline changes.
- **Investigation Mode** with claim, confidence, compound reasoning, explicit unknowns, source-attributed observations, and a copyable investigation brief.
- **Timeline / Delta** for services, startup entries, scheduled tasks, Defender exclusions, IFEO, AppInit, WMI consumers, and artifact identity changes.
- **Evidence Inventory** for process, service, task, startup, socket, signature, hash, ACL-zone, exclusion, IFEO, AppInit, and WMI evidence.
- **Intent Ledger** that keeps user recognition or rejection separate from collected facts and deterministic claims.
- **Local JSON and Markdown export** of the evidence snapshot.
- **Portable Windows application** under the legacy name `RootGlass.exe`.

These are imported release claims. The current checkout cannot rerun the source-level proof, and the verification receipt still requires live Windows confirmation after the hotfix.

## Trust model

The documented v0.1 boundary is aggressively read-only.

Collectors establish observations. Deterministic rules correlate observations into claims. Unknowns remain explicit. User intent is stored separately. No model declares compromise, authorizes mutation, or silently changes the host.

The alpha is not intended to stop processes, change services or tasks, modify the registry, remove exclusions, delete or quarantine files, install drivers, upload evidence, or call a reputation service.

Read [`SECURITY.md`](SECURITY.md) for the declared boundary and its current proof limitations.

## Run the imported portable package

1. Download or clone the repository.
2. Compute the binary hash yourself:

   ```powershell
   Get-FileHash .\RootGlass.exe -Algorithm SHA256
   ```

3. Read the artifact-identity warning in [`README.md`](README.md) and [`VERIFICATION.md`](VERIFICATION.md).
4. Launch with `Veyra.cmd`.
5. Use `Veyra.cmd admin` for broader read visibility after approving UAC.

The binary is not Authenticode-signed, so Windows SmartScreen may warn.

## Known alpha limitations

- The public checkout is not source-complete and cannot reproduce the binary.
- `CHECKSUMS.txt` and `RELEASE_MANIFEST.json` disagree with the imported `VERIFICATION.md` receipt about binary identity.
- Actual Windows collection quality depends on token elevation and OS access controls.
- A live-host snapshot cannot rule out firmware, kernel-memory-only, protected-process, offline, or raced evidence.
- No finding means only that the active rule pack did not compile a material condition from accessible evidence.
- The alpha does not inspect packet contents or establish remote endpoint ownership.
- Remediation is intentionally absent until typed actions, rollback, receipts, and reboot verification exist.

## Highest-leverage next proof

Import the complete source, reconcile one rebuilt artifact across checksum, manifest, receipt, and exact commit, then run the collector hotfix on Windows. New collectors and visual expansion come after that release-integrity gate.

See [`ROADMAP.md`](ROADMAP.md).
