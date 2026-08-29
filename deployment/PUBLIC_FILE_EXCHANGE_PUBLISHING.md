# Publish PCD-SPECTRA in MATLAB Add-On Explorer

Publishing through MATLAB Central File Exchange makes the toolbox searchable
in MATLAB Add-On Explorer. Connect the reviewed public `PCD-SPECTRA`
repository rather than directly uploading a source archive.

## Build and tag version 1.0.0

Open MATLAB in the repository root and run:

```matlab
packagePCDSPECTRA
addon = matlab.addons.install("deployment/release/PCD-SPECTRA_1.0.0.mltbx");
runPCDSPECTRA
matlab.addons.uninstall(addon.Identifier(1), addon.Version(1))
```

After the clean-install test passes:

```sh
git add .
git commit -m "Release PCD-SPECTRA 1.0.0"
git push origin main
git tag -a v1.0.0 -m "PCD-SPECTRA 1.0.0"
git push origin v1.0.0
```

Create a non-prerelease GitHub Release from `v1.0.0` and attach
`deployment/release/PCD-SPECTRA_1.0.0.mltbx`.

## Connect the repository

1. Sign in to the MathWorks Community profile that will own the submission.
2. Open **My File Exchange**, select **Publish**, and choose **Connect to
   GitHub**.
3. Grant the MATLAB and Simulink Integration for GitHub access only to the
   reviewed `PCD-SPECTRA` repository.
4. Select the repository in **My File Exchange** and use **GitHub Releases**
   as the connection method.
5. Complete the listing with `deployment/MATLAB_CENTRAL_LISTING.md`.
6. Confirm that the displayed license is PolyForm Noncommercial License
   1.0.0 before publishing.

For future releases, update `VERSION`, rebuild, clean-install test, and create
a matching Git tag and GitHub Release.
