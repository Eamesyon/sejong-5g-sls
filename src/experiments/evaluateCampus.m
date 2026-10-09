function results = evaluateCampus(userXY, campus, cfg)
%EVALUATECAMPUS Orchestrates link evaluation for all user locations.
% Each site row is [x_m y_m azimuth_deg]. Three sectors are created at
% azimuth offsets 0, 120, and 240 degrees. Site and sector power assumptions
% are shared through cfg.

if size(userXY, 2) ~= 2
    error('userXY must be an N-by-2 array of [x y] locations in meters.');
end
if ~isstruct(campus) || ~isstruct(cfg)
    error('campus and cfg must be structs from campusData and projectConfig.');
end
if isempty(campus.serviceSites)
    error('Add surveyed service sites to src/data/campusData.m first.');
end
isIndoor = isInsideBuilding(userXY, campus.buildings);
if any(isnan(cfg.o2iLossDb)) && any(isIndoor)
    error('Set cfg.o2iLossDb after the team agrees on its indoor-loss assumption.');
end

noiseDbm = calcNoisePower(cfg.bandwidthHz, cfg.noiseFigureDb);
nUsers = size(userXY, 1);
sinrLinear = zeros(nUsers, 1);
sinrDb = zeros(nUsers, 1);
rateBps = zeros(nUsers, 1);
for userIndex = 1:nUsers
    user = userXY(userIndex, :);
    serviceRxDbm = siteSectorPowers(user, campus.serviceSites, campus, cfg, isIndoor(userIndex));
    externalRxDbm = siteSectorPowers(user, campus.interferenceSites, campus, cfg, isIndoor(userIndex));
    [sinrLinear(userIndex), sinrDb(userIndex)] = calcSinr(serviceRxDbm, externalRxDbm, noiseDbm);
    rateBps(userIndex) = calcRate(cfg.bandwidthHz, sinrLinear(userIndex));
end

results.userXY = userXY;
results.sinrLinear = sinrLinear;
results.sinrDb = sinrDb;
results.rateBps = rateBps;
results.isIndoor = isIndoor;
results.noiseDbm = noiseDbm;
end

function rxDbm = siteSectorPowers(userXY, sites, campus, cfg, userIsIndoor)
% Calculate received power from every sector at every site.
rxDbm = zeros(0, 1);
sectorOffsetsDeg = [0, 120, 240];
for siteIndex = 1:size(sites, 1)
    siteXY = sites(siteIndex, 1:2);
    d2dM = hypot(userXY(1) - siteXY(1), userXY(2) - siteXY(2));
    d3dM = hypot(d2dM, cfg.bsHeightM - cfg.ueHeightM);
    blocked = isBlockedByBuildings(siteXY, userXY, campus.buildings);
    pathlossDb = calcPathlossUMa(d2dM, d3dM, cfg.frequencyGHz, ...
        cfg.bsHeightM, cfg.ueHeightM, ~blocked);
    indoorLossDb = 0;
    if userIsIndoor
        indoorLossDb = cfg.o2iLossDb;
    end

    bearingDeg = atan2d(userXY(2) - siteXY(2), userXY(1) - siteXY(1));
    baseAzimuthDeg = sites(siteIndex, 3);
    for sectorIndex = 1:3
        boresightDeg = baseAzimuthDeg + sectorOffsetsDeg(sectorIndex);
        antennaGainDb = calcSectorGain(bearingDeg, boresightDeg, ...
            cfg.sectorBeamwidthDeg, cfg.sectorMaxAttenuationDb);
        rxDbm(end + 1, 1) = cfg.txPowerDbmPerSector + antennaGainDb ...
            - pathlossDb - indoorLossDb; %#ok<AGROW>
    end
end
end

function indoor = isInsideBuilding(userXY, buildings)
% Buildings use [xmin xmax ymin ymax] rectangles in meters.
indoor = false(size(userXY, 1), 1);
for k = 1:size(buildings, 1)
    b = buildings(k, :);
    indoor = indoor | (userXY(:, 1) >= b(1) & userXY(:, 1) <= b(2) ...
        & userXY(:, 2) >= b(3) & userXY(:, 2) <= b(4));
end
end
