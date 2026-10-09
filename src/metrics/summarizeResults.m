function summary = summarizeResults(rateBps)
%SUMMARIZERESULTS 위치별 전송률(bit/s)의 평균·중앙값·하위 5%를 요약합니다.

validateattributes(rateBps, {'numeric'}, {'vector', 'nonempty', 'nonnegative', 'finite'});
summary.meanBps = mean(rateBps);
summary.medianBps = median(rateBps);
summary.sortedRateBps = sort(rateBps(:));

% 추가 툴박스에 의존하지 않도록 선형 보간으로 하위 5%를 계산합니다.
n = numel(summary.sortedRateBps);
h = 1 + (n - 1) * 0.05;
lo = floor(h);
hi = ceil(h);
summary.p5Bps = summary.sortedRateBps(lo) ...
    + (h - lo) * (summary.sortedRateBps(hi) - summary.sortedRateBps(lo));
summary.cdfProbability = (1:n)' / n;
end
