function results = evaluateCampus(userXY, campus, cfg)
%EVALUATECAMPUS Orchestrates link evaluation for all user locations.
% TODO: Implement after agreeing on sector azimuth, LOS/NLOS, O2I, and
% per-link shadow-fading inputs. Keeping this boundary explicit prevents a
% placeholder propagation model from being mistaken for a result.

if size(userXY, 2) ~= 2
    error('userXY must be an N-by-2 array of [x y] locations in meters.');
end
% Touch inputs to make the intended interface clear to MATLAB and readers.
if ~isstruct(campus) || ~isstruct(cfg)
    error('campus and cfg must be structs from campusData and projectConfig.');
end
error(['evaluateCampus is an integration point, not yet implemented. ' ...
    'First enter surveyed Sejong geometry and agree on link-state/O2I rules.']);
results = struct(); %#ok<UNRCH>
end
