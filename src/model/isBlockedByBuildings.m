function blocked = isBlockedByBuildings(siteXY, userXY, buildings)
%ISBLOCKEDBYBUILDINGS Approximate LOS using samples along the map link.
% Buildings are [xmin xmax ymin ymax] rectangles in meters.

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
