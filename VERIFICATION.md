# Veyra v0.1.1-alpha — Imported Root Glass Verification Receipt

> [!CAUTION]
> **This historical receipt is not publication proof for the current repository binary.** It declares SHA-256 `DB12821FAF628B0AFECEABADE9145A84DC9AF1A5573CD24CA96761BB23644A44`. Exact-head Windows CI now independently computes the tracked binary as `ecaaba0591251fb9f769d6e101646a87b5c719997c4f748204ca929bc639e9bf`, matching `CHECKSUMS.txt` and `RELEASE_MANIFEST.json`. The current package identity is therefore coherent; this imported receipt belongs to another or earlier artifact and is preserved as historical evidence rather than silently rewritten. The source used to produce either artifact is not present, so source provenance and live collector behavior remain unresolved.

The receipt below was imported with the original v0.1.1-alpha package. **Root Glass** is the earlier product name; **Veyra** is the current identity.

---

## Original release identity

- Product at build time: Root Glass
- Target: Windows 10/11 x64
- Mode: Windows GUI, read-only
- Runtime: self-contained Go executable
- File in the original source layout: `dist/RootGlass.exe`
- Size: 6,476,288 bytes
- SHA-256 recorded by this receipt: `DB12821FAF628B0AFECEABADE9145A84DC9AF1A5573CD24CA96761BB23644A44`

## Hotfix reproduced from live Windows evidence

The v0.1.0-alpha core collector failed during final result assembly with:

`Argument types do not match`

The failure occurred at the `[ordered]` result boundary because the collector created `System.Collections.Generic.List[object]` via `New-Object` and later wrapped that value in PowerShell's array-subexpression operator (`@($list)`). This is a known PowerShell binder failure pattern.

v0.1.1-alpha reports that it removes that pattern from every embedded collector:

- Generic lists are constructed with `[System.Collections.Generic.List[T]]::new()`;
- JSON boundaries materialize them explicitly with `.ToArray()`;
- the same correction covers core limitations, startup items, Defender exclusions, IFEO, AppInit, WMI, artifact enrichment, and ACL principals;
- Go tests reject the legacy pattern;
- `tools\Verify-PowerShell.ps1` rejects `New-Object ... Generic.List[...]` in collector source.

## Reported as verified in the original build environment

- `gofmt` clean
- `go test -count=1 ./...` passed
- `go vet ./...` passed
- PowerShell compatibility regression test passed at source level
- read-only collector policy tests passed
- Windows x64 cross-build passed
- PE inspection confirmed PE32+ x86-64 Windows GUI executable
- no new mutation, download, upload, or cloud authority was introduced by the hotfix

These claims cannot be rerun from the current public checkout because the source and build tooling are absent.

## Windows-native gate reported but not executed in that environment

The original `Build.cmd` and `Test.cmd` reportedly invoke `tools\Verify-PowerShell.ps1`, which uses the native PowerShell AST parser, rejects forbidden mutation/download command nodes, and rejects the Generic.List construction pattern responsible for the v0.1.0 failure.

PowerShell was not installed in the Linux packaging environment, so the native AST/runtime step remained outside that receipt.

## Required live proof

A new source-bound Veyra release must verify:

1. `core.ps1` completes and returns JSON rather than failing at result assembly;
2. persistence collection completes without the same list-materialization failure;
3. artifact enrichment completes without the same failure;
4. Trust Overview renders from real Windows evidence;
5. elevated read-only mode increases visibility without enabling mutation;
6. the tested binary hash matches the release manifest, checksum file, and signed receipt;
7. the receipt binds all of those facts to one exact source commit.

Cross-build proof is not equivalent to live Windows runtime proof.
