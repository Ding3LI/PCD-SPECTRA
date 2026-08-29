function [postObjectSpectrum, transmission] = ...
        calculatePostObjectSpectrum(incidentSpectrum, ...
        linearAttenuationMmInv, thicknessMm)
%CALCULATEPOSTOBJECTSPECTRUM Apply object attenuation with Beer's law.
%
% S_post(E) = S_incident(E) * exp(-mu(E) * thicknessMm)
%
% The incident spectrum is the pre-object spectrum. The post-object
% spectrum is also the incident spectrum at the detector entrance.
% linearAttenuationMmInv must be in 1/mm and thicknessMm must be in mm.

arguments
    incidentSpectrum (:, 1) double {mustBeNonnegative, mustBeFinite}
    linearAttenuationMmInv (:, 1) double ...
        {mustBeNonnegative, mustBeFinite}
    thicknessMm (1, 1) double {mustBeNonnegative, mustBeFinite}
end

if numel(incidentSpectrum) ~= numel(linearAttenuationMmInv)
    error("spectrum:AttenuationSizeMismatch", ...
        "Incident spectrum and attenuation vector must have equal length.");
end

transmission = exp(-linearAttenuationMmInv .* thicknessMm);
postObjectSpectrum = incidentSpectrum .* transmission;
end
