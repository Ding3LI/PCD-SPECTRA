function app = launchPCDSPECTRAApp()
%LAUNCHPCDSPECTRAAPP Add interface paths and launch the MATLAB app.

interfaceDir = fileparts(mfilename("fullpath"));
addpath(interfaceDir);
addpath(fullfile(interfaceDir, "utils"));
addpath(fullfile(interfaceDir, "attenuator"));

app = PCDSPECTRAApp();
end
