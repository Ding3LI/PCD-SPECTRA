function responseColormap = loadAlphaEnergyColormap(colormapFile)
%LOADALPHAENERGYCOLORMAP Load the supplied alpha-response RGB colormap.

arguments
    colormapFile (1, 1) string = defaultColormapFile()
end

if ~isfile(colormapFile)
    error("spectrum:ColormapFileNotFound", ...
        "Alpha energy-response colormap was not found: %s", ...
        colormapFile);
end

stored = load(colormapFile);
if ~isfield(stored, "cmap")
    error("spectrum:InvalidColormapFile", ...
        "Alpha energy-response colormap must contain a variable named cmap.");
end

responseColormap = stored.cmap;
if ~isnumeric(responseColormap) || size(responseColormap, 2) ~= 3 || ...
        size(responseColormap, 1) < 2 || ...
        any(~isfinite(responseColormap), "all") || ...
        any(responseColormap < 0 | responseColormap > 1, "all")
    error("spectrum:InvalidColormap", ...
        "cmap must be a finite N-by-3 RGB array with values from 0 to 1.");
end
end

function colormapFile = defaultColormapFile()
utilsDir = fileparts(mfilename("fullpath"));
interfaceDir = fileparts(utilsDir);
colormapFile = fullfile( ...
    interfaceDir, "energy_response", "Colormap.mat");
end
