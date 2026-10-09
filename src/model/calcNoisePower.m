function noiseDbm = calcNoisePower(bandwidthHz, noiseFigureDb)
%CALCNOISEPOWER Thermal noise over the full channel bandwidth, in dBm.
% -174 dBm/Hz is the nominal thermal noise density at room temperature.

validateattributes(bandwidthHz, {'numeric'}, {'scalar', 'positive', 'finite'});
validateattributes(noiseFigureDb, {'numeric'}, {'scalar', 'finite'});
noiseDbm = -174 + 10 * log10(bandwidthHz) + noiseFigureDb;
end
