# PCD-SPECTRA v1.0.0 release verification

Verified September 30, 2026 on macOS with MATLAB R2026a Update 5.

The production release reports version 1.0.0 through the single VERSION
source, application title, CITATION.cff, package filename, and package XML.
The public citation now identifies the paper as accepted for publication in
Medical Physics. No DOI, volume, or page number has been invented.

## Documentation revision: October 1, 2026

Public documentation and release metadata now use:

- Copyright © 2026 The University of Texas MD Anderson Cancer Center
- Authors: Shanli Ding, Linying Zhan, Ke Li

The five-author publication citation is retained. No bundle was rebuilt for
this revision. The previously verified local toolbox predates these metadata
changes and must not be attached as the current release asset. Use the final
GitHub Release source ZIP for this publication workflow. The functional
checks below describe the September 30 verification.

## Passed checks

- 1,344 calculation cases: 112 materials, four tube voltages, and thicknesses
  of 0, 1, and 1000 mm. Compared attenuation and detector output against their
  defining equations and verified count decompositions and transmission.
- Attenuator units and density conversion, response matrix shape and values,
  incident spectra, energy grids, and response colormap validation.
- Identity-response bin boundary tests and rejection of invalid voltage,
  negative thickness, and equal energy thresholds.
- Application startup, version display, populated statistics, voltage
  callbacks, material search, output visibility, and invalid-threshold feedback.
- Five PNGs exported in a ZIP; image headers were readable. Export smoke
  tests used 72 DPI, and the app default was verified as 400 DPI.
- MAT analysis results round-tripped without changes.
- MATLAB Code Analyzer syntax checks on 21 production and test source files.
- Production toolbox built as deployment/release/PCD-SPECTRA_1.0.0.mltbx.
  Its archive excludes anonymous sources/templates, Git history, local
  metadata, tests, and verification outputs.
- The unpacked production toolbox launched from its public launcher with
  the source repository removed from the MATLAB path and current directory.
- Git ignores the private anonymous packager, anonymous templates, review
  packages, production package outputs, and local verification outputs.
  The anonymous source files were untracked before this review.

## Scope and publication follow-through

The installed Add-On Explorer workflow, Windows, Linux, MATLAB Online, and
older MATLAB releases were not exercised. The package-path launch check
verifies bundled runtime dependencies without changing installed add-ons.

The citation uses the author-provided acceptance status and existing title
and author list. Add publisher-assigned DOI and bibliographic details when
available. Software verification does not establish permission to redistribute
upstream SPEKTR/NIST-derived data; the bundled catalog's provenance is now
explicit in THIRD_PARTY_NOTICES.md. The local upstream README does not include
redistribution terms, so the deployment guide retains that release-owner check.

An existing local Git tag named 1.0.0 was preserved. The release guide uses
v1.0.0 for the final reviewed commit. No commit, push, tag change, public
repository visibility change, or external publication was performed.

## Reproduce

From the PCD-SPECTRA repository root in MATLAB:

```matlab
addpath("tests")
verifyPCDSPECTRARelease
```

The suite creates ignored files under deployment/verification_output and
rebuilds the ignored production toolbox in deployment/release.
