function noiseDbm = calcNoisePower(bandwidthHz, noiseFigureDb)
%CALCNOISEPOWER 채널 대역폭 전체의 열잡음을 dBm으로 계산합니다.
% -174 dBm/Hz는 실온에서 사용하는 대표 열잡음 전력 밀도입니다.

validateattributes(bandwidthHz, {'numeric'}, {'scalar', 'positive', 'finite'}, ...
    mfilename, '대역폭(Hz)');
validateattributes(noiseFigureDb, {'numeric'}, {'scalar', 'finite'}, ...
    mfilename, '잡음지수(dB)');
noiseDbm = -174 + 10 * log10(bandwidthHz) + noiseFigureDb;
end
