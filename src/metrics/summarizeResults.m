function summary = summarizeResults(rateBps)
%SUMMARIZERESULTS Summarize per-location rates in bit/s.

validateattributes(rateBps, {'numeric'}, {'vector', 'nonempty', 'nonnegative', 'finite'});
summary.meanBps = mean(rateBps);
summary.medianBps = median(rateBps);
summary.sortedRateBps = sort(rateBps(:));

% Linear interpolation at the 5th percentile, without a toolbox dependency.
n = numel(summary.sortedRateBps);
h = 1 + (n - 1) * 0.05;
lo = floor(h);
hi = ceil(h);
summary.p5Bps = summary.sortedRateBps(lo) ...
    + (h - lo) * (summary.sortedRateBps(hi) - summary.sortedRateBps(lo));
summary.cdfProbability = (1:n)' / n;
end
