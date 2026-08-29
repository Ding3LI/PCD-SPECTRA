function version = PCDSPECTRAVersion()
%PCDSPECTRAVERSION Return the release version from the repository VERSION file.

toolboxRoot = fileparts(mfilename("fullpath"));
versionFile = fullfile(toolboxRoot, "VERSION");
if ~isfile(versionFile)
    error("PCDSPECTRA:VersionFileNotFound", ...
        "The PCD-SPECTRA VERSION file was not found: %s", versionFile);
end

version = string(strtrim(fileread(versionFile)));
if isempty(regexp(version, "^[0-9]+[.][0-9]+[.][0-9]+$", "once"))
    error("PCDSPECTRA:InvalidVersion", ...
        "VERSION must contain a semantic version in major.minor.patch format.");
end
end
