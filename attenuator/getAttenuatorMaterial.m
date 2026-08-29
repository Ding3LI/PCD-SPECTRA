function material = getAttenuatorMaterial(identifier, materialType)
%GETATTENUATORMATERIAL Return attenuation data for one material.
%
% material = getAttenuatorMaterial("Al") finds an element by symbol.
% material = getAttenuatorMaterial("Aluminum") finds an element by name.
% material = getAttenuatorMaterial(13) finds an element by atomic number.
% material = getAttenuatorMaterial("Water") finds a compound by name.
% material = getAttenuatorMaterial(identifier, materialType) restricts the
% lookup to "element", "compound", or uses "auto" to search both.

arguments
    identifier {mustBeValidIdentifierType}
    materialType (1, 1) string {mustBeMember(materialType, ...
        ["auto", "element", "compound"])} = "auto"
end

catalog = loadAttenuatorCatalog();

if isnumeric(identifier)
    if materialType == "compound"
        error("attenuator:NumericCompoundIdentifier", ...
            "Numeric identifiers represent element atomic numbers only.");
    end
    material = findElementByAtomicNumber(catalog, identifier);
    return
end

identifier = strtrim(string(identifier));
if strlength(identifier) == 0
    error("attenuator:EmptyIdentifier", ...
        "The material identifier cannot be empty.");
end

if materialType == "auto" || materialType == "element"
    [material, found] = findElementByName(catalog, identifier);
    if found
        return
    end
end

if materialType == "auto" || materialType == "compound"
    [material, found] = findCompoundByName(catalog, identifier);
    if found
        return
    end
end

error("attenuator:MaterialNotFound", ...
    "No %s attenuator material matched '%s'.", materialType, identifier);
end

function material = findElementByAtomicNumber(catalog, atomicNumber)
if ~isscalar(atomicNumber) || ~isfinite(atomicNumber) || ...
        atomicNumber ~= fix(atomicNumber) || atomicNumber < 1 || ...
        atomicNumber > catalog.metadata.elementCount
    error("attenuator:InvalidAtomicNumber", ...
        "Element atomic number must be an integer from 1 through %d.", ...
        catalog.metadata.elementCount);
end

material = makeElement(catalog, atomicNumber);
end

function [material, found] = findElementByName(catalog, identifier)
symbols = string(catalog.elements.symbols);
displayNames = string(catalog.elements.displayNames);
elementIndex = find( ...
    strcmpi(identifier, symbols) | strcmpi(identifier, displayNames), ...
    1, "first");
found = ~isempty(elementIndex);

if found
    material = makeElement(catalog, elementIndex);
else
    material = struct();
end
end

function [material, found] = findCompoundByName(catalog, identifier)
compoundNames = string(catalog.compounds.names);
compoundIndex = find(strcmpi(identifier, compoundNames), 1, "first");
found = ~isempty(compoundIndex);

if found
    material = makeCompound(catalog, compoundIndex);
else
    material = struct();
end
end

function material = makeElement(catalog, elementIndex)
material = struct( ...
    "type", "element", ...
    "index", elementIndex, ...
    "key", string(catalog.elements.symbols{elementIndex}), ...
    "displayName", string(catalog.elements.displayNames{elementIndex}), ...
    "atomicNumber", catalog.elements.atomicNumbers(elementIndex), ...
    "atomicMass_g_mol", catalog.elements.atomicMass_g_mol(elementIndex), ...
    "density_g_cm3", catalog.elements.density_g_cm3(elementIndex), ...
    "energy_keV", catalog.energy_keV, ...
    "massAttenuation_cm2_g", ...
        catalog.elements.massAttenuation_cm2_g(:, elementIndex), ...
    "linearAttenuation_mm_inv", ...
        catalog.elements.linearAttenuation_mm_inv(:, elementIndex));
end

function material = makeCompound(catalog, compoundIndex)
materialName = string(catalog.compounds.names{compoundIndex});
material = struct( ...
    "type", "compound", ...
    "index", compoundIndex, ...
    "key", materialName, ...
    "displayName", materialName, ...
    "atomicNumber", nan, ...
    "atomicMass_g_mol", nan, ...
    "density_g_cm3", catalog.compounds.density_g_cm3(compoundIndex), ...
    "energy_keV", catalog.energy_keV, ...
    "massAttenuation_cm2_g", ...
        catalog.compounds.massAttenuation_cm2_g(:, compoundIndex), ...
    "linearAttenuation_mm_inv", ...
        catalog.compounds.linearAttenuation_mm_inv(:, compoundIndex));
end

function mustBeValidIdentifierType(identifier)
if ~(isstring(identifier) || ischar(identifier) || ...
        (isnumeric(identifier) && isscalar(identifier)))
    error("attenuator:InvalidIdentifierType", ...
        "Material identifier must be text or a scalar atomic number.");
end
end
