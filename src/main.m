%% 세종대 5G 시스템 수준 시뮬레이터 실행 파일
% MATLAB에서 이 파일을 실행합니다. 계산은 각 기능 파일에 두어 모듈별로
% 읽고 검토할 수 있게 합니다.

clear; clc; close all;

projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = projectConfig();
campus = campusData();
userXY = buildUserGrid(campus, cfg.gridSpacingM);

results = evaluateCampus(userXY, campus, cfg);

summary = summarizeResults(results.rateBps);
disp(summary);
plotResults(userXY, results.sinrDb, summary, campus);
