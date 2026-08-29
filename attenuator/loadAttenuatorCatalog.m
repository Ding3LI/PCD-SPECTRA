function catalog = loadAttenuatorCatalog()
%LOADATTENUATORCATALOG Load and validate the bundled material catalog.
%
% catalog = loadAttenuatorCatalog() returns the elemental and compound
% attenuator data stored in attenuatorCatalog.mat.

attenuatorDir = fileparts(mfilename("fullpath"));
catalogFile = fullfile(attenuatorDir, "attenuatorCatalog.mat");

if ~isfile(catalogFile)
    error("attenuator:CatalogNotFound", ...
        ["Attenuator catalog not found. Run buildAttenuatorCatalog " ...
         "from matlab_interface/attenuator first."]);
end

storedData = load(catalogFile, "catalog");
if ~isfield(storedData, "catalog") || ~isstruct(storedData.catalog)
    error("attenuator:InvalidCatalog", ...
        "attenuatorCatalog.mat does not contain a valid catalog structure.");
end

catalog = storedData.catalog;
requiredFields = ["metadata", "energy_keV", "elements", "compounds"];
if ~all(isfield(catalog, requiredFields))
    error("attenuator:InvalidCatalog", ...
        "attenuatorCatalog.mat is missing required fields.");
end

if ~isequal(catalog.energy_keV(:), (1:150)')
    error("attenuator:InvalidEnergyGrid", ...
        "The attenuator energy grid must contain 1 through 150 keV.");
end
end
