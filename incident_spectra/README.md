# Incident spectrum database

`incident_spectrum.mat` contains incident spectrum data.
`incident_spectra.mat` database.

The compact file contains:

- `incident_spectrum`: a `4 x 150` matrix. Rows correspond to tube voltages
  and columns correspond to energies from 1 through 150 keV.
- `kVs`: `[70 90 120 140]`.
- `energy_keV`: the 1–150 keV energy grid.
- `Al_thicknesses_mm`: the source aluminum-filtration metadata associated
  with each tube voltage.
- `metadata`: source and orientation information.

Run `buildIncidentSpectrum` after replacing the original source database.
