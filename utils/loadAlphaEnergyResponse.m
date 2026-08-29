function [responseMatrix, inputEnergyKeV, detectedEnergyKeV] = ...
        loadAlphaEnergyResponse(responseFile)
%LOADALPHAENERGYRESPONSE Load the active 1–150 keV AER matrix.
%
% The source text file has 150 input-energy rows and 151 detected-threshold
% columns for thresholds 0 through 150 keV. The zero-keV column is removed,
% producing a 150-by-150 matrix whose rows are input energies and columns
% are detected energies.

arguments
    responseFile (1, 1) string = defaultResponseFile()
end

if ~isfile(responseFile)
    error("spectrum:ResponseFileNotFound", ...
        "Alpha energy-response file was not found: %s", responseFile);
end

rawResponse = readmatrix(responseFile);
if ~isequal(size(rawResponse), [150 151])
    error("spectrum:InvalidResponseShape", ...
        "Expected a 150-by-151 alpha energy-response matrix.");
end
if any(~isfinite(rawResponse), "all") || any(rawResponse < 0, "all")
    error("spectrum:InvalidResponseValues", ...
        "The alpha energy-response matrix contains invalid values.");
end

responseMatrix = rawResponse(:, 2:end);
inputEnergyKeV = (1:150)';
detectedEnergyKeV = (1:150)';
end

function responseFile = defaultResponseFile()
utilsDir = fileparts(mfilename("fullpath"));
interfaceDir = fileparts(utilsDir);
responseFile = fullfile( ...
    interfaceDir, "energy_response", "AlphaEnergyResponse.txt");
end
