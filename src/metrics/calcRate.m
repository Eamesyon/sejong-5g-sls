function rateBps = calcRate(bandwidthHz, sinrLinear)
%CALCRATE Shannon capacity estimate in bit/s using linear SINR.

validateattributes(bandwidthHz, {'numeric'}, {'scalar', 'positive', 'finite'});
validateattributes(sinrLinear, {'numeric'}, {'nonnegative', 'finite'});
rateBps = bandwidthHz .* log2(1 + sinrLinear);
end
