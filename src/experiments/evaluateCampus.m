function results = evaluateCampus(userXY, campus, cfg)
%EVALUATECAMPUS 모든 사용자 위치에서 기지국 링크를 계산합니다.
% 각 사이트 행은 [x_m y_m 방위각_deg]입니다. 사이트마다 기준 방위각에서
% 0, 120, 240도 떨어진 3개 섹터를 만들며 전력 설정은 cfg에서 공유합니다.

if size(userXY, 2) ~= 2
    error('userXY는 미터 단위 [x y] 위치를 담은 N×2 배열이어야 합니다.');
end
if ~isstruct(campus) || ~isstruct(cfg)
    error('campus와 cfg는 campusData, projectConfig가 반환한 구조체여야 합니다.');
end
if isempty(campus.serviceSites)
    error('먼저 src/data/campusData.m에 조사한 서비스 기지국 좌표를 입력하세요.');
end
isIndoor = isInsideBuilding(userXY, campus.buildings);
if any(isnan(cfg.o2iLossDb)) && any(isIndoor)
    error('팀에서 실내 손실 가정을 정한 뒤 cfg.o2iLossDb를 설정하세요.');
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
% 모든 사이트의 각 섹터에서 수신되는 전력을 계산합니다.
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
% 건물은 미터 단위 [xmin xmax ymin ymax] 사각형으로 표현합니다.
indoor = false(size(userXY, 1), 1);
for k = 1:size(buildings, 1)
    b = buildings(k, :);
    indoor = indoor | (userXY(:, 1) >= b(1) & userXY(:, 1) <= b(2) ...
        & userXY(:, 2) >= b(3) & userXY(:, 2) <= b(4));
end
end
