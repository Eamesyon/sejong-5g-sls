function campus = campusData()
%CAMPUSDATA 세종대 캠퍼스 건물과 조사한 기지국 좌표를 담습니다.
% 빈 항목은 미터 단위의 공통 좌표계로 채웁니다. legacy/Campus_original.m의
% 순천향대 좌표를 복사해 사용하지 마세요.

campus.coordinateOrigin = "TODO: 지도 원점과 x/y축 방향을 적으세요";
campus.coordinateSource = "TODO: 지도·조사 출처와 조사 날짜를 적으세요";

% 각 행은 [xmin xmax ymin ymax]이며 단위는 m입니다.
campus.evalRegions = zeros(0, 4);
campus.buildings = zeros(0, 4);

% 각 행은 [x_m y_m 방위각_deg]이며 기지국 사이트마다 한 행을 둡니다.
% 섹터 방위각 규칙과 높이는 projectConfig 및 모델 설정에서 지정합니다.
campus.serviceSites = zeros(0, 3);
campus.interferenceSites = zeros(0, 3);
campus.proposedSites = zeros(0, 3);

if isempty(campus.evalRegions) || isempty(campus.serviceSites)
    error(['시뮬레이션 전에 src/data/campusData.m에 세종대 평가 영역과 ' ...
        '서비스 기지국 좌표를 입력하세요.']);
end
end

