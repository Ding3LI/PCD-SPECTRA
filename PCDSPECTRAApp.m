function app = PCDSPECTRAApp(varargin)
%PCDSPECTRAAPP Interactive PCD spectral-response analysis application.
%
% app = PCDSPECTRAApp() opens the app.
% app = PCDSPECTRAApp("Visible", "off") creates it for testing.

parser = inputParser;
addParameter(parser, "Visible", "on", ...
    @(value) any(strcmpi(string(value), ["on", "off"])));
parse(parser, varargin{:});
visibleMode = lower(string(parser.Results.Visible));
appVersion = PCDSPECTRAVersion();

interfaceDir = fileparts(mfilename("fullpath"));
utilsDir = fullfile(interfaceDir, "utils");
attenuatorDir = fullfile(interfaceDir, "attenuator");
addpath(utilsDir);
addpath(attenuatorDir);

uiFigure = uifigure( ...
    "Name", "PCD-SPECTRA - Photon-Counting Detector Spectral " + ...
        "Response Analysis (version " + appVersion + ")", ...
    "Color", [0.97 0.97 0.97], ...
    "Position", [80 60 1460 900], ...
    "AutoResizeChildren", "off", ...
    "Visible", visibleMode);

rootPanel = uipanel(uiFigure, ...
    "BorderType", "none", ...
    "BackgroundColor", [0.97 0.97 0.97], ...
    "Position", [1 1 uiFigure.Position(3) uiFigure.Position(4)]);

mainLayout = uigridlayout(rootPanel, [1 2]);
mainLayout.ColumnWidth = {"1x", "1.618x"};
mainLayout.RowHeight = {"1x"};
mainLayout.Padding = [12 12 12 12];
mainLayout.ColumnSpacing = 12;

controlPanel = uipanel(mainLayout, ...
    "Title", "Input Parameters", ...
    "FontName", "Arial", ...
    "FontSize", 16, ...
    "FontWeight", "bold");
controlPanel.Layout.Row = 1;
controlPanel.Layout.Column = 1;

controlLayout = uigridlayout(controlPanel, [22 2]);
controlLayout.Scrollable = "on";
controlLayout.ColumnWidth = {"1x", "1x"};
controlLayout.RowHeight = { ...
    24, 30, 24, 30, 24, 30, 24, 30, 24, 30, ...
    30, 30, 58, 58, 58, 58, 30, 248, 36, 36, ...
    36, 70};
controlLayout.Padding = [10 10 10 10];
controlLayout.RowSpacing = 4;

makeLabel(controlLayout, "X-ray Tube Voltage", 1);
kVDropdown = uidropdown(controlLayout, ...
    "Items", ["70 kV", "90 kV", "120 kV", "140 kV"], ...
    "ItemsData", [70 90 120 140], ...
    "Value", 120, ...
    "FontName", "Arial", ...
    "FontSize", 14);
kVDropdown.Layout.Row = 2;
kVDropdown.Layout.Column = [1 2];

makeLabel(controlLayout, "Attenuator Material Type", 3);
materialTypeDropdown = uidropdown(controlLayout, ...
    "Items", ["All", "Elements", "Compounds"], ...
    "Value", "All", ...
    "FontName", "Arial", ...
    "FontSize", 14);
materialTypeDropdown.Layout.Row = 4;
materialTypeDropdown.Layout.Column = [1 2];

makeLabel(controlLayout, "Attenuator Material", 5);
materialDropdown = uidropdown(controlLayout, ...
    "Editable", "on", ...
    "Tooltip", ...
        "Type a symbol or part of an element or compound name, then press Enter.", ...
    "FontName", "Arial", ...
    "FontSize", 14);
materialDropdown.Layout.Row = 6;
materialDropdown.Layout.Column = [1 2];

makeLabel(controlLayout, "Attenuator Material Thickness (mm)", 7);
thicknessSpinner = uispinner(controlLayout, ...
    "Limits", [0 1000], ...
    "Step", 0.1, ...
    "Value", 1, ...
    "FontName", "Arial", ...
    "FontSize", 14);
thicknessSpinner.Layout.Row = 8;
thicknessSpinner.Layout.Column = [1 2];

makeLabel(controlLayout, "PCD Energy Thresholds", 9);
makeColumnLabel( ...
    controlLayout, "Low Threshold (keV)", 10, 1);
makeColumnLabel( ...
    controlLayout, "High Threshold (keV)", 10, 2);
lowThresholdSpinner = uispinner(controlLayout, ...
    "Limits", [1 149], ...
    "Step", 1, ...
    "Value", 20, ...
    "FontName", "Arial", ...
    "FontSize", 14);
lowThresholdSpinner.Layout.Row = 11;
lowThresholdSpinner.Layout.Column = 1;

splitThresholdSpinner = uispinner(controlLayout, ...
    "Limits", [2 150], ...
    "Step", 1, ...
    "Value", 68, ...
    "FontName", "Arial", ...
    "FontSize", 14);
splitThresholdSpinner.Layout.Row = 11;
splitThresholdSpinner.Layout.Column = 2;

outputsHeader = uilabel(controlLayout, ...
    "Text", "Outputs", ...
    "FontName", "Arial", ...
    "FontSize", 16, ...
    "FontWeight", "bold");
outputsHeader.Layout.Row = 12;
outputsHeader.Layout.Column = [1 2];

outputsGrid = uigridlayout(controlLayout, [4 1]);
outputsGrid.Layout.Row = [13 16];
outputsGrid.Layout.Column = [1 2];
outputsGrid.ColumnWidth = {"1x"};
outputsGrid.RowHeight = {"1x", "1x", "1x", "1x"};
outputsGrid.Padding = [0 0 0 0];
outputsGrid.ColumnSpacing = 8;
outputsGrid.RowSpacing = 2;

prePostCheckbox = makeCheckbox( ...
    outputsGrid, "Pre- and Post-attenuator X-ray Spectra", false, 1, 1);
incidentOutputCheckbox = makeCheckbox( ...
    outputsGrid, ...
    "Incident X-Ray Spectrum vs. PCD Output Spectrum", true, 2, 1);
effectiveBinsCheckbox = makeCheckbox( ...
    outputsGrid, ...
    "PCD Effective Spectra for Low- and High-energy Bins", true, 3, 1);
energyResponseCheckbox = makeCheckbox( ...
    outputsGrid, ...
    "PCD Energy Response Function to Monoenergetic X-rays", true, 4, 1);

statisticsHeader = uilabel(controlLayout, ...
    "Text", "Statistics", ...
    "FontName", "Arial", ...
    "FontSize", 16, ...
    "FontWeight", "bold");
statisticsHeader.Layout.Row = 17;
statisticsHeader.Layout.Column = [1 2];

statisticsGrid = uigridlayout(controlLayout, [8 2]);
statisticsGrid.Layout.Row = 18;
statisticsGrid.Layout.Column = [1 2];
statisticsGrid.ColumnWidth = {"1x", 100};
statisticsGrid.RowHeight = repmat({28}, 1, 8);
statisticsGrid.Padding = [0 0 0 0];
statisticsGrid.RowSpacing = 1;
statisticsGrid.ColumnSpacing = 1;
statisticsNames = {
    "Number of Input X-ray Photons"
    "Percent Transmission Through Attenuator"
    "Low energy bin counts"
    "    True low energy photon"
    "    Misclassified high energy photon"
    "High energy bin counts"
    "    Misclassified low energy photon"
    "    True high energy photon"
};
statisticsNameLabels = cell(1, 8);
statisticsValueLabels = cell(1, 8);
for statisticIndex = 1:8
    isPrimaryStatistic = ismember(statisticIndex, [1 2 3 6]);
    statisticsNameLabels{statisticIndex} = uilabel(statisticsGrid, ...
        "Text", statisticsNames{statisticIndex}, ...
        "FontName", "Arial", ...
        "FontSize", 12, ...
        "WordWrap", "on", ...
        "BackgroundColor", statisticBackground(isPrimaryStatistic));
    statisticsNameLabels{statisticIndex}.Layout.Row = statisticIndex;
    statisticsNameLabels{statisticIndex}.Layout.Column = 1;
    statisticsValueLabels{statisticIndex} = uilabel( ...
        statisticsGrid, ...
        "Text", "--", ...
        "HorizontalAlignment", "right", ...
        "FontName", "Arial", ...
        "FontSize", 12, ...
        "BackgroundColor", statisticBackground(isPrimaryStatistic));
    statisticsValueLabels{statisticIndex}.Layout.Row = statisticIndex;
    statisticsValueLabels{statisticIndex}.Layout.Column = 2;
    if isPrimaryStatistic
        statisticsNameLabels{statisticIndex}.FontWeight = "bold";
        statisticsValueLabels{statisticIndex}.FontWeight = "bold";
    else
        statisticsNameLabels{statisticIndex}.FontColor = ...
            [0.30 0.30 0.30];
        statisticsValueLabels{statisticIndex}.FontColor = ...
            [0.30 0.30 0.30];
    end
end

exportDPILabel = uilabel(controlLayout, ...
    "Text", "PNG export DPI (1–1200)", ...
    "FontName", "Arial", ...
    "FontSize", 14, ...
    "FontWeight", "bold", ...
    "WordWrap", "on");
exportDPILabel.Layout.Row = 19;
exportDPILabel.Layout.Column = 1;
exportDPISpinner = uispinner(controlLayout, ...
    "Limits", [1 1200], ...
    "Step", 50, ...
    "RoundFractionalValues", "on", ...
    "Value", 400, ...
    "FontName", "Arial", ...
    "FontSize", 14);
exportDPISpinner.Layout.Row = 19;
exportDPISpinner.Layout.Column = 2;

exportButton = uibutton(controlLayout, ...
    "Text", "Export PNG package", ...
    "FontName", "Arial", ...
    "FontSize", 14);
exportButton.Layout.Row = 20;
exportButton.Layout.Column = [1 2];

saveButton = uibutton(controlLayout, ...
    "Text", "Save analysis MAT", ...
    "FontName", "Arial", ...
    "FontSize", 14);
saveButton.Layout.Row = 21;
saveButton.Layout.Column = [1 2];

statusLabel = uilabel(controlLayout, ...
    "Text", "Ready", ...
    "FontName", "Arial", ...
    "FontSize", 14, ...
    "FontColor", [0.20 0.20 0.20], ...
    "VerticalAlignment", "top", ...
    "WordWrap", "on");
statusLabel.Layout.Row = 22;
statusLabel.Layout.Column = [1 2];

plotPanel = uipanel(mainLayout, ...
    "BorderType", "line", ...
    "BackgroundColor", "white");
plotPanel.Layout.Row = 1;
plotPanel.Layout.Column = 2;

plotLayout = uigridlayout(plotPanel, [5 2]);
plotLayout.Scrollable = "on";
plotLayout.RowHeight = {24, 0, 340, 340, 430};
plotLayout.ColumnWidth = {"1x", "1x"};
plotLayout.Padding = [10 8 10 10];
plotLayout.RowSpacing = 10;
plotLayout.ColumnSpacing = 12;

visualizationHeaderGrid = uigridlayout(plotLayout, [1 3]);
visualizationHeaderGrid.Layout.Row = 1;
visualizationHeaderGrid.Layout.Column = [1 2];
visualizationHeaderGrid.ColumnWidth = {"fit", "1x", 34};
visualizationHeaderGrid.RowHeight = {"1x"};
visualizationHeaderGrid.Padding = [0 0 0 0];
visualizationHeaderGrid.ColumnSpacing = 12;
visualizationTitleLabel = uilabel(visualizationHeaderGrid, ...
    "Text", "Input and Output Spectra Visualization", ...
    "FontName", "Arial", ...
    "FontSize", 16, ...
    "FontWeight", "bold", ...
    "WordWrap", "on");
visualizationTitleLabel.Layout.Row = 1;
visualizationTitleLabel.Layout.Column = 1;
energyNoteLabel = uilabel(visualizationHeaderGrid, ...
    "Text", "E: Incident Energy; E': Recorded Energy", ...
    "FontName", "Arial", ...
    "FontSize", 14, ...
    "FontColor", [0.35 0.35 0.35], ...
    "WordWrap", "on");
energyNoteLabel.Layout.Row = 1;
energyNoteLabel.Layout.Column = 2;
resetViewPanel = uipanel(visualizationHeaderGrid, ...
    "BorderType", "line", ...
    "BackgroundColor", [0.97 0.97 0.97]);
resetViewPanel.Layout.Row = 1;
resetViewPanel.Layout.Column = 3;
resetViewLayout = uigridlayout(resetViewPanel, [1 1]);
resetViewLayout.RowHeight = {"1x"};
resetViewLayout.ColumnWidth = {"1x"};
resetViewLayout.Padding = [7 2 7 2];
resetViewButton = uiimage(resetViewLayout, ...
    "ImageSource", fullfile(interfaceDir, "icons", ...
        "arrow-rotate-left-solid-full.svg"), ...
    "ScaleMethod", "fit", ...
    "Tooltip", "Reset all figure views");
resetViewButton.Layout.Row = 1;
resetViewButton.Layout.Column = 1;

prePostAxes = uiaxes(plotLayout);
prePostAxes.Layout.Row = 2;
prePostAxes.Layout.Column = [1 2];

incidentOutputAxes = uiaxes(plotLayout);
incidentOutputAxes.Layout.Row = 3;
incidentOutputAxes.Layout.Column = [1 2];

effectiveBinsAxes = uiaxes(plotLayout);
effectiveBinsAxes.Layout.Row = 4;
effectiveBinsAxes.Layout.Column = [1 2];

energyResponseLayout = uigridlayout(plotLayout, [3 2]);
energyResponseLayout.Layout.Row = 5;
energyResponseLayout.Layout.Column = [1 2];
energyResponseLayout.ColumnWidth = {"1x", "1x"};
energyResponseLayout.RowHeight = {28, 64, "1x"};
energyResponseLayout.Padding = [0 0 0 0];
energyResponseLayout.ColumnSpacing = 12;
energyResponseLayout.RowSpacing = 4;
energyResponseHeading = uilabel(energyResponseLayout, ...
    "Text", "Energy Response and Profiles", ...
    "FontName", "Arial", ...
    "FontSize", 12, ...
    "FontWeight", "bold", ...
    "WordWrap", "on");
energyResponseHeading.Layout.Row = 1;
energyResponseHeading.Layout.Column = [1 2];

profileGrid = uigridlayout(energyResponseLayout, [2 4]);
profileGrid.Layout.Row = 2;
profileGrid.Layout.Column = [1 2];
profileGrid.ColumnWidth = {"1x", "1x", "1x", "1x"};
profileGrid.RowHeight = {24, 32};
profileGrid.Padding = [0 0 0 0];
profileGrid.ColumnSpacing = 8;
profileGrid.RowSpacing = 4;
profileEnergyLabel = uilabel(profileGrid, ...
    "Text", "Monoenergetic Input Energy (keV)", ...
    "FontName", "Arial", ...
    "FontSize", 12, ...
    "FontWeight", "bold", ...
    "WordWrap", "on");
profileEnergyLabel.Layout.Row = 1;
profileEnergyLabel.Layout.Column = [1 4];
defaultProfileEnergies = [70 90 120 140];
profileEnergySpinners = cell(1, 4);
for profileIndex = 1:4
    profileEnergySpinners{profileIndex} = uispinner(profileGrid, ...
        "Limits", [1 150], ...
        "Step", 1, ...
        "RoundFractionalValues", "on", ...
        "Value", defaultProfileEnergies(profileIndex), ...
        "Tooltip", "Integer incident energy from 1 to 150 keV.", ...
        "FontName", "Arial", ...
        "FontSize", 14);
    profileEnergySpinners{profileIndex}.Layout.Row = 2;
    profileEnergySpinners{profileIndex}.Layout.Column = profileIndex;
end
responseHeatmapAxes = uiaxes(energyResponseLayout);
responseHeatmapAxes.Layout.Row = 3;
responseHeatmapAxes.Layout.Column = 1;
responseProfileAxes = uiaxes(energyResponseLayout);
responseProfileAxes.Layout.Row = 3;
responseProfileAxes.Layout.Column = 2;

materialTypeDropdown.ValueChangedFcn = @onMaterialTypeChanged;
materialDropdown.ValueChangedFcn = @onMaterialSelectionChanged;
resetViewButton.ImageClickedFcn = @onResetFigureViews;
exportButton.ButtonPushedFcn = @onExport;
saveButton.ButtonPushedFcn = @onSave;
thicknessSpinner.ValueChangingFcn = @onThicknessChanging;
uiFigure.SizeChangedFcn = @onFigureSizeChanged;
if isprop(uiFigure, "ThemeChangedFcn")
    uiFigure.ThemeChangedFcn = @onThemeChanged;
end
for profileIndex = 1:4
    profileEnergySpinners{profileIndex}.ValueChangedFcn = ...
        @onProfileEnergyChanged;
end

interactiveControls = {
    kVDropdown
    thicknessSpinner
    lowThresholdSpinner
    splitThresholdSpinner
    incidentOutputCheckbox
    effectiveBinsCheckbox
    prePostCheckbox
    energyResponseCheckbox
};
for controlIndex = 1:numel(interactiveControls)
    interactiveControls{controlIndex}.ValueChangedFcn = @onUpdate;
end
kVDropdown.ValueChangedFcn = @onTubeVoltageChanged;

profileEnergies = defaultProfileEnergies;
visualizationHeaderHeight = 24;
currentMaterialLabels = strings(0, 1);
currentMaterialKeys = strings(0, 1);
selectedMaterialKey = "";
searchMessage = "";
refreshMaterialItems("", "element:Al");
drawnow;
updateDisplayLayout();
updatePlotVisibility();

try
    updatePlots(true);
catch appError
    delete(uiFigure);
    rethrow(appError);
end

app = struct( ...
    "UIFigure", uiFigure, ...
    "IncidentOutputAxes", incidentOutputAxes, ...
    "PrePostAxes", prePostAxes, ...
    "EffectiveBinsAxes", effectiveBinsAxes, ...
    "ResponseHeatmapAxes", responseHeatmapAxes, ...
    "ResponseProfileAxes", responseProfileAxes, ...
    "MaterialDropdown", materialDropdown, ...
    "MaterialTypeDropdown", materialTypeDropdown, ...
    "KVDropdown", kVDropdown, ...
    "ThicknessSpinner", thicknessSpinner, ...
    "LowThresholdSpinner", lowThresholdSpinner, ...
    "SplitThresholdSpinner", splitThresholdSpinner, ...
    "ProfileEnergySpinners", {profileEnergySpinners}, ...
    "ExportDPISpinner", exportDPISpinner, ...
    "OutputsGrid", outputsGrid, ...
    "IncidentOutputCheckbox", incidentOutputCheckbox, ...
    "EffectiveBinsCheckbox", effectiveBinsCheckbox, ...
    "PrePostCheckbox", prePostCheckbox, ...
    "EnergyResponseCheckbox", energyResponseCheckbox, ...
    "ResetViewButton", resetViewButton, ...
    "StatisticsGrid", statisticsGrid, ...
    "StatisticsNameLabels", {statisticsNameLabels}, ...
    "StatisticsValueLabels", {statisticsValueLabels}, ...
    "StatusLabel", statusLabel, ...
    "Update", @updatePlots, ...
    "UpdateDisplayLayout", @updateDisplayLayout, ...
    "ValidateExportDPI", @getValidatedExportDPI, ...
    "ExportFigurePackage", @exportFigurePackage, ...
    "SearchAttenuator", @searchAttenuator);

    function onFigureSizeChanged(~, ~)
        updateDisplayLayout();
        updatePlotVisibility();
    end

    function onThemeChanged(~, ~)
        applyThemeTextContrast(currentFigureTheme(uiFigure));
    end

    function applyThemeTextContrast(themeStyle)
        isDarkTheme = strcmpi(string(themeStyle), "dark");
        if isDarkTheme
            energyNoteLabel.FontColor = [0.82 0.82 0.82];
        else
            energyNoteLabel.FontColor = [0.35 0.35 0.35];
        end

        for statisticIndex = 1:8
            isPrimaryStatistic = ismember(statisticIndex, [1 2 3 6]);
            if isDarkTheme
                if isPrimaryStatistic
                    fontColor = [0.02 0.02 0.02];
                else
                    fontColor = [0.12 0.12 0.12];
                end
            elseif isPrimaryStatistic
                fontColor = [0 0 0];
            else
                fontColor = [0.30 0.30 0.30];
            end
            statisticsNameLabels{statisticIndex}.FontColor = fontColor;
            statisticsValueLabels{statisticIndex}.FontColor = fontColor;
        end

        legendHandles = findall(uiFigure, "Type", "legend");
        for legendIndex = 1:numel(legendHandles)
            if isDarkTheme
                legendHandles(legendIndex).TextColor = [0.05 0.05 0.05];
            elseif isprop(legendHandles(legendIndex), "TextColorMode")
                legendHandles(legendIndex).TextColorMode = "auto";
            else
                legendHandles(legendIndex).TextColor = [0.15 0.15 0.15];
            end
            if isprop(legendHandles(legendIndex), "Title")
                updatePlotTextContrast(legendHandles(legendIndex).Title, ...
                    isDarkTheme);
            end
        end

        axesHandles = findall(uiFigure, "Type", "axes");
        for axesIndex = 1:numel(axesHandles)
            updateAxesTextContrast(axesHandles(axesIndex), isDarkTheme);
        end

        colorbarHandles = findall(uiFigure, "Type", "colorbar");
        for colorbarIndex = 1:numel(colorbarHandles)
            updateColorbarTextContrast(colorbarHandles(colorbarIndex), ...
                isDarkTheme);
        end
    end

    function columnCount = updateDisplayLayout()
        rootPanel.Position = [ ...
            1, 1, uiFigure.Position(3), uiFigure.Position(4)];
        columnCount = 4;
        if uiFigure.Position(3) < 900
            visualizationHeaderHeight = 44;
        else
            visualizationHeaderHeight = 24;
        end
        plotRows = plotLayout.RowHeight;
        plotRows{1} = visualizationHeaderHeight;
        plotLayout.RowHeight = plotRows;
        profileGrid.UserData = columnCount;
        outputsGrid.UserData = 1;
    end

    function updatePlotVisibility()
        plotLayout.RowHeight = {
            visualizationHeaderHeight
            340 * prePostCheckbox.Value
            340 * incidentOutputCheckbox.Value
            340 * effectiveBinsCheckbox.Value
            430 * energyResponseCheckbox.Value
        };
        prePostAxes.Visible = onOff(prePostCheckbox.Value);
        incidentOutputAxes.Visible = onOff( ...
            incidentOutputCheckbox.Value);
        effectiveBinsAxes.Visible = onOff(effectiveBinsCheckbox.Value);
        energyResponseLayout.Visible = onOff( ...
            energyResponseCheckbox.Value);
    end

    function onMaterialTypeChanged(~, ~)
        previousKey = selectedMaterialKey;
        searchMessage = "";
        refreshMaterialItems("", previousKey);
        updatePlots();
    end

    function onMaterialSelectionChanged(~, ~)
        enteredValue = strtrim(string(materialDropdown.Value));
        selectedIndex = find( ...
            currentMaterialLabels == enteredValue, 1, "first");
        if ~isempty(selectedIndex)
            selectedMaterialKey = currentMaterialKeys(selectedIndex);
            searchMessage = "";
            updatePlots();
            return
        end

        searchAttenuator(enteredValue);
    end

    function matchedKeys = searchAttenuator(query)
        query = strtrim(string(query));
        previousKey = selectedMaterialKey;
        [matchedLabels, matchedKeys] = findMaterialMatches(query);

        if isempty(matchedKeys)
            searchMessage = "";
            refreshMaterialItems("", previousKey);
            statusLabel.FontColor = [0.70 0.10 0.10];
            statusLabel.Text = sprintf( ...
                'No attenuator matches "%s".', query);
            return
        end

        currentMaterialLabels = matchedLabels;
        currentMaterialKeys = matchedKeys;
        materialDropdown.Items = matchedLabels';
        materialDropdown.Value = matchedLabels(1);
        selectedMaterialKey = matchedKeys(1);
        if strlength(query) > 0
            searchMessage = sprintf( ...
                'Search "%s": %d match(es)', query, numel(matchedKeys));
        else
            searchMessage = "";
        end
        updatePlots(false);
    end

    function refreshMaterialItems(query, preferredKey)
        if nargin < 1
            query = "";
        end
        if nargin < 2
            preferredKey = selectedMaterialKey;
        end

        [matchedLabels, matchedKeys] = findMaterialMatches(query);
        if isempty(matchedKeys)
            error("app:NoMaterialsAvailable", ...
                "No attenuator materials match the current filters.");
        end

        selectedIndex = find(matchedKeys == preferredKey, 1, "first");
        if isempty(selectedIndex)
            selectedIndex = 1;
        end

        currentMaterialLabels = matchedLabels;
        currentMaterialKeys = matchedKeys;
        selectedMaterialKey = matchedKeys(selectedIndex);
        materialDropdown.Items = matchedLabels';
        materialDropdown.Value = matchedLabels(selectedIndex);
    end

    function [labels, keys] = findMaterialMatches(query)
        materialTable = getMaterialTableForSelectedType();
        labels = makeMaterialLabels(materialTable);
        keys = materialTable.Type + ":" + materialTable.Key;

        query = lower(strtrim(string(query)));
        if strlength(query) == 0
            return
        end

        materialKeys = lower(materialTable.Key);
        displayNames = lower(materialTable.DisplayName);
        typeNames = lower(materialTable.Type);
        lowercaseLabels = lower(labels);

        exactMatch = query == materialKeys | ...
            query == displayNames | ...
            query == lowercaseLabels;
        prefixMatch = startsWith(materialKeys, query) | ...
            startsWith(displayNames, query);
        substringMatch = contains(materialKeys, query) | ...
            contains(displayNames, query) | ...
            contains(typeNames, query) | ...
            contains(lowercaseLabels, query);

        orderedIndices = [
            find(exactMatch)
            find(prefixMatch & ~exactMatch)
            find(substringMatch & ~prefixMatch & ~exactMatch)
        ];
        labels = labels(orderedIndices);
        keys = keys(orderedIndices);
    end

    function materialTable = getMaterialTableForSelectedType()
        selectedType = string(materialTypeDropdown.Value);
        switch selectedType
            case "Elements"
                materialTable = listAttenuatorMaterials("element");
            case "Compounds"
                materialTable = listAttenuatorMaterials("compound");
            otherwise
                materialTable = listAttenuatorMaterials("all");
        end
    end

    function labels = makeMaterialLabels(materialTable)
        labels = strings(height(materialTable), 1);
        for rowIndex = 1:height(materialTable)
            if materialTable.Type(rowIndex) == "element"
                labels(rowIndex) = sprintf("%s — %s [Element]", ...
                    materialTable.Key(rowIndex), ...
                    materialTable.DisplayName(rowIndex));
            else
                labels(rowIndex) = sprintf("%s [Compound]", ...
                    materialTable.DisplayName(rowIndex));
            end
        end
    end

    function onUpdate(~, ~)
        updatePlotVisibility();
        updatePlots(false);
    end

    function onResetFigureViews(~, ~)
        updatePlots(false);
        statusLabel.FontColor = [0.10 0.35 0.20];
        statusLabel.Text = "Figure views reset.";
    end

    function onProfileEnergyChanged(~, ~)
        candidateEnergies = cellfun( ...
            @(spinner) spinner.Value, profileEnergySpinners);
        if numel(unique(candidateEnergies)) ~= 4
            setProfileEnergyValues( ...
                profileEnergySpinners, profileEnergies);
            statusLabel.FontColor = [0.70 0.10 0.10];
            statusLabel.Text = ...
                "Monoenergetic input energies must be four unique integers.";
            return
        end
        profileEnergies = candidateEnergies;
        updatePlots(false);
    end

    function onHeatmapEnergySelected(selectedEnergy)
        if any(profileEnergies == selectedEnergy)
            return
        end
        [~, replacementIndex] = min( ...
            abs(profileEnergies - selectedEnergy));
        profileEnergies(replacementIndex) = selectedEnergy;
        setProfileEnergyValues(profileEnergySpinners, profileEnergies);
        updatePlots(false);
    end

    function onTubeVoltageChanged(~, ~)
        [lowerThreshold, splitThreshold] = ...
            thresholdPreset(kVDropdown.Value);
        lowThresholdSpinner.Value = lowerThreshold;
        splitThresholdSpinner.Value = splitThreshold;
        updatePlots(false);
    end

    function onThicknessChanging(source, event)
        source.Value = event.Value;
        updatePlots(false);
    end

    function updatePlots(rethrowErrors)
        if nargin < 1
            rethrowErrors = false;
        end
        try
            lowerThreshold = lowThresholdSpinner.Value;
            splitThreshold = splitThresholdSpinner.Value;
            if lowerThreshold >= splitThreshold
                error("app:InvalidThresholds", ...
                    "The low energy threshold must be below the high threshold.");
            end

            separatorIndex = strfind(selectedMaterialKey, ":");
            materialType = extractBefore( ...
                selectedMaterialKey, separatorIndex(1));
            materialKey = extractAfter( ...
                selectedMaterialKey, separatorIndex(1));

            result = runSpectrumAnalysis( ...
                kVDropdown.Value, ...
                materialKey, ...
                thicknessSpinner.Value, ...
                "MaterialType", materialType, ...
                "LowThresholdKeV", lowerThreshold, ...
                "SplitThresholdKeV", splitThreshold, ...
                "HighThresholdKeV", 150);

            updatePlotVisibility();
            plotSpectrumAnalysis(result, ...
                "IncidentOutputAxes", incidentOutputAxes, ...
                "PrePostAxes", prePostAxes, ...
                "EffectiveBinsAxes", effectiveBinsAxes, ...
                "ResponseHeatmapAxes", responseHeatmapAxes, ...
                "ResponseProfileAxes", responseProfileAxes, ...
                "ShowIncidentOutput", incidentOutputCheckbox.Value, ...
                "ShowEffectiveBins", effectiveBinsCheckbox.Value, ...
                "ShowPrePost", prePostCheckbox.Value, ...
                "ShowEnergyResponse", energyResponseCheckbox.Value, ...
                "ProfileEnergies", profileEnergies, ...
                "ProfileSelectionCallback", ...
                    @onHeatmapEnergySelected);

            uiFigure.UserData = result;
            updateStatisticsGrid(result, statisticsValueLabels);
            applyThemeTextContrast(currentFigureTheme(uiFigure));
            statusLabel.FontColor = [0.10 0.35 0.20];
            if strlength(searchMessage) > 0
                statusLabel.Text = searchMessage;
            else
                statusLabel.Text = "Ready";
            end
        catch updateError
            statusLabel.FontColor = [0.70 0.10 0.10];
            statusLabel.Text = updateError.message;
            if rethrowErrors
                rethrow(updateError);
            end
        end
    end

    function onExport(~, ~)
        if isempty(uiFigure.UserData)
            updatePlots();
        end
        [exportDPI, isValidDPI] = getValidatedExportDPI();
        if ~isValidDPI
            return
        end
        [fileName, filePath] = uiputfile( ...
            {'*.zip', 'ZIP archive (*.zip)'}, ...
            "Export spectrum PNG package", ...
            "pcd_spectra_analysis_png.zip");
        if isequal(fileName, 0)
            return
        end

        try
            exportFigurePackage(fullfile(filePath, fileName), exportDPI);
            statusLabel.FontColor = [0.10 0.35 0.20];
            statusLabel.Text = sprintf( ...
                "PNG package exported successfully at %d DPI.", ...
                exportDPI);
        catch exportError
            statusLabel.FontColor = [0.70 0.10 0.10];
            statusLabel.Text = exportError.message;
        end
    end

    function exportFigurePackage(zipFile, exportDPI)
        [zipDir, zipName, zipExtension] = fileparts(zipFile);
        zipDir = string(zipDir);
        zipName = string(zipName);
        zipExtension = string(zipExtension);
        if zipExtension == ""
            zipExtension = ".zip";
        elseif ~strcmpi(zipExtension, ".zip")
            error("app:InvalidExportExtension", ...
                "The PNG package must use the .zip extension.");
        end
        zipFile = fullfile(zipDir, zipName + zipExtension);

        exportDir = tempname;
        mkdir(exportDir);
        directoryCleanup = onCleanup(@() removeExportDirectory(exportDir));
        exportedFiles = strings(0, 1);

        compositeName = "pcd_spectra_analysis_composite.png";
        exportOneFigure(fullfile(exportDir, compositeName), ...
            incidentOutputCheckbox.Value, ...
            effectiveBinsCheckbox.Value, ...
            prePostCheckbox.Value, ...
            energyResponseCheckbox.Value, true, exportDPI);
        exportedFiles(end + 1) = compositeName;

        if prePostCheckbox.Value
            fileName = "pre_and_post_attenuator_xray_spectra.png";
            exportOneFigure(fullfile(exportDir, fileName), ...
                false, false, true, false, false, exportDPI);
            exportedFiles(end + 1) = fileName;
        end
        if incidentOutputCheckbox.Value
            fileName = "incident_xray_vs_pcd_output_spectrum.png";
            exportOneFigure(fullfile(exportDir, fileName), ...
                true, false, false, false, false, exportDPI);
            exportedFiles(end + 1) = fileName;
        end
        if effectiveBinsCheckbox.Value
            fileName = "pcd_effective_spectra_low_high_bins.png";
            exportOneFigure(fullfile(exportDir, fileName), ...
                false, true, false, false, false, exportDPI);
            exportedFiles(end + 1) = fileName;
        end
        if energyResponseCheckbox.Value
            fileName = "pcd_energy_response_monoenergetic_xrays.png";
            exportOneFigure(fullfile(exportDir, fileName), ...
                false, false, false, true, false, exportDPI);
            exportedFiles(end + 1) = fileName;
        end

        zip(zipFile, cellstr(exportedFiles), exportDir);
        clear directoryCleanup
    end

    function exportOneFigure(outputFile, showIncidentOutput, ...
            showEffectiveBins, showPrePost, showEnergyResponse, ...
            includeEnergyNote, exportDPI)
        exportHandles = plotSpectrumAnalysis(uiFigure.UserData, ...
            "ShowIncidentOutput", showIncidentOutput, ...
            "ShowEffectiveBins", showEffectiveBins, ...
            "ShowPrePost", showPrePost, ...
            "ShowEnergyResponse", showEnergyResponse, ...
            "ProfileEnergies", profileEnergies, ...
            "IncludeEnergyNote", includeEnergyNote, ...
            "Visible", "off", ...
            "DPI", exportDPI, ...
            "OutputFile", outputFile);
        figureCleanup = onCleanup(@() close(exportHandles.Figure));
        clear figureCleanup
    end

    function [exportDPI, isValid] = getValidatedExportDPI()
        exportDPI = exportDPISpinner.Value;
        isValid = isfinite(exportDPI) && exportDPI >= 1 && ...
            exportDPI <= 1200 && exportDPI == round(exportDPI);
        if ~isValid
            statusLabel.FontColor = [0.70 0.10 0.10];
            statusLabel.Text = ...
                "Export DPI must be a whole number from 1 through 1200.";
        end
    end

    function onSave(~, ~)
        if isempty(uiFigure.UserData)
            updatePlots();
        end
        [fileName, filePath] = uiputfile( ...
            {'*.mat', 'MAT-file (*.mat)'}, ...
            "Save spectrum analysis", ...
            "pcd_spectra_analysis.mat");
        if isequal(fileName, 0)
            return
        end

        analysisResult = uiFigure.UserData;
        save(fullfile(filePath, fileName), "analysisResult", "-v7");
        statusLabel.Text = "Analysis MAT-file saved successfully.";
    end
end

function setProfileEnergyValues(profileEnergySpinners, profileEnergies)
for profileIndex = 1:4
    profileEnergySpinners{profileIndex}.Value = ...
        profileEnergies(profileIndex);
end
end

function updateStatisticsGrid(result, statisticsValueLabels)
totalBinCounts = result.lowCounts + result.highCounts;
if totalBinCounts > 0
    toPercentage = @(counts) 100 * counts / totalBinCounts;
else
    toPercentage = @(~) 0;
end
percentageStatistics = [
    100 * result.transmittedFraction
    toPercentage(result.lowCounts)
    toPercentage(result.trueLowCounts)
    toPercentage(result.misclassifiedHighCounts)
    toPercentage(result.highCounts)
    toPercentage(result.misclassifiedLowCounts)
    toPercentage(result.trueHighCounts)
];
statisticsValueLabels{1}.Text = sprintf("%.6g", result.incidentCounts);
for statisticIndex = 1:7
    statisticsValueLabels{statisticIndex + 1}.Text = ...
        sprintf("%.2f%%", percentageStatistics(statisticIndex));
end
end

function backgroundColor = statisticBackground(isPrimaryStatistic)
if isPrimaryStatistic
    backgroundColor = [0.93 0.94 0.95];
else
    backgroundColor = [0.98 0.98 0.98];
end
end

function themeStyle = currentFigureTheme(figureHandle)
themeStyle = "light";
if isprop(figureHandle, "Theme")
    themeStyle = string(figureHandle.Theme.BaseColorStyle);
end
end

function updateAxesTextContrast(axesHandle, isDarkTheme)
if isempty(axesHandle) || ~isvalid(axesHandle)
    return
end
if isDarkTheme
    axesTextColor = [0.95 0.95 0.95];
else
    axesTextColor = [0.15 0.15 0.15];
end
axesHandle.XColor = axesTextColor;
axesHandle.YColor = axesTextColor;
if isprop(axesHandle, "ZColor")
    axesHandle.ZColor = axesTextColor;
end
updatePlotTextContrast(axesHandle.Title, isDarkTheme);
updatePlotTextContrast(axesHandle.XLabel, isDarkTheme);
updatePlotTextContrast(axesHandle.YLabel, isDarkTheme);
if isprop(axesHandle, "ZLabel")
    updatePlotTextContrast(axesHandle.ZLabel, isDarkTheme);
end
if isprop(axesHandle, "Subtitle")
    updatePlotTextContrast(axesHandle.Subtitle, isDarkTheme);
end
end

function updateColorbarTextContrast(colorbarHandle, isDarkTheme)
if isempty(colorbarHandle) || ~isvalid(colorbarHandle)
    return
end
if isDarkTheme
    colorbarHandle.Color = [0.95 0.95 0.95];
elseif isprop(colorbarHandle, "ColorMode")
    colorbarHandle.ColorMode = "auto";
else
    colorbarHandle.Color = [0.15 0.15 0.15];
end
if isprop(colorbarHandle, "Label")
    updatePlotTextContrast(colorbarHandle.Label, isDarkTheme);
end
if isprop(colorbarHandle, "Title")
    updatePlotTextContrast(colorbarHandle.Title, isDarkTheme);
end
end

function updatePlotTextContrast(textHandle, isDarkTheme)
if isempty(textHandle) || ~isvalid(textHandle)
    return
end
if isDarkTheme
    textHandle.Color = [0.95 0.95 0.95];
elseif isprop(textHandle, "ColorMode")
    textHandle.ColorMode = "auto";
else
    textHandle.Color = [0.15 0.15 0.15];
end
end

function value = onOff(isOn)
if isOn
    value = "on";
else
    value = "off";
end
end

function removeExportDirectory(exportDir)
if isfolder(exportDir)
    rmdir(exportDir, "s");
end
end

function [lowerThreshold, splitThreshold] = thresholdPreset(kV)
lowerThreshold = 20;
switch kV
    case 70
        splitThreshold = 53;
    case 90
        splitThreshold = 64;
    otherwise
        splitThreshold = 68;
end
end

function labelHandle = makeLabel(layoutHandle, labelText, rowNumber)
labelHandle = uilabel(layoutHandle, ...
    "Text", labelText, ...
    "FontName", "Arial", ...
    "FontSize", 14, ...
    "FontWeight", "bold", ...
    "WordWrap", "on");
labelHandle.Layout.Row = rowNumber;
labelHandle.Layout.Column = [1 2];
end

function labelHandle = makeColumnLabel( ...
        layoutHandle, labelText, rowNumber, columnNumber)
labelHandle = uilabel(layoutHandle, ...
    "Text", labelText, ...
    "FontName", "Arial", ...
    "FontSize", 12, ...
    "FontWeight", "bold", ...
    "HorizontalAlignment", "center", ...
    "WordWrap", "on");
labelHandle.Layout.Row = rowNumber;
labelHandle.Layout.Column = columnNumber;
end

function checkboxHandle = makeCheckbox( ...
        layoutHandle, labelText, initialValue, rowNumber, columnNumber)
checkboxHandle = uicheckbox(layoutHandle, ...
    "Text", labelText, ...
    "Value", initialValue, ...
    "FontName", "Arial", ...
    "FontSize", 14, ...
    "WordWrap", "on");
checkboxHandle.Layout.Row = rowNumber;
checkboxHandle.Layout.Column = columnNumber;
end
