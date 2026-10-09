function pathlossDb = calcPathlossUMa(d2dM, d3dM, fcGHz, hBsM, hUeM, isLos)
%CALCPATHLOSSUMA 3GPP TR 38.901 UMa LOS/NLOS 대규모 경로손실입니다.
% 입력 단위: 거리 m, 주파수 GHz, 안테나 높이 m, LOS 여부.
% 이 함수는 경로손실만 계산합니다. Shadow fading과 O2I 손실은 별도입니다.

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
