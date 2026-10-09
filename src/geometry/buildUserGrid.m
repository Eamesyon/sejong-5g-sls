function userXY = buildUserGrid(campus, spacingM)
%BUILDUSERGRID Generate unique [x y] evaluation points inside campus regions.
% campus.evalRegions rows use [xmin xmax ymin ymax], all in meters.

if spacingM <= 0
    error('Grid spacing must be greater than zero meters.');
end
if isempty(campus.evalRegions) || size(campus.evalRegions, 2) ~= 4
    error('campus.evalRegions must be a non-empty N-by-4 rectangle array.');
end

userXY = zeros(0, 2);
for k = 1:size(campus.evalRegions, 1)
    box = campus.evalRegions(k, :);
    x = box(1):spacingM:box(2);
    y = box(3):spacingM:box(4);
    [X, Y] = meshgrid(x, y);
    userXY = [userXY; X(:), Y(:)]; %#ok<AGROW>
end

% Adjacent/overlapping rectangles must not count the same user twice.
userXY = unique(userXY, 'rows', 'stable');

% TODO: Exclude points outside the actual campus polygon if evalRegions are
% only rectangular approximations of a non-rectangular campus boundary.
end
