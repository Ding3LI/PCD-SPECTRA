# Third-party and data notices

The PolyForm Noncommercial License 1.0.0 applies only to material for which
the PCD-SPECTRA licensor has authority to grant rights. It does not replace
the terms that apply to third-party material.

## Included scientific data

The release includes an attenuator catalog, incident spectra, a detector
spectral response matrix, and a response colormap:

- `attenuator/attenuatorCatalog.mat`: derived from the SPEKTR elemental and
  NIST compound attenuation databases, as recorded in `catalog.metadata`.
  It contains 92 elements and 20 compounds on the
  1–150 keV grid; mass attenuation is stored in cm^2/g, density in g/cm^3,
  and linear attenuation in 1/mm. The compound list is documented in
  `attenuator/README.md`.
- `incident_spectra/incident_spectra.mat`: the source incident-spectrum
  database. `incident_spectra/incident_spectrum.mat` contains its zero-PMMA
  slice for 70, 90, 120, and 140 kV. The extraction code and schema are in
  `incident_spectra/buildIncidentSpectrum.m` and `incident_spectra/README.md`.
- `energy_response/AlphaEnergyResponse.txt`: measured detector spectral
  response data associated with the accepted Medical Physics paper cited in
  `CITATION.cff`. Rows represent incident energies 1–150 keV; columns
  represent recorded energies 0–150 keV. The application removes column zero.
- `energy_response/Colormap.mat`: the RGB colormap used to display the
  detector response.

These files are bundled scientific assets, not downloaded at runtime. Their
inclusion does not extend the software license to any third-party material
whose original terms require separate permission.

## Reset icon

`icons/arrow-rotate-left-solid-full.svg` identifies itself as a Font Awesome
Free icon and retains its embedded copyright and license notice. The upstream
license is available at <https://fontawesome.com/license/free>.

If any third-party terms conflict with the repository license or the intended
distribution, remove or replace the affected material before release.
