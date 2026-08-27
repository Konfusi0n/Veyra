# Veyra Roadmap

> **One non-obvious authority chain, explained with independently inspectable evidence in under sixty seconds.**

That is Veyra's smallest irreversible proof. The roadmap is ordered around making that outcome trustworthy before making it broad.

## Proof vocabulary

Veyra does not collapse implementation, testing, publication, and live behavior into “done.”

| State | Establishes | Does not establish |
|---|---|---|
| **Specified** | A contract or design exists. | Code exists. |
| **Implemented** | Code exists for the behavior. | Tests pass. |
| **Locally validated** | A named gate passed against a named subject. | Hosted CI or Windows behavior passed. |
| **Exact-head CI verified** | Hosted CI exercised the exact commit. | A release was built or run by a user. |
| **Released** | A versioned artifact is bound to source and receipts. | It serves or behaves correctly on a live Windows machine. |
| **Windows-live verified** | A named Windows host produced the expected bounded evidence. | Universal correctness or absence of compromise. |

## Gate 0 — Make the alpha independently provable

This gate outranks visual expansion and new collectors because the current public repository contains a prebuilt alpha but not its source.

### 0.1 Source and identity

- Import the complete Go source tree described by the alpha documentation.
- Add `go.mod`, collector scripts, embedded interface, build/test tooling, and `AGENTS.md`.
- Preserve the v0.1 read-only policy as an executable test.
- Rebrand source-owned product strings from Root Glass to Veyra.
- Migrate local storage and environment-variable names without orphaning earlier snapshots.
- Retain an explicit compatibility path for `RootGlass.exe` and `%LOCALAPPDATA%\RootGlass\` data.

**Proof:** a clean checkout at an exact commit can build the same declared Windows artifact.

### 0.2 Artifact integrity

- Preserve the achieved exact-head package-coherence gate for hash, manifest, byte size, PE target, unsigned status, and launcher identity.
- Replace the historical mismatched `VERIFICATION.md` receipt with a new receipt for one rebuilt binary.
- Bind the binary hash to the exact source commit, Go version, build flags, and rule-pack identity.
- Publish a release rather than treating a repository blob as the release channel.
- Add Authenticode signing when a protected signing path is available.

**Proof:** one artifact, one hash, one exact source subject, one immutable release receipt.

### 0.3 Exact-head Windows CI

- Run Go formatting, unit tests, vetting, and deterministic engine tests.
- Parse every embedded PowerShell collector with the native PowerShell AST.
- Enforce the forbidden-mutation and forbidden-download policy.
- Build and inspect the Windows x64 GUI target.
- Exercise demo mode without external providers.
- Preserve release artifacts and checksums from the exact tested commit.

**Proof:** hosted checks bind to the same commit used for the candidate release.

### 0.4 Windows-live hotfix proof

- Confirm `core.ps1` completes without the PowerShell `Generic.List` binder failure.
- Confirm persistence and artifact enrichment collectors complete.
- Confirm Trust Overview renders from real Windows evidence.
- Compare standard-user and elevated read-only visibility.
- Confirm the loopback UI, random API token, Origin/Host validation, and retirement behavior.
- Capture limitations instead of treating missing protected evidence as clean state.

**Proof:** a Windows-native receipt tied to the exact binary and source commit.

---

## v0.2 — Authority Timeline

Move from “what has authority?” to “what changed about who controls this machine?”

- First-seen and last-seen identity for services, tasks, startup entries, exclusions, and executable artifacts.
- Material authority deltas instead of raw row churn.
- Correlation with available installation records and Windows event history.
- Explicit provenance confidence: observed, corroborated, inferred, or unknown.
- Baseline comparison that never treats an old snapshot as automatically clean.

**Proof:** install one bounded test fixture, rescan, and identify its complete authority delta without inventing installer provenance.

---

## v0.3 — Investigation Recursion

Turn a selected object into an explorable causal investigation.

- What created it?
- What launches it?
- What does it launch?
- Which identities can modify it?
- Which controls inspect or ignore it?
- Where does it communicate?
- Which facts are inaccessible or unresolved?

Recursion must be bounded by depth, entity count, time, and collector budget. Cycles and duplicate entities should collapse deterministically rather than becoming a graph hairball.

**Proof:** start from one suspicious executable and produce a bounded, copyable investigation tree with evidence on every edge.

---

## v0.4 — Evidence Packs

Make an investigation portable without making private machine evidence ambient.

- Versioned evidence-pack schema.
- Exact snapshot, rule-pack, collector, and application identity.
- Privacy review and field-level redaction before export.
- Content hashes and tamper-evident manifest.
- Human-readable summary plus machine-readable observations and claims.
- Optional external reputation observations remain separate from local evidence.

**Proof:** export, redact, transfer, and independently validate a pack without access to the original host.

---

## v0.5 — Bounded Remediation

Mutation is admitted only after observation, explanation, evidence preservation, and explicit authorization are strong enough to support it.

Every action requires:

1. typed action contract;
2. exact target identity;
3. fresh preconditions;
4. proposed effects;
5. explicit non-effects;
6. user authorization;
7. least privilege;
8. bounded execution;
9. durable receipt;
10. rollback data;
11. immediate verification;
12. reboot verification when persistence is involved.

There is no generic shell, PowerShell, registry, or “AI fix” authority.

**Proof:** disable and restore one disposable test service through a typed adapter, with receipts and reboot verification, while every out-of-scope target fails closed.

---

## Explicitly deferred

These are expansion traps until the preceding proof exists:

- full antivirus scanning;
- autonomous malware verdicts or deletion;
- packet-content inspection;
- kernel drivers;
- fleet EDR and cloud accounts;
- plugin marketplaces;
- broad reputation-service dependence;
- ambient AI chat;
- generated command execution;
- autonomous remediation.

Veyra should become excellent at **observe → correlate → explain → preserve → verify** before it gains authority to change the machine it inspects.
