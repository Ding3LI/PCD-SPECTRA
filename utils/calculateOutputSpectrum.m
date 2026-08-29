function outputSpectrum = calculateOutputSpectrum( ...
        postObjectSpectrum, responseMatrix)
%CALCULATEOUTPUTSPECTRUM Apply the detector energy-response matrix.
%
% responseMatrix(inputEnergy, detectedEnergy) is weighted by the
% post-object spectrum, which is incident on the detector:
%
% S_output(E_detected) =
%     sum_Einput R(E_input, E_detected) * S_post(E_input)
%
% This definition matches LyFilterWithPCDEnergyResponse.m.

arguments
    postObjectSpectrum (:, 1) double {mustBeNonnegative, mustBeFinite}
    responseMatrix (:, :) double {mustBeNonnegative, mustBeFinite}
end

if size(responseMatrix, 1) ~= numel(postObjectSpectrum)
    error("spectrum:ResponseSizeMismatch", ...
        "Response rows must match the post-object spectrum energy bins.");
end

outputSpectrum = responseMatrix' * postObjectSpectrum;
end
