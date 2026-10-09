function [sinrLinear, sinrDb, servingIndex] = calcSinr(serviceRxDbm, externalRxDbm, noiseDbm)
%CALCSINR 가장 강한 서빙 섹터를 선택하고 나머지 간섭 전력을 합산합니다.
% 입력 수신전력은 dBm입니다. 전력 합산은 mW 선형값으로 계산합니다.

if isempty(serviceRxDbm)
    error('서비스 섹터의 수신전력을 하나 이상 입력해야 합니다.');
end
serviceMw = 10.^(serviceRxDbm(:) / 10);
externalMw = 10.^(externalRxDbm(:) / 10);
noiseMw = 10^(noiseDbm / 10);

[signalMw, servingIndex] = max(serviceMw);
interferenceMw = sum(serviceMw) - signalMw + sum(externalMw);
sinrLinear = signalMw / (interferenceMw + noiseMw);
sinrDb = 10 * log10(sinrLinear);
end
