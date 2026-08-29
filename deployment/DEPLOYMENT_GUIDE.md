# PCD-SPECTRA deployment guide

PCD-SPECTRA is packaged as a MATLAB Toolbox (`.mltbx`) containing a
function-based app. The public launcher is `runPCDSPECTRA.m`, and the release
version is read from the repository-level `VERSION` file.

## Release configuration

| Field | Value |
| --- | --- |
| Display name | `PCD-SPECTRA` |
| Version | `1.0.0` |
| MATLAB compatibility | R2020a and later, subject to final compatibility testing |
| Platforms | Windows, macOS, Linux, and MATLAB Online |
| Launcher | `runPCDSPECTRA` |
| License | PolyForm Noncommercial License 1.0.0 |

The toolbox identifier in `packagePCDSPECTRA.m` must remain unchanged across
future releases so MATLAB recognizes each release as an update.

## Prepare a release

1. Update `VERSION` to the intended semantic version.
2. Review `README.md`, `doc/GettingStarted.m`, `LICENSE.md`, `CITATION.cff`,
   `deployment/CITATION.md`, and `deployment/THIRD_PARTY_NOTICES.md`.
3. Review the confirmed copyright notice in `NOTICE.md`:
   `Required Notice: Copyright © 2026 Ke Li Lab`. Keep the standard PolyForm
   license text in `LICENSE.md` unchanged.
4. Confirm that the copyright owner permits distribution of the code and all
   included data assets.
5. Confirm the manuscript status and update the provisional citation if final
   publication details are available.
6. Add a square toolbox icon and set `ToolboxImageFile` in
   `deployment/PCDSPECTRAReleaseMetadata.m` when the release icon is ready.

## Validate and package

Open MATLAB with the repository root as the working folder:

```matlab
packagePCDSPECTRA(Package=false)
packagePCDSPECTRA
```

For version `1.0.0`, the package is written to
`deployment/release/PCD-SPECTRA_1.0.0.mltbx`.

## Clean-install test

Test in a MATLAB profile where the source repository is not already on the
MATLAB path:

```matlab
addon = matlab.addons.install("deployment/release/PCD-SPECTRA_1.0.0.mltbx");
runPCDSPECTRA
matlab.addons.uninstall(addon.Identifier(1), addon.Version(1))
```

Confirm that the app title reports the expected version, each tube-voltage
selection works, all included data load, plots render, statistics update, PNG
and MAT exports work, and the Getting Started guide is available.

## Release checklist

- [ ] `VERSION`, app title, package version, filename, and Git tag agree.
- [ ] Manuscript citation and review status are current.
- [ ] Data and third-party redistribution rights are confirmed.
- [ ] PolyForm Noncommercial License 1.0.0 appears at the repository root.
- [ ] Release metadata and distribution notices are reviewed and complete.
- [ ] Clean installation and functional testing pass.
- [ ] File Exchange displays the intended noncommercial license.
