# MATLAB spectrum utilities

These functions implement the spectrum calculations and figures used by
the MATLAB app.

## Calculation sequence

1. `calculatePostObjectSpectrum` applies object attenuation:

   ```text
   S_post(E) = S_incident(E) * exp(-mu(E) * thickness_mm)
   ```

   `S_incident` is the pre-object spectrum. `S_post` is the post-object
   spectrum and is incident on the detector.

2. `calculateOutputSpectrum` applies the detector energy-response matrix:

   ```text
   S_output(E') =
       sum over E of R(E, E') * S_post(E)
   ```

   This matches `LyFilterWithPCDEnergyResponse.m`. Output bins below
   20 keV are set to zero in `runSpectrumAnalysis`.

3. `separateSpectrumBins` calculates the post-object input-energy
   contribution distributions:

   ```text
   C_bin(E) =
       S_post(E) * sum over E' in bin of R(E, E')
   ```

   The split threshold defaults to 53, 64, 68, and 68 keV for 70, 90, 120,
   and 140 kV. The lower and upper detector thresholds remain 20 and
   150 keV.

4. The same split threshold decomposes the detected counts:

   ```text
   lowCounts = trueLowCounts + misclassifiedHighCounts
   highCounts = misclassifiedLowCounts + trueHighCounts
   ```

   Incident energies below the split are low-energy photons. Incident
   energies at or above the split are high-energy photons.

`runSpectrumAnalysis` returns the pre-object, post-object, detector-output,
response-matrix, supplied response colormap, detector-bin, and
classification quantities.

`plotSpectrumAnalysis` renders any selected combination of the four figure
sections using exactly four response-profile energies. Only the
pre-object/post-object comparison is converted to probability density.
All other spectrum curves remain in original counts-per-keV scale.
Response profiles are set to zero below 20 keV and displayed over
20–150 keV using cubic spline interpolation. The heatmap uses
the supplied `energy_response/Colormap.mat` and displays recorded energy
over 20–140 keV with color limits `[0,0.18]`. PNG output uses Nature-style
colors, 12-point text, and a default resolution of 400 DPI.
