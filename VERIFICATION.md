# Root Glass v0.1.1-alpha Verification Receipt

## Release identity

- Target: Windows 10/11 x64
- Mode: Windows GUI, read-only
- Runtime: self-contained Go executable
- File: `dist/RootGlass.exe`
- Size: 6,476,288 bytes
- SHA-256: `DB12821FAF628B0AFECEABADE9145A84DC9AF1A5573CD24CA96761BB23644A44`

## Hotfix reproduced from live Windows evidence

The v0.1.0-alpha core collector failed during final result assembly with:

`Argument types do not match`

The failure occurred at the `[ordered]` result boundary because the collector created `System.Collections.Generic.List[object]` via `New-Object` and later wrapped that value in PowerShell's array-subexpression operator (`@($list)`). This is a known PowerShell binder failure pattern.

v0.1.1-alpha removes that pattern from every embedded collector:

- Generic lists are constructed with `[System.Collections.Generic.List[T]]::new()`;
- JSON boundaries materialize them explicitly with `.ToArray()`;
- the same correction covers core limitations, startup items, Defender exclusions, IFEO, AppInit, WMI, artifact enrichment, and ACL principals;
- Go tests reject the legacy pattern;
- `tools\Verify-PowerShell.ps1` rejects `New-Object ... Generic.List[...]` in collector source.

## Verified in this build environment

- `gofmt` clean
- `go test -count=1 ./...` passed
- `go vet ./...` passed
- PowerShell compatibility regression test passed at source level
- read-only collector policy tests passed
- Windows x64 cross-build passed
- PE inspection confirmed PE32+ x86-64 Windows GUI executable
- no new mutation, download, upload, or cloud authority was introduced by the hotfix

## Windows-native gate included but not executable here

`Build.cmd` and `Test.cmd` invoke `tools\Verify-PowerShell.ps1`, which uses the native PowerShell AST parser, rejects forbidden mutation/download command nodes, and now rejects the Generic.List construction pattern responsible for the v0.1.0 failure.

PowerShell is not installed in this Linux packaging environment, so the native AST/runtime step must execute on Windows.

## Required live proof

The first v0.1.1-alpha Windows run should verify:

1. `core.ps1` completes and returns JSON rather than failing at result assembly;
2. persistence collection completes without the same list-materialization failure;
3. artifact enrichment completes without the same failure;
4. the Trust Overview renders from real Windows evidence;
5. elevated read-only mode increases visibility without enabling mutation.

Cross-build proof is not equivalent to live Windows runtime proof.
