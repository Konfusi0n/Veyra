VEYRA v0.1.1-alpha — PORTABLE EVALUATION PACKAGE
=================================================

PRODUCT IDENTITY
  Veyra is the current product and repository name.
  The imported alpha binary still uses the legacy Root Glass name internally.

FASTEST START
  Double-click Veyra.cmd.

FULLER PROTECTED EVIDENCE
  Run: Veyra.cmd admin
  Approve the Windows UAC prompt. Elevation increases visibility;
  the documented v0.1 boundary remains read-only.

WHAT IT DOES
  Maps services, processes, tasks, startup entries, sockets, Defender
  exclusions, IFEO, AppInit, WMI persistence, signatures, hashes, and
  authority changes into evidence-backed causal chains.

LOCAL DATA
  The legacy alpha currently writes beneath:
  %LOCALAPPDATA%\RootGlass\

IMPORTANT PROOF BOUNDARY
  - This repository contains the portable binary and documents, not source.
  - The alpha binary is not Authenticode-signed. SmartScreen may warn.
  - CHECKSUMS.txt and RELEASE_MANIFEST.json agree with one another.
  - The imported VERIFICATION.md receipt names a different binary hash.
  - Windows-native post-hotfix proof is still pending in that receipt.

  Compute the binary hash yourself before evaluation:
    certutil -hashfile RootGlass.exe SHA256

  Read README.md, SECURITY.md, and VERIFICATION.md before elevated use.

HOTFIX LINEAGE
  v0.1.1-alpha is reported to fix the PowerShell collector error:
    Argument types do not match
  that could abort v0.1.0-alpha during core evidence assembly.

SOURCE DEVELOPMENT
  Blocked in this repository until the separate Go source package is imported.
