%% PCD-SPECTRA: Getting Started
% PCD-SPECTRA is an interactive MATLAB application for Photon-Counting
% Detector Spectral Response Analysis.
%
% Authors: Shanli Ding, Linying Zhan, Ke Li
% Copyright © 2026 The University of Texas MD Anderson Cancer Center
%
% Before using the software, review LICENSE.md and the citation guidance in
% deployment/CITATION.md.

%% Launch the app
% Extract the source ZIP and open its root folder in MATLAB, or install the
% separately distributed toolbox. Run in the MATLAB Command Window:

% runPCDSPECTRA

%% Basic workflow
% 1. Select the X-ray tube voltage, attenuator material, and thickness.
% 2. Set the low and high PCD energy thresholds.
% 3. Select the desired outputs.
% 4. Set the four monoenergetic input energies beneath Energy Response and
%    Profiles in the visualization panel.
% 5. Inspect the spectra, bin statistics, and energy-response figures.
% 6. Use the in-app controls to export PNG figures or MATLAB result data.

%% Scientific disclaimer
% The spectral response functions (SRFs) displayed by this software were
% estimated from measurements performed on a specific Siemens NAEOTOM Alpha
% PCD-CT scanner, as described in the following paper:
%
% Linying Zhan, Shanli Ding, Frank Dong, Guang-Hong Chen, Ke Li. "Quantifying
% Photon Counting Detector (PCD) Performance Using PCD-CT Images. Part II.
% Detector Spectral Response Function of Clinical Scanners." Medical Physics, 2026. Accepted for publication.
%
% The results do not represent the views of Siemens and should not be
% interpreted as representative of the SRFs of other NAEOTOM Alpha PCD-CT scanners.
% This software is provided solely to facilitate dissemination and
% reproducibility of the results reported in that paper;
% it is not intended to provide a universal characterization of the energy
% response functions of NAEOTOM Alpha PCD-CT scanners.

%% Citation
% Cite the accepted paper listed in deployment/CITATION.md.

%% License
% PCD-SPECTRA is source-available under the PolyForm Noncommercial License
% 1.0.0. Research and other noncommercial uses are permitted. Commercial use
% is not licensed.
