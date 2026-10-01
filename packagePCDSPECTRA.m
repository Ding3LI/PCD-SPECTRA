function packageFile = packagePCDSPECTRA(options)
%PACKAGEPCDSPECTRA Validate and package the PCD-SPECTRA MATLAB add-on.
%
%   packageFile = packagePCDSPECTRA() validates the release and creates the
%   versioned .mltbx file in deployment/release. Set Package=false to
%   run the release-readiness checks without creating a package.

arguments
    options.OutputFolder (1, 1) string = ""
    options.Package (1, 1) logical = true
end

toolboxRoot = fileparts(mfilename("fullpath"));
deploymentDir = fullfile(toolboxRoot, "deployment");
guideFile = fullfile(toolboxRoot, "doc", "GettingStarted.m");
appFile = fullfile(toolboxRoot, "runPCDSPECTRA.m");
metadataFile = fullfile(deploymentDir, "PCDSPECTRAReleaseMetadata.m");
releaseVersion = PCDSPECTRAVersion();

mustExist = [ ...
    appFile
    guideFile
    metadataFile
    fullfile(toolboxRoot, "LICENSE.md")
    fullfile(toolboxRoot, "NOTICE.md")
    fullfile(deploymentDir, "CITATION.md")
    fullfile(deploymentDir, "THIRD_PARTY_NOTICES.md")
    fullfile(deploymentDir, "MATLAB_CENTRAL_LISTING.md")];
assert(all(isfile(mustExist)), "PCDSPECTRA:IncompleteRelease", ...
    "Required PCD-SPECTRA release files are missing.");

addpath(deploymentDir);
metadata = PCDSPECTRAReleaseMetadata();

if strlength(options.OutputFolder) == 0
    outputFolder = fullfile(deploymentDir, "release");
else
    outputFolder = options.OutputFolder;
end
productionFiles = releaseFiles(toolboxRoot, outputFolder);
validateProductionRelease(toolboxRoot, metadata, productionFiles, releaseVersion);

packageFile = fullfile( ...
    outputFolder, "PCD-SPECTRA_" + releaseVersion + ".mltbx");
if ~options.Package
    fprintf("PCD-SPECTRA release validation passed. No package was created.\n");
    return
end

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

assert(exist("matlab.addons.toolbox.ToolboxOptions", "class") == 8, ...
    "PCDSPECTRA:ToolboxPackagingUnavailable", ...
    "PCD-SPECTRA packaging requires MATLAB R2023a or a newer release.");

opts = matlab.addons.toolbox.ToolboxOptions(toolboxRoot, ...
    "e3b24598-2d66-4d0a-8b9e-47c8ee5067aa");
opts.ToolboxName = "PCD-SPECTRA";
opts.ToolboxVersion = releaseVersion;
opts.Summary = "Photon-counting detector spectral response analysis.";
opts.Description = ...
    "PCD-SPECTRA provides interactive X-ray spectrum, attenuation, " + ...
    "detector-response, and energy-bin analysis for research use.";
opts.AuthorName = metadata.AuthorName;
opts.AuthorEmail = metadata.AuthorEmail;
opts.AuthorCompany = metadata.AuthorCompany;
if strlength(metadata.ToolboxImageFile) > 0
    iconFile = fullfile(toolboxRoot, metadata.ToolboxImageFile);
    assert(isfile(iconFile), "PCDSPECTRA:MissingToolboxImage", ...
        "The configured toolbox image file does not exist.");
    opts.ToolboxImageFile = iconFile;
end
opts.MinimumMatlabRelease = "R2020a";
opts.MaximumMatlabRelease = "";
opts.SupportedPlatforms.Win64 = true;
opts.SupportedPlatforms.Mac = true;
opts.SupportedPlatforms.Glnxa64 = true;
opts.SupportedPlatforms.MatlabOnline = true;
opts.ToolboxFiles = productionFiles;
opts.ToolboxMatlabPath = {toolboxRoot, fullfile(toolboxRoot, "utils"), ...
    fullfile(toolboxRoot, "attenuator")};
opts.AppGalleryFiles = appFile;
opts.ToolboxGettingStartedGuide = guideFile;
opts.OutputFile = packageFile;

matlab.addons.toolbox.packageToolbox(opts);
fprintf("Created PCD-SPECTRA package: %s\n", packageFile);
end

function files = releaseFiles(toolboxRoot, outputFolder)
% Include production assets only, regardless of local peer-review files.
rootFiles = ["runPCDSPECTRA.m", "launchPCDSPECTRAApp.m", ...
    "PCDSPECTRAApp.m", "PCDSPECTRAVersion.m", "packagePCDSPECTRA.m", ...
    "VERSION", "README.md", "CITATION.cff", "LICENSE.md", "NOTICE.md"];
assetFolders = ["utils", "attenuator", "incident_spectra", ...
    "energy_response", "icons", "doc"];
deploymentFiles = ["PCDSPECTRAReleaseMetadata.m", "CITATION.md", ...
    "THIRD_PARTY_NOTICES.md", "MATLAB_CENTRAL_LISTING.md", ...
    "DEPLOYMENT_GUIDE.md", "PUBLIC_FILE_EXCHANGE_PUBLISHING.md"];
files = fullfile(string(toolboxRoot), rootFiles(:));
for folder = assetFolders
    entries = dir(fullfile(toolboxRoot, folder, "**", "*"));
    entries = entries(~[entries.isdir]);
    assetFiles = string(fullfile({entries.folder}, {entries.name}))';
    [~, names, extensions] = fileparts(assetFiles);
    isHidden = startsWith(names, ".");
    isAnonymous = contains(lower(names), "anonymous") | ...
        contains(lower(names), "anonymized");
    allowedExtension = ismember(lower(extensions), ...
        [".m", ".md", ".mat", ".txt", ".png", ".svg"]);
    files = [files; assetFiles(~isHidden & ~isAnonymous & allowedExtension)]; %#ok<AGROW>
end
files = [files; fullfile(string(toolboxRoot), "deployment", ...
    deploymentFiles(:))];
isOutput = startsWith(files, string(outputFolder) + filesep);
files = unique(files(~isOutput));
assert(all(isfile(files)), "PCDSPECTRA:IncompleteRelease", ...
    "A production release asset is missing.");
end

function validateProductionRelease(toolboxRoot, metadata, files, releaseVersion)
assert(all(strlength([metadata.AuthorName, metadata.AuthorEmail, ...
    metadata.AuthorCompany, metadata.CopyrightHolder]) > 0), ...
    "PCDSPECTRA:IncompleteMetadata", "Public release metadata is incomplete.");
assert(strlength(metadata.ToolboxImageFile) > 0 && ...
    isfile(fullfile(toolboxRoot, metadata.ToolboxImageFile)), ...
    "PCDSPECTRA:MissingToolboxImage", "The production toolbox icon is missing.");
citation = string(fileread(fullfile(toolboxRoot, "CITATION.cff")));
assert(contains(citation, "version: " + releaseVersion + newline), ...
    "PCDSPECTRA:CitationVersionMismatch", "CITATION.cff must match VERSION.");
for file = files'
    [~, ~, extension] = fileparts(file);
    if ismember(extension, [".m", ".md", ".cff"]) && ...
            file ~= fullfile(toolboxRoot, "packagePCDSPECTRA.m")
        content = fileread(file);
        unfinished = regexpi(content, ...
            "\[In Progress\]|\bTODO\b|\bFIXME\b|\bTBD\b|manuscript under review|redacted for (anonymous )?peer review", ...
            "once");
        assert(isempty(unfinished), "PCDSPECTRA:UnfinishedRelease", ...
            "Unfinished release text found in %s.", file);
    end
end
addpath(fullfile(toolboxRoot, "utils"), fullfile(toolboxRoot, "attenuator"));
loadAlphaEnergyResponse();
loadAlphaEnergyColormap();
loadAttenuatorCatalog();
for kV = [70 90 120 140]
    loadIncidentSpectrum(kV);
end
end
