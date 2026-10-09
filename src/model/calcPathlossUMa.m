function pathlossDb = calcPathlossUMa(d2dM, d3dM, fcGHz, hBsM, hUeM, isLos)
%CALCPATHLOSSUMA 3GPP TR 38.901 UMa LOS/NLOS large-scale path loss.
% Inputs: distances in m, frequency in GHz, antenna heights in m, LOS flag.
% This function covers path loss only; shadow fading and O2I loss are separate.

validateattributes(d2dM, {'numeric'}, {'scalar', 'positive', 'finite'});
validateattributes(d3dM, {'numeric'}, {'scalar', 'positive', 'finite'});
validateattributes(fcGHz, {'numeric'}, {'scalar', 'positive', 'finite'});
validateattributes(hBsM, {'numeric'}, {'scalar', 'positive', 'finite'});
validateattributes(hUeM, {'numeric'}, {'scalar', 'positive', 'finite'});

c = 3e8;
hBsEffectiveM = hBsM - 1;
hUeEffectiveM = hUeM - 1;
dBreakM = 4 * hBsEffectiveM * hUeEffectiveM * fcGHz * 1e9 / c;

plLos1 = 28 + 22 * log10(d3dM) + 20 * log10(fcGHz);
plLos2 = 28 + 40 * log10(d3dM) + 20 * log10(fcGHz) ...
    - 9 * log10(dBreakM^2 + (hBsM - hUeM)^2);
if d2dM <= dBreakM
    plLos = plLos1;
else
    plLos = plLos2;
end

if isLos
    pathlossDb = plLos;
else
    plNlos = 13.54 + 39.08 * log10(d3dM) + 20 * log10(fcGHz) ...
        - 0.6 * (hUeM - 1.5);
    pathlossDb = max(plLos, plNlos);
end
end
