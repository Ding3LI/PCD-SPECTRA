function [spectrum, energyKeV, metadata] = loadIncidentSpectrum(kV, dataFile)
%LOADINCIDENTSPECTRUM Load one pre-object spectrum by tube voltage.

arguments
    kV (1, 1) double {mustBeMember(kV, [70 90 120 140])}
    dataFile (1, 1) string = defaultIncidentFile()
end

if ~isfile(dataFile)
    error("spectrum:IncidentFileNotFound", ...
        "Incident-spectrum file was not found: %s", dataFile);
end

stored = load(dataFile);
requiredVariables = [
    "incident_spectrum"
    "kVs"
    "energy_keV"
    "metadata"
];
if ~all(isfield(stored, requiredVariables))
    error("spectrum:InvalidIncidentFile", ...
        "The incident-spectrum file is missing required variables.");
end

if ~isequal(size(stored.incident_spectrum), [4 150])
    error("spectrum:InvalidIncidentShape", ...
        "incident_spectrum must have size 4-by-150.");
end

kVIndex = find(stored.kVs(:) == kV);
if ~isscalar(kVIndex)
    error("spectrum:TubeVoltageNotFound", ...
        "Tube voltage %g kV was not found in the incident database.", kV);
end

energyKeV = stored.energy_keV(:);
if ~isequal(energyKeV, (1:150)')
    error("spectrum:InvalidIncidentEnergyGrid", ...
        "The incident-spectrum energy grid must be 1 through 150 keV.");
end

spectrum = stored.incident_spectrum(kVIndex, :)';
if any(~isfinite(spectrum)) || any(spectrum < 0)
    error("spectrum:InvalidIncidentValues", ...
        "The selected incident spectrum contains invalid values.");
end

metadata = stored.metadata;
metadata.kV = kV;
if isfield(stored, "Al_thicknesses_mm")
    metadata.AlThickness_mm = stored.Al_thicknesses_mm(kVIndex);
end
end

function dataFile = defaultIncidentFile()
utilsDir = fileparts(mfilename("fullpath"));
interfaceDir = fileparts(utilsDir);
dataFile = fullfile( ...
    interfaceDir, "incident_spectra", "incident_spectrum.mat");
end
