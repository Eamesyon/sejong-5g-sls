function cfg = projectConfig()
%PROJECTCONFIG Shared assumptions for all team members and experiments.
% Keep parameters here instead of copying numbers into multiple files.

cfg.gridSpacingM = 5;
cfg.txPowerDbmPerSector = 43;
cfg.noiseFigureDb = 7;
cfg.bsHeightM = 25;
cfg.ueHeightM = 1.5;

% The first two experiments isolate frequency, then compare the project
% bandwidth cases. All other settings must be shared between each pair.
cfg.experiments.frequency = [3.5, 100e6; 28, 100e6]; % [GHz, Hz]
cfg.experiments.bandwidth = [3.5, 100e6; 28, 800e6]; % [GHz, Hz]

% Start deterministic. If shadow fading is later added, share the same
% random seed/drop realizations between the paired conditions.
cfg.randomSeed = 2026;
end
