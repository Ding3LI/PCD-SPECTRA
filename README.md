# PCD-SPECTRA

PCD-SPECTRA is a MATLAB application for Photon-Counting Detector Spectral
Response Analysis. Version `1.0.0` is a production research release that
supports interactive exploration of X-ray spectra, attenuator transmission,
detector spectral response, and PCD energy-bin classification.

Authors: Shanli Ding, Linying Zhan, Ke Li

Copyright © 2026 The University of Texas MD Anderson Cancer Center

## Launch

After downloading and extracting the source ZIP, open its repository root
in MATLAB and run the command below. The same launcher is available after
installing a separately distributed MATLAB toolbox:

```matlab
runPCDSPECTRA
```

The application reads its displayed version from the repository-level
`VERSION` file through `PCDSPECTRAVersion`. Update that file when preparing a
new release; the app title and toolbox package metadata will update together.

## Interface

The **Input Parameters** panel contains:

- X-ray Tube Voltage
- Attenuator Material Type
- Attenuator Material
- Attenuator Material Thickness (mm)
- PCD Energy Thresholds, with separate Low Threshold (keV) and High Threshold
  (keV) fields

The **Outputs** section controls four visualizations:

1. Pre- and Post-attenuator X-ray Spectra
2. Incident X-Ray Spectrum vs. PCD Output Spectrum
3. PCD Effective Spectra for Low- and High-energy Bins
4. PCD Energy Response Function to Monoenergetic X-rays

The **Energy Response and Profiles** visualization includes four
**Monoenergetic Input Energy (keV)** fields. Each accepts a unique integer
from 1 through 150 keV. Clicking a new incident-energy position in the
response heatmap replaces the closest currently selected energy.

The **Statistics** section reports the number of input X-ray photons, percent
transmission through the attenuator, and low- and high-energy bin percentages.
The bin-component percentages use total recorded counts in the displayed low
and high bins as their denominator.

The **Input and Output Spectra Visualization** panel retains the notation
`E: Incident Energy; E': Recorded Energy`. It can export a composite PNG and
separate PNGs at a configurable resolution that defaults to 400 DPI. Analysis
results can also be saved as a MAT-file.

Calculation details are documented in `utils/README.md`.

## Scientific disclaimer

The spectral response functions (SRFs) displayed by this software were
estimated from measurements performed on a specific Siemens NAEOTOM Alpha
PCD-CT scanner, as described in the manuscript by Zhan et al. accepted for
publication in *Medical Physics*. These results do not represent the views of
Siemens and should not be interpreted as representative of the SRFs of other
NAEOTOM Alpha PCD-CT scanners. This software is provided solely to facilitate
dissemination and reproducibility of the results reported in that manuscript;
it is not intended to provide a universal characterization of the energy
response functions of NAEOTOM Alpha PCD-CT scanners.

## Citation

If you use PCD-SPECTRA in research, cite:

> Zhan, L., Ding, S., Dong, F., Chen, G.-H., & Li, K. *Quantifying Photon
> Counting Detector (PCD) Performance Using PCD-CT Images. Part II. Detector
> Spectral Response Function of Clinical Scanners.* Accepted for publication in
> *Medical Physics* (2026).

See `deployment/CITATION.md` for software acknowledgement and publication
status.

## License

PCD-SPECTRA is source-available under the
[PolyForm Noncommercial License 1.0.0](LICENSE.md). The license permits use,
modification, and distribution for noncommercial purposes. This includes
research use by individuals and organizations, including companies, when the
use itself is noncommercial. Commercial use is not licensed. Because the
license restricts commercial use, it is not an OSI-approved open-source
license. The mandatory scholarly citation requirement is specified in
`LICENSE.md` and `NOTICE.md`.

Copyright © 2026 The University of Texas MD Anderson Cancer Center.
See `NOTICE.md` for the required copyright notice.
