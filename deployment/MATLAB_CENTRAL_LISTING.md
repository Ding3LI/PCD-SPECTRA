# MATLAB Central listing

## Title

PCD-SPECTRA: Photon-Counting Detector Spectral Response Analysis

## Software authors and copyright

Authors: Shanli Ding, Linying Zhan, Ke Li

Copyright © 2026 The University of Texas MD Anderson Cancer Center

## One-line summary

An interactive MATLAB app for X-ray attenuation, PCD spectral response,
energy-bin classification, and output-spectrum analysis.

## Description

PCD-SPECTRA is a research application for examining the relationship between
an input X-ray spectrum, material attenuation, detector spectral response,
and recorded-energy bins. Users can select X-ray tube voltage, attenuator
material and thickness, energy thresholds, and monoenergetic input energies;
inspect spectra and response plots; and export PNG figures or MATLAB results.

The repository contains the required MATLAB code and data assets. It targets
MATLAB R2020a or later and requires no additional MATLAB toolboxes. Functional
verification was performed on macOS with MATLAB R2026a Update 5; older
releases and other platforms have not been verified.

The included spectral response functions were estimated for one specific
Siemens NAEOTOM Alpha PCD-CT scanner and are not a universal representation
of other scanners. See the complete scientific disclaimer in `README.md`.

## Installation

Download the source ZIP from this File Exchange entry or its linked GitHub
Release, extract it, and open the extracted repository root in MATLAB. Run:

```matlab
runPCDSPECTRA
```

If a `.mltbx` is supplied in a future release, it can be installed as a
MATLAB toolbox and launched using the same command.

## License and citation

PCD-SPECTRA is source-available under the PolyForm Noncommercial License
1.0.0. Noncommercial research use, modification, and distribution are
permitted; commercial use is not licensed.

If you use PCD-SPECTRA in research, cite:

> Zhan, L., Ding, S., Dong, F., Chen, G.-H., & Li, K. *Quantifying Photon
> Counting Detector (PCD) Performance Using PCD-CT Images. Part II. Detector
> Spectral Response Function of Clinical Scanners.* Accepted for publication in
> *Medical Physics* (2026).

## Suggested tags

X-ray imaging; spectral imaging; photon-counting detector; spectral response;
attenuation; simulation; research software

## Release assets

- PCD-SPECTRA icon and application screenshots
- Automatically generated GitHub Release source ZIP
- Optional future toolbox asset: `PCD-SPECTRA_1.0.0.mltbx`
- Public source repository and `v1.0.0` release tag
- License, citation, disclaimer, and third-party notices
