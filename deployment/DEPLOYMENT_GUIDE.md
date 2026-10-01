# PCD-SPECTRA deployment guide

PCD-SPECTRA is a function-based MATLAB app distributed as a GitHub Release
source ZIP. It can also be packaged separately as a MATLAB Toolbox (`.mltbx`). The public launcher is `runPCDSPECTRA.m`, and the release
version is read from the repository-level `VERSION` file.

## Release configuration

| Field | Value |
| --- | --- |
| Display name | `PCD-SPECTRA` |
| Version | `1.0.0` |
| MATLAB compatibility | R2020a and later, subject to final compatibility testing |
| Platforms | Windows, macOS, Linux, and MATLAB Online |
| Launcher | `runPCDSPECTRA` |
| Software authors | Shanli Ding, Linying Zhan, Ke Li |
| Copyright holder | The University of Texas MD Anderson Cancer Center |
| License | PolyForm Noncommercial License 1.0.0 |

The toolbox identifier in `packagePCDSPECTRA.m` must remain unchanged across
future releases so MATLAB recognizes each release as an update.

## Prepare a release

1. Update `VERSION` to the intended semantic version.
2. Review `README.md`, `doc/GettingStarted.m`, `LICENSE.md`, `CITATION.cff`,
   `deployment/CITATION.md`, and `deployment/THIRD_PARTY_NOTICES.md`.
3. Review the confirmed copyright notice in `NOTICE.md`:
   `Required Notice: Copyright © 2026 The University of Texas MD Anderson Cancer Center`. Keep the standard PolyForm
   license terms and mandatory citation requirement in `LICENSE.md` intact.
4. Confirm that the copyright owner permits distribution of the code and all
   included data assets.
5. Confirm the manuscript status and update the provisional citation if final
   publication details are available.
6. Verify the bundled square toolbox icon configured by `ToolboxImageFile`
   in `deployment/PCDSPECTRAReleaseMetadata.m`.

## Publish the source release

Follow `deployment/PUBLIC_FILE_EXCHANGE_PUBLISHING.md` to link the public
repository to File Exchange through GitHub Releases. Source ZIP distribution
requires no bundle build. Only attach a toolbox if it was built from the
final release commit; the existing local bundle predates the October 1, 2026
authorship and copyright updates.

## Optional toolbox validation and packaging

Open MATLAB with the repository root as the working folder:

```matlab
addpath("tests")
verifyPCDSPECTRARelease

% To validate or package without rerunning the full verification suite:
packagePCDSPECTRA(Package=false)
packagePCDSPECTRA
```

For version `1.0.0`, the package is written to
`deployment/release/PCD-SPECTRA_1.0.0.mltbx`.

## Public repository contents

The private peer-review packaging script and templates are ignored by Git.
Production packaging uses an allowlist and excludes these local files even
when they are present in the working folder. Generated packages and release
verification output are also ignored. Publish the reviewed production source
through a GitHub Release. Attach only a matching production toolbox if
using the optional toolbox distribution route.

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
