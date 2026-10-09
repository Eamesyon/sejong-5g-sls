function [sinrLinear, sinrDb, servingIndex] = calcSinr(serviceRxDbm, externalRxDbm, noiseDbm)
%CALCSINR Select the strongest service sector and sum all other interference.
% Inputs are received powers in dBm. Power summation is done in milliwatts.

if isempty(serviceRxDbm)
    error('At least one service-sector received power is required.');
end
serviceMw = 10.^(serviceRxDbm(:) / 10);
externalMw = 10.^(externalRxDbm(:) / 10);
noiseMw = 10^(noiseDbm / 10);

[signalMw, servingIndex] = max(serviceMw);
interferenceMw = sum(serviceMw) - signalMw + sum(externalMw);
sinrLinear = signalMw / (interferenceMw + noiseMw);
sinrDb = 10 * log10(sinrLinear);
end
