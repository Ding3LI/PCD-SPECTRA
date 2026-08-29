function handles = plotSpectrumAnalysis(result, options)
%PLOTSPECTRUMANALYSIS Plot spectra, detector bins, and energy response.

arguments
    result (1, 1) struct
    options.IncidentOutputAxes = []
    options.PrePostAxes = []
    options.EffectiveBinsAxes = []
    options.ResponseHeatmapAxes = []
    options.ResponseProfileAxes = []
    options.ShowIncidentOutput (1, 1) logical = true
    options.ShowEffectiveBins (1, 1) logical = true
    options.ShowPrePost (1, 1) logical = false
    options.ShowEnergyResponse (1, 1) logical = true
    options.ProfileEnergies (1, 4) double = [70 90 120 140]
    options.ProfileSelectionCallback = []
    options.IncludeEnergyNote (1, 1) logical = true
    options.Visible (1, 1) string {mustBeMember(options.Visible, ...
        ["on", "off"])} = "on"
    options.OutputFile (1, 1) string = ""
    options.DPI (1, 1) double {mustBeFinite} = 400
end

validateDPI(options.DPI);
validateProfileEnergies(options.ProfileEnergies);

providedAxes = {
    options.IncidentOutputAxes
    options.PrePostAxes
    options.EffectiveBinsAxes
    options.ResponseHeatmapAxes
    options.ResponseProfileAxes
};
usingProvidedAxes = any(cellfun(@(item) ~isempty(item), providedAxes));
if usingProvidedAxes && ~all(cellfun(@(item) ~isempty(item), providedAxes))
    error("spectrum:IncompleteAxes", ...
        "Provide all five spectrum axes or none.");
end

if usingProvidedAxes
    figureHandle = ancestor(options.IncidentOutputAxes, "figure");
    exportTarget = figureHandle;
    incidentOutputAxes = options.IncidentOutputAxes;
    prePostAxes = options.PrePostAxes;
    effectiveBinsAxes = options.EffectiveBinsAxes;
    responseHeatmapAxes = options.ResponseHeatmapAxes;
    responseProfileAxes = options.ResponseProfileAxes;
    energyResponsePanel = responseHeatmapAxes.Parent;
    noteLabel = [];
else
    [figureHandle, exportTarget, noteLabel, incidentOutputAxes, prePostAxes, ...
        effectiveBinsAxes, energyResponsePanel, responseHeatmapAxes, ...
        responseProfileAxes] = createStandaloneLayout(options);
end

if ~isempty(noteLabel)
    setComponentVisibility(noteLabel, options.IncludeEnergyNote);
end

if options.ShowIncidentOutput
    plotIncidentOutput(incidentOutputAxes, result);
else
    resetAxes(incidentOutputAxes);
end
if options.ShowPrePost
    plotPrePost(prePostAxes, result);
else
    resetAxes(prePostAxes);
end
if options.ShowEffectiveBins
    plotEffectiveBins(effectiveBinsAxes, result);
else
    resetAxes(effectiveBinsAxes);
end
if options.ShowEnergyResponse
    plotEnergyResponse(responseHeatmapAxes, responseProfileAxes, ...
        result, options.ProfileEnergies, ...
        options.ProfileSelectionCallback);
else
    resetAxes(responseHeatmapAxes);
    resetAxes(responseProfileAxes);
end

setComponentVisibility(incidentOutputAxes, options.ShowIncidentOutput);
setComponentVisibility(prePostAxes, options.ShowPrePost);
setComponentVisibility(effectiveBinsAxes, options.ShowEffectiveBins);
setComponentVisibility(energyResponsePanel, options.ShowEnergyResponse);

drawnow;

outputFile = options.OutputFile;
if strlength(outputFile) > 0
    outputFile = validateOutputFile(outputFile);
    outputDir = fileparts(outputFile);
    if strlength(outputDir) > 0 && ~isfolder(outputDir)
        mkdir(outputDir);
    end
    exportgraphics(exportTarget, outputFile, "Resolution", options.DPI);
end

handles = struct( ...
    "Figure", figureHandle, ...
    "IncidentOutputAxes", incidentOutputAxes, ...
    "PrePostAxes", prePostAxes, ...
    "EffectiveBinsAxes", effectiveBinsAxes, ...
    "EnergyResponsePanel", energyResponsePanel, ...
    "ResponseHeatmapAxes", responseHeatmapAxes, ...
    "ResponseProfileAxes", responseProfileAxes);
end

function [figureHandle, exportTarget, noteLabel, incidentOutputAxes, prePostAxes, ...
        effectiveBinsAxes, energyResponsePanel, responseHeatmapAxes, ...
        responseProfileAxes] = createStandaloneLayout(options)
rowCount = options.ShowIncidentOutput + options.ShowPrePost + ...
    options.ShowEffectiveBins + options.ShowEnergyResponse;
if rowCount == 0
    error("spectrum:NoFiguresSelected", ...
        "Select at least one figure for plotting or export.");
end
figureHeight = max(430, 360 * rowCount);
figureHandle = figure( ...
    "Name", "PCD-SPECTRA Analysis", ...
    "Color", "white", ...
    "Visible", options.Visible, ...
    "Position", [100 80 1180 figureHeight]);
layout = tiledlayout(figureHandle, rowCount, 2, ...
    "TileSpacing", "compact", "Padding", "compact");
exportTarget = layout;
noteLabel = [];
if options.IncludeEnergyNote
    title(layout, "E: Incident Energy; E': Recorded Energy", ...
        "FontName", "Arial", "FontSize", 14, ...
        "FontWeight", "normal");
end

prePostAxes = [];
if options.ShowPrePost
    prePostAxes = nexttile(layout, [1 2]);
end
incidentOutputAxes = [];
if options.ShowIncidentOutput
    incidentOutputAxes = nexttile(layout, [1 2]);
end
effectiveBinsAxes = [];
if options.ShowEffectiveBins
    effectiveBinsAxes = nexttile(layout, [1 2]);
end
energyResponsePanel = [];
responseHeatmapAxes = [];
responseProfileAxes = [];
if options.ShowEnergyResponse
    responseHeatmapAxes = nexttile(layout);
    responseProfileAxes = nexttile(layout);
end
end

function plotIncidentOutput(axesHandle, result)
blue = [0.0000 0.4470 0.6980];
orange = [0.8350 0.3690 0.0000];
resetAxes(axesHandle);
hold(axesHandle, "on");
plot(axesHandle, result.inputEnergy_keV, result.postObjectSpectrum, ...
    "Color", blue, "LineWidth", 1.9, ...
    "DisplayName", "Incident X-ray spectrum (post-attenuator)");
plot(axesHandle, result.detectedEnergy_keV, result.outputSpectrum, ...
    "Color", orange, "LineWidth", 1.9, ...
    "DisplayName", "PCD output spectrum");
hold(axesHandle, "off");
title(axesHandle, "Incident X-Ray Spectrum vs. PCD Output Spectrum");
xlabel(axesHandle, "E or E' (keV)");
ylabel(axesHandle, "Counts/keV");
xlim(axesHandle, [20 150]);
legend(axesHandle, "Location", "northeast", "Box", "off");
applyAxesStyle(axesHandle);
recenterYAxis(axesHandle);
end

function plotPrePost(axesHandle, result)
blue = [0.0000 0.4470 0.6980];
orange = [0.8350 0.3690 0.0000];
preObjectDensity = probabilityDensity( ...
    result.incidentSpectrum, result.inputEnergy_keV);
postObjectDensity = probabilityDensity( ...
    result.postObjectSpectrum, result.inputEnergy_keV);
resetAxes(axesHandle);
hold(axesHandle, "on");
plot(axesHandle, result.inputEnergy_keV, preObjectDensity, ...
    "Color", blue, "LineWidth", 1.9, ...
    "DisplayName", "Pre-attenuator X-ray spectrum");
plot(axesHandle, result.inputEnergy_keV, postObjectDensity, ...
    "Color", orange, "LineWidth", 1.9, ...
    "DisplayName", "Post-attenuator X-ray spectrum");
hold(axesHandle, "off");
title(axesHandle, "Pre- and Post-attenuator X-ray Spectra");
xlabel(axesHandle, "E (keV)");
ylabel(axesHandle, "Probability Density (keV^{-1})");
xlim(axesHandle, [20 150]);
legend(axesHandle, "Location", "northeast", "Box", "off");
applyAxesStyle(axesHandle);
recenterYAxis(axesHandle);
end

function plotEffectiveBins(axesHandle, result)
blue = [0.0000 0.4470 0.6980];
purple = [0.8000 0.4750 0.6550];
skyBlue = [0.3370 0.7060 0.9140];
charcoal = [0.1800 0.1800 0.1800];
resetAxes(axesHandle);
hold(axesHandle, "on");
area(axesHandle, result.inputEnergy_keV, result.lowSpectrum, ...
    "FaceColor", skyBlue, "FaceAlpha", 0.16, ...
    "EdgeColor", "none", "HandleVisibility", "off");
plot(axesHandle, result.inputEnergy_keV, result.lowSpectrum, ...
    "Color", blue, "LineWidth", 1.9, ...
    "DisplayName", sprintf("Low energy bin [%g, %g) keV", ...
    result.thresholds_keV(1), result.thresholds_keV(2)));
area(axesHandle, result.inputEnergy_keV, result.highSpectrum, ...
    "FaceColor", purple, "FaceAlpha", 0.14, ...
    "EdgeColor", "none", "HandleVisibility", "off");
plot(axesHandle, result.inputEnergy_keV, result.highSpectrum, ...
    "Color", purple, "LineWidth", 1.9, ...
    "DisplayName", sprintf("High energy bin [%g, +∞) keV", ...
    result.thresholds_keV(2)));
xline(axesHandle, result.thresholds_keV(1), ":", ...
    "Color", charcoal, "LineWidth", 1.0, ...
    "HandleVisibility", "off");
xline(axesHandle, result.thresholds_keV(2), "--", ...
    "Color", charcoal, "LineWidth", 1.2, ...
    "HandleVisibility", "off");
hold(axesHandle, "off");
title(axesHandle, ...
    "PCD Effective Spectra for Low- and High-energy Bins");
xlabel(axesHandle, "E (keV)");
ylabel(axesHandle, "Counts/keV");
xlim(axesHandle, [20 150]);
legend(axesHandle, "Location", "northeast", "Box", "off");
applyAxesStyle(axesHandle);
recenterYAxis(axesHandle);
end

function plotEnergyResponse(heatmapAxes, profileAxes, result, ...
        profileEnergies, selectionCallback)
resetAxes(heatmapAxes);
responseImage = imagesc(heatmapAxes, ...
    result.detectedEnergy_keV, result.inputEnergy_keV, ...
    result.responseMatrix);
responseImage.PickableParts = "all";
responseImage.HitTest = "on";
if ~isempty(selectionCallback)
    responseImage.ButtonDownFcn = @(~, event) ...
        selectHeatmapEnergy(event, selectionCallback);
end
axis(heatmapAxes, "xy");
ylim(heatmapAxes, [1 150]);
xlim(heatmapAxes, [20 140]);
colormap(heatmapAxes, result.responseColormap);
clim(heatmapAxes, [0 0.18]);
colorbar(heatmapAxes);
title(heatmapAxes, "PCD Energy Response Function");
xlabel(heatmapAxes, "E' (keV)");
ylabel(heatmapAxes, "E (keV)");
applyAxesStyle(heatmapAxes);
hold(heatmapAxes, "on");
for energyIndex = 1:numel(profileEnergies)
    selectedEnergy = profileEnergies(energyIndex);
    lineHandle = yline(heatmapAxes, selectedEnergy, "-", ...
        sprintf("E = %d keV", selectedEnergy), ...
        "Color", [0.95 0.95 0.95], ...
        "LineWidth", 1.0, ...
        "LabelHorizontalAlignment", "left", ...
        "LabelVerticalAlignment", "bottom");
    lineHandle.HitTest = "off";
end
hold(heatmapAxes, "off");

profileColors = [
    0.0000 0.4470 0.6980
    0.8350 0.3690 0.0000
    0.9290 0.6940 0.1250
    0.8000 0.4750 0.6550
];
resetAxes(profileAxes);
hold(profileAxes, "on");
smoothDetectedEnergyKeV = linspace(1, 150, 1491)';
for energyIndex = 1:numel(profileEnergies)
    selectedEnergy = profileEnergies(energyIndex);
    inputIndex = find(result.inputEnergy_keV == selectedEnergy, 1);
    responseProfile = result.responseMatrix(inputIndex, :)';
    responseProfile(result.detectedEnergy_keV < 20) = 0;
    smoothResponseProfile = interp1( ...
        result.detectedEnergy_keV, responseProfile, ...
        smoothDetectedEnergyKeV, "spline");
    smoothResponseProfile = max(smoothResponseProfile, 0);
    smoothResponseProfile(smoothDetectedEnergyKeV < 20) = 0;
    plot(profileAxes, smoothDetectedEnergyKeV, ...
        smoothResponseProfile, ...
        "Color", profileColors(energyIndex, :), ...
        "LineWidth", 1.7, ...
        "DisplayName", sprintf("E = %d keV", selectedEnergy));
end
hold(profileAxes, "off");
title(profileAxes, "Monoenergetic Response");
xlabel(profileAxes, "E' (keV)");
ylabel(profileAxes, "Response (keV^{-1})");
xlim(profileAxes, [20 150]);
if isempty(profileEnergies)
    legend(profileAxes, "off");
else
    legend(profileAxes, "Location", "northeast", "Box", "off");
end
applyAxesStyle(profileAxes);
recenterYAxis(profileAxes);
end

function selectHeatmapEnergy(event, selectionCallback)
selectedEnergy = round(event.IntersectionPoint(2));
selectedEnergy = min(max(selectedEnergy, 1), 150);
selectionCallback(selectedEnergy);
end

function density = probabilityDensity(spectrum, energyKeV)
density = spectrum(:);
density(energyKeV < 20) = 0;
normalization = sum(density);
if normalization > 0
    density = density ./ normalization;
end
end

function setComponentVisibility(component, isVisible)
if isempty(component) || ~isvalid(component)
    return
end
if isVisible
    component.Visible = "on";
else
    component.Visible = "off";
end
end

function resetAxes(axesHandle)
if isempty(axesHandle) || ~isvalid(axesHandle)
    return
end
cla(axesHandle, "reset");
axesHandle.XLimMode = "auto";
axesHandle.YLimMode = "auto";
axesHandle.XScale = "linear";
axesHandle.YScale = "linear";
axesHandle.DataAspectRatioMode = "auto";
axesHandle.PlotBoxAspectRatioMode = "auto";
view(axesHandle, 2);
end

function recenterYAxis(axesHandle)
dataHandles = findobj(axesHandle, "-property", "YData");
yValues = zeros(0, 1);
for handleIndex = 1:numel(dataHandles)
    handleYData = dataHandles(handleIndex).YData;
    if isnumeric(handleYData)
        yValues = [yValues; handleYData(:)]; %#ok<AGROW>
    end
end
yValues = yValues(isfinite(yValues));
if isempty(yValues)
    axesHandle.YLim = [0 1];
    return
end
maximumValue = max(yValues);
if maximumValue > 0
    axesHandle.YLim = [0 1.08 * maximumValue];
else
    axesHandle.YLim = [0 1];
end
end

function applyAxesStyle(axesHandle)
axesHandle.FontName = "Arial";
axesHandle.FontSize = 12;
axesHandle.Title.FontSize = 12;
axesHandle.Title.FontWeight = "bold";
axesHandle.Title.FontSizeMode = "manual";
axesHandle.XLabel.FontSize = 12;
axesHandle.XLabel.FontSizeMode = "manual";
axesHandle.YLabel.FontSize = 12;
axesHandle.YLabel.FontSizeMode = "manual";
axesHandle.LineWidth = 0.8;
axesHandle.Box = "off";
axesHandle.Color = "white";
axesHandle.XColor = [0.15 0.15 0.15];
axesHandle.YColor = [0.15 0.15 0.15];
axesHandle.GridColor = [0.78 0.78 0.78];
axesHandle.GridAlpha = 0.28;
grid(axesHandle, "on");
end

function validateProfileEnergies(profileEnergies)
if any(~isfinite(profileEnergies)) || ...
        any(profileEnergies ~= round(profileEnergies)) || ...
        any(profileEnergies < 1 | profileEnergies > 150) || ...
        numel(unique(profileEnergies)) ~= 4
    error("spectrum:InvalidProfileEnergies", ...
        ["Monoenergetic input energies must be four unique integers " ...
         "from 1 to 150."]);
end
end

function validateDPI(dpi)
if dpi < 1 || dpi > 1200 || dpi ~= round(dpi)
    error("spectrum:InvalidExportDPI", ...
        "Export DPI must be a whole number from 1 through 1200.");
end
end

function outputFile = validateOutputFile(outputFile)
[outputDir, outputName, outputExtension] = fileparts(outputFile);
if outputExtension == ""
    outputExtension = ".png";
elseif ~strcmpi(outputExtension, ".png")
    error("spectrum:InvalidFigureExtension", ...
        "Spectrum figures must be exported as PNG files.");
end
outputFile = fullfile(outputDir, outputName + outputExtension);
end
