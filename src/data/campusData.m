function campus = campusData()
%CAMPUSDATA Sejong campus geometry and surveyed base-station coordinates.
% Replace the empty fields using one meter-based coordinate system. Do not
% copy the Soonchunhyang coordinates from legacy/Campus_original.m.

campus.coordinateOrigin = "TODO: describe map origin and axis directions";
campus.coordinateSource = "TODO: map / survey source and access date";

% Each row is [xmin xmax ymin ymax], in meters.
campus.evalRegions = zeros(0, 4);
campus.buildings = zeros(0, 4);

% Each row is [x_m y_m azimuth_deg]. Use one row per site; sector azimuth
% convention and height are supplied through projectConfig / model setup.
campus.serviceSites = zeros(0, 3);
campus.interferenceSites = zeros(0, 3);
campus.proposedSites = zeros(0, 3);

if isempty(campus.evalRegions) || isempty(campus.serviceSites)
    error(['Complete src/data/campusData.m with Sejong evaluation regions ' ...
        'and service-site coordinates before running a simulation.']);
end
end
