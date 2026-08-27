ROOT GLASS v0.1.1-alpha HOTFIX
================================

FASTEST START
  Double-click RootGlass.cmd or RootGlass.exe.

HOTFIX
  Fixes the PowerShell collector error:
    Argument types do not match
  that could abort v0.1.0-alpha during core Windows evidence assembly.

FULLER PROTECTED EVIDENCE
  Run: RootGlass.cmd admin
  Approve the Windows UAC prompt. Elevation increases visibility; the app remains read-only.

WHAT IT DOES
  Maps services, processes, tasks, startup entries, sockets, Defender exclusions,
  IFEO, AppInit, WMI persistence, executable signatures/hashes, and authority changes
  into evidence-backed causal chains.

LOCAL DATA
  %LOCALAPPDATA%\RootGlass\

IMPORTANT
  This alpha binary is not Authenticode-signed. Windows SmartScreen may warn.
  Verify the SHA-256 in CHECKSUMS.txt before running.

DEVELOPMENT
  Use the separate source package for RootGlass.cmd dev/build/test and Codex work.
