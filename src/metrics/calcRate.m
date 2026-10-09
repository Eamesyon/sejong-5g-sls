function rateBps = calcRate(bandwidthHz, sinrLinear)
%CALCRATE 선형 SINR을 사용해 Shannon 전송률 근사값을 bit/s로 계산합니다.

validateattributes(bandwidthHz, {'numeric'}, {'scalar', 'positive', 'finite'}, ...
    mfilename, '대역폭(Hz)');
validateattributes(sinrLinear, {'numeric'}, {'nonnegative', 'finite'});
rateBps = bandwidthHz .* log2(1 + sinrLinear);
end
