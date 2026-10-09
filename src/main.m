%% 세종대 5G 시스템 수준 시뮬레이터 실행 파일
% MATLAB에서 이 파일을 실행합니다. 계산은 각 기능 파일에 두어 모듈별로
% 읽고 검토할 수 있게 합니다.

clear; clc; close all;

projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = projectConfig();
campus = campusData();
userXY = buildUserGrid(campus, cfg.gridSpacingM);

if ~isfield(cfg.experiments, cfg.activeComparison)
    error('cfg.activeComparison은 frequency 또는 bandwidth여야 합니다.');
end
conditions = cfg.experiments.(cfg.activeComparison);
comparison = runComparison(userXY, campus, cfg, conditions);
fprintf('선택한 비교: %s\n', cfg.activeComparison);

for k = 1:numel(comparison)
    fprintf('\n조건 %d: %.1f GHz / %.0f MHz\n', k, ...
        comparison(k).frequencyGHz, comparison(k).bandwidthHz / 1e6);
    fprintf('중앙값 %.2f Mbit/s, 하위 5%% %.2f Mbit/s\n', ...
        comparison(k).summary.medianBps / 1e6, ...
        comparison(k).summary.p5Bps / 1e6);
end
plotComparison(userXY, comparison, campus);

