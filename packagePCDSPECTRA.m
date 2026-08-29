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
opts.ToolboxFiles = releaseFiles(toolboxRoot, outputFolder);
opts.ToolboxMatlabPath = {toolboxRoot, fullfile(toolboxRoot, "utils"), ...
    fullfile(toolboxRoot, "attenuator")};
opts.AppGalleryFiles = appFile;
opts.ToolboxGettingStartedGuide = guideFile;
opts.OutputFile = packageFile;

matlab.addons.toolbox.packageToolbox(opts);
fprintf("Created PCD-SPECTRA package: %s\n", packageFile);
end

function files = releaseFiles(toolboxRoot, outputFolder)
entries = dir(fullfile(toolboxRoot, "**", "*"));
entries = entries(~[entries.isdir]);
files = string(fullfile({entries.folder}, {entries.name}));
isHiddenMetadata = endsWith(files, ".DS_Store");
isPackage = endsWith(lower(files), ".mltbx");
isReleaseOutput = startsWith(files, string(outputFolder));
files = files(~(isHiddenMetadata | isPackage | isReleaseOutput));
end
