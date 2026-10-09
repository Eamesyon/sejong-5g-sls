function blocked = isBlockedByBuildings(siteXY, userXY, buildings)
%ISBLOCKEDBYBUILDINGS 링크를 따라 표본을 찍어 LOS를 근사 판정합니다.
% 건물 좌표는 [xmin xmax ymin ymax] 사각형이며 단위는 m입니다.

blocked = false;
if isempty(buildings)
    return;
end

distanceM = hypot(userXY(1) - siteXY(1), userXY(2) - siteXY(2));
nSteps = max(2, ceil(distanceM / 5));
t = (1:nSteps-1)' / nSteps; % Ignore exact link endpoints.
x = siteXY(1) + t * (userXY(1) - siteXY(1));
y = siteXY(2) + t * (userXY(2) - siteXY(2));
for k = 1:size(buildings, 1)
    b = buildings(k, :);
    if any(x >= b(1) & x <= b(2) & y >= b(3) & y <= b(4))
        blocked = true;
        return;
    end
end
end
