function comparison = runComparison(userXY, campus, cfg, conditions)
%RUNCOMPARISON 지정한 실험 조건 쌍을 같은 위치와 설정으로 비교합니다.
% conditions의 각 행은 [주파수_GHz, 대역폭_Hz]입니다.

if size(conditions, 2) ~= 2 || size(conditions, 1) < 2
    error('conditions에는 [주파수_GHz, 대역폭_Hz] 두 열과 두 행 이상이 필요합니다.');
end

emptyResult = struct('frequencyGHz', [], 'bandwidthHz', [], ...
    'sinrDb', [], 'rateBps', [], 'summary', struct());
comparison = repmat(emptyResult, size(conditions, 1), 1);

for k = 1:size(conditions, 1)
    scenarioCfg = cfg;
    scenarioCfg.frequencyGHz = conditions(k, 1);
    scenarioCfg.bandwidthHz = conditions(k, 2);

    % 향후 shadow fading을 추가해도 비교 쌍에 같은 난수열을 적용합니다.
    rng(cfg.randomSeed, 'twister');
    result = evaluateCampus(userXY, campus, scenarioCfg);

    comparison(k).frequencyGHz = scenarioCfg.frequencyGHz;
    comparison(k).bandwidthHz = scenarioCfg.bandwidthHz;
    comparison(k).sinrDb = result.sinrDb;
    comparison(k).rateBps = result.rateBps;
    comparison(k).summary = summarizeResults(result.rateBps);
end
end

