function outputFile = buildIncidentSpectrum()
%BUILDINCIDENTSPECTRUM Save the zero-PMMA spectra as one compact database.
%
% outputFile = buildIncidentSpectrum() reads incident_spectra.mat, verifies
% the four expected tube voltages, selects the PMMA_nums == 0 slice, and
% writes incident_spectrum.mat beside this function.

dataDir = fileparts(mfilename("fullpath"));
sourceFile = fullfile(dataDir, "incident_spectra.mat");
outputFile = fullfile(dataDir, "incident_spectrum.mat");

if ~isfile(sourceFile)
    error("incidentSpectrum:SourceNotFound", ...
        "Incident-spectrum source file was not found: %s", sourceFile);
end

source = load(sourceFile);
requiredVariables = [
    "incident_spectra"
    "kVs"
    "PMMA_nums"
    "Al_thicknesses"
];
if ~all(isfield(source, requiredVariables))
    error("incidentSpectrum:InvalidSource", ...
        "The source file is missing one or more required variables.");
end

expectedKVs = [70 90 120 140];
kVs = source.kVs(:)';
if ~isequal(kVs, expectedKVs)
    error("incidentSpectrum:UnexpectedTubeVoltages", ...
        "Expected tube voltages [70 90 120 140] kV, but found [%s].", ...
        strtrim(sprintf("%g ", kVs)));
end

pmmaIndex = find(source.PMMA_nums(:) == 0);
if ~isscalar(pmmaIndex)
    error("incidentSpectrum:InvalidZeroPMMASlice", ...
        "Expected exactly one PMMA_nums == 0 spectrum slice.");
end

sourceSize = size(source.incident_spectra);
if ~isequal(sourceSize, [numel(source.PMMA_nums), numel(kVs), 150])
    error("incidentSpectrum:InvalidSpectrumShape", ...
        "Expected incident_spectra to have size %d-by-%d-by-150.", ...
        numel(source.PMMA_nums), numel(kVs));
end

incident_spectrum = reshape( ...
    source.incident_spectra(pmmaIndex, :, :), numel(kVs), 150);
energy_keV = (1:150)';
Al_thicknesses_mm = source.Al_thicknesses(:)';

if any(~isfinite(incident_spectrum), "all") || ...
        any(incident_spectrum < 0, "all")
    error("incidentSpectrum:InvalidSpectrumValues", ...
        "The zero-PMMA incident spectra contain invalid values.");
end
if ~isequal(size(Al_thicknesses_mm), size(kVs))
    error("incidentSpectrum:InvalidAluminumMetadata", ...
        "Aluminum thickness metadata must match the four tube voltages.");
end

metadata = struct( ...
    "schemaVersion", 1, ...
    "sourceFile", "incident_spectra.mat", ...
    "PMMA", 0, ...
    "PMMAUnit", "source index", ...
    "spectrumRows", "tube voltage", ...
    "spectrumColumns", "energy_keV", ...
    "spectrumUnit", "photon count");

save(outputFile, "incident_spectrum", "kVs", "energy_keV", ...
    "Al_thicknesses_mm", "metadata", "-v7");
end
