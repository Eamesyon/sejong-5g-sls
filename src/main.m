%% Sejong 5G SLS project entry point
% Run this script from MATLAB. Keep the sequence short and move calculations
% into functions so each module can be reviewed on its own.

clear; clc; close all;

projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = projectConfig();
campus = campusData();
userXY = buildUserGrid(campus, cfg.gridSpacingM);

% TODO: Connect the campus links to calcPathlossUMa, calcSinr, and calcRate.
% This step needs surveyed Sejong sites plus the team's agreed LOS/NLOS and
% O2I assumptions. It intentionally errors until those inputs are available.
results = evaluateCampus(userXY, campus, cfg);

summary = summarizeResults(results.rateBps);
disp(summary);
plotResults(userXY, results.sinrDb, summary, campus);
