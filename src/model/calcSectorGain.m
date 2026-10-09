function gainDb = calcSectorGain(bearingDeg, boresightDeg, beamwidthDeg, maxAttenuationDb)
%CALCSECTORGAIN 수평 방향 섹터 안테나 감쇠를 dB로 계산합니다.
% 현재 기본 모델은 수직 안테나 패턴과 기계·전기적 다운틸트를 생략합니다.

deltaDeg = mod(bearingDeg - boresightDeg + 180, 360) - 180;
gainDb = -min(12 * (deltaDeg / beamwidthDeg)^2, maxAttenuationDb);
end
