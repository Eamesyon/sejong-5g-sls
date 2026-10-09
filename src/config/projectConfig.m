function cfg = projectConfig()
%PROJECTCONFIG 팀원과 실험이 함께 사용하는 공통 설정입니다.
% 파라미터를 여러 파일에 중복해서 적지 말고 이곳에서 관리합니다.

cfg.gridSpacingM = 5;
cfg.frequencyGHz = 3.5;
cfg.bandwidthHz = 100e6;
cfg.txPowerDbmPerSector = 43;
cfg.noiseFigureDb = 7;
cfg.bsHeightM = 25;
cfg.ueHeightM = 1.5;
cfg.o2iLossDb = NaN; % Set this after agreeing on the building/material model.
cfg.sectorBeamwidthDeg = 65;
cfg.sectorMaxAttenuationDb = 30;

% 첫 번째 비교는 주파수만 바꾸고, 두 번째 비교는 프로젝트 대역폭 조건을
% 사용합니다. 각 비교 쌍에서는 나머지 조건을 동일하게 유지합니다.
cfg.experiments.frequency = [3.5, 100e6; 28, 100e6]; % [GHz, Hz]
cfg.experiments.bandwidth = [3.5, 100e6; 28, 800e6]; % [GHz, Hz]

% 현재는 재현 가능한 고정 난수 시드를 사용합니다. Shadow fading을 추가하면
% 비교 조건마다 같은 시드와 위치별 난수 실현값을 사용합니다.
cfg.randomSeed = 2026;
end
