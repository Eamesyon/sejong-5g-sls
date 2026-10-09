function userXY = buildUserGrid(campus, spacingM)
%BUILDUSERGRID 캠퍼스 평가 영역 안에 중복 없는 [x y] 위치를 만듭니다.
% campus.evalRegions의 각 행은 [xmin xmax ymin ymax]이며 단위는 m입니다.

if spacingM <= 0
    error('격자 간격은 0보다 큰 미터 값이어야 합니다.');
end
if isempty(campus.evalRegions) || size(campus.evalRegions, 2) ~= 4
    error('campus.evalRegions에는 비어 있지 않은 N×4 사각형 좌표를 입력하세요.');
end

userXY = zeros(0, 2);
for k = 1:size(campus.evalRegions, 1)
    box = campus.evalRegions(k, :);
    x = box(1):spacingM:box(2);
    y = box(3):spacingM:box(4);
    [X, Y] = meshgrid(x, y);
    userXY = [userXY; X(:), Y(:)]; %#ok<AGROW>
end

% 인접하거나 겹치는 사각형의 위치가 두 번 집계되지 않도록 중복을 제거합니다.
userXY = unique(userXY, 'rows', 'stable');

% 할 일: evalRegions가 캠퍼스 외곽을 사각형으로 근사한 값이면 실제 캠퍼스
% 경계 다각형 밖의 위치를 제외하는 처리를 추가합니다.
end
