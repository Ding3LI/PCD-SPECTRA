# Attenuator material catalog

This folder provides a self-contained MATLAB interface to the bundled
attenuator material catalog:

- 92 elements, from hydrogen (`H`, atomic number 1) through uranium (`U`,
  atomic number 92).
- 20 NIST compounds: Fat, Air, Blood, Bone, Brain, Breast, CdTe, CsI,
  EyeLens, Gd2O2S, GaAs, Lung, HgI2, Muscle, Polyethylene, PMMA, Polystyrene,
  Teflon, SoftTissue, and Water.

The generated `attenuatorCatalog.mat` stores density, mass attenuation, and
linear attenuation data on the 1–150 keV energy grid. Element records also
include atomic number and atomic mass. The detector response matrix is
stored separately in `energy_response/AlphaEnergyResponse.txt`.

## MATLAB usage

Add the interface folder and load the catalog:

```matlab
addpath("attenuator");
catalog = loadAttenuatorCatalog();
```

List materials for an app dropdown or table:

```matlab
allMaterials = listAttenuatorMaterials();
elements = listAttenuatorMaterials("element");
compounds = listAttenuatorMaterials("compound");
```

Retrieve one material by element symbol, full element name, atomic number, or
compound name:

```matlab
aluminum = getAttenuatorMaterial("Al");
aluminumByZ = getAttenuatorMaterial(13);
water = getAttenuatorMaterial("Water");
```

The returned `linearAttenuation_mm_inv` vector can be used directly with a
thickness in millimeters:

```matlab
transmission = exp(-water.linearAttenuation_mm_inv .* thickness_mm);
```

The bundled mass attenuation coefficients use units of `cm^2/g`. Linear
attenuation is calculated as:

```text
mu [1/mm] = (mu/rho) [cm^2/g] * density [g/cm^3] * 0.1 [cm/mm]
```
