function gainDb = calcSectorGain(bearingDeg, boresightDeg, beamwidthDeg, maxAttenuationDb)
%CALCSECTORGAIN Simple horizontal sector attenuation in dB.
% Vertical antenna pattern and downtilt are omitted in this starter model.

deltaDeg = mod(bearingDeg - boresightDeg + 180, 360) - 180;
gainDb = -min(12 * (deltaDeg / beamwidthDeg)^2, maxAttenuationDb);
end
