# Publish PCD-SPECTRA through MATLAB Central File Exchange

This workflow publishes the reviewed production source for version 1.0.0
without building a bundle. A GitHub Release supplies a source ZIP; an attached
`.mltbx` is optional. File Exchange uses an attached toolbox when one is
present and otherwise downloads the release ZIP. MathWorks documents this
behavior in [About File Exchange](https://www.mathworks.com/matlabcentral/content/fx/about.html).

## Software identity

Authors: Shanli Ding, Linying Zhan, Ke Li

Copyright © 2026 The University of Texas MD Anderson Cancer Center

The publication citation retains Linying Zhan, Shanli Ding, Frank Dong,
Guang-Hong Chen, and Ke Li, in that order. Copy it from `deployment/CITATION.md`
when completing the File Exchange research citation field.

## 1. Push the reviewed production source

Run from the PCD-SPECTRA repository root. Review the staged changes before
committing. These commands retain the existing ignored anonymous sources and
generated release outputs locally:

```sh
git status --short
git add -u
git add tests deployment/RELEASE_VERIFICATION.md
git diff --cached --stat
git diff --cached
git commit -m "Prepare PCD-SPECTRA 1.0.0 public release"
git push origin main
```

In GitHub, make the intended production repository public when ready to
publish. The source ZIP includes the committed files at the release tag;
`.gitignore` excludes local untracked files, so only the reviewed production
files should be committed.

## 2. Create the formal GitHub Release

1. Open the repository's **Releases** page and choose **Draft a new release**.
2. Create tag `v1.0.0` targeting the final reviewed commit on `main`.
3. Set the release title to `1.0.0` and describe the first formal release.
4. Publish a regular release with the prerelease option disabled.
5. Use the automatically generated **Source code (zip)** download. No bundle
   build or manual upload is required for this source-release workflow.

The existing local tag `1.0.0` is preserved. Do not select that older tag if
it points to a commit before the final metadata corrections, and do not move
an existing published tag. The new `v1.0.0` tag must identify the reviewed
release commit.

The local `deployment/release/PCD-SPECTRA_1.0.0.mltbx` was built before the
October 1, 2026 copyright and software-author corrections. Leave it unattached
for this release. A future optional toolbox must be rebuilt from the same
commit as its release tag.

## 3. Connect GitHub to File Exchange

1. Sign in to your MathWorks account and open
   [My File Exchange](https://www.mathworks.com/matlabcentral/fileexchange/my-file-exchange).
2. Choose **Publish** and **Connect to GitHub**. You can also start from the
   [official GitHub connection guide](https://www.mathworks.com/matlabcentral/fileexchange/my-file-exchange/github-app-installation-guide).
3. Install **MATLAB and Simulink Integration for GitHub** on the personal
   account or organization that owns the repository. Select only the intended
   production repository. Organization-owned repositories can require owner
   approval for this integration.
4. After installation returns you to **My File Exchange**, locate the
   repository and select **Publish**.
5. Choose **GitHub Releases** as the distribution source.
6. Use the title, description, authors, copyright, and tags in
   `deployment/MATLAB_CENTRAL_LISTING.md`. Set the listed version to `1.0.0`,
   copy the publication citation from `deployment/CITATION.md`, and add the
   application icon or a screenshot.
7. Confirm the license display reflects `LICENSE.md`, including its
   noncommercial terms and mandatory citation requirement, then publish.

MathWorks supports licenses other than BSD for GitHub-connected submissions.
Direct **Upload Files** submissions automatically receive BSD, so use the
GitHub connection for this repository's license. See
[File Exchange license information](https://www.mathworks.com/matlabcentral/content/fx/about.html).

## 4. Check the public user workflow

Open the published File Exchange entry and verify the version, authors,
copyright, citation, license link, and download. In MATLAB, search for
PCD-SPECTRA through **Add-Ons > Get Add-Ons** (or the **Add-Ons** panel in
newer releases). Availability in that catalog is provided by the File
Exchange connection.

For the source ZIP, users extract it and open the extracted repository root
as MATLAB's current folder, then run:

```matlab
runPCDSPECTRA
```

The source ZIP requires no additional MATLAB toolboxes. It is a source
installation; it does not supply the packaged toolbox's Apps gallery entry.
If a production `.mltbx` is supplied later, users can install the toolbox and
run the same launcher.

File Exchange updates the connected listing when a new GitHub Release is
published. Pushing a commit alone does not advance a release-connected
listing. See [MathWorks' distribution guidance](https://www.mathworks.com/matlabcentral/content/fx/about.html).
