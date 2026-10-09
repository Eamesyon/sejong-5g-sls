function plotComparison(userXY, comparison, campus)
%PLOTCOMPARISON 같은 색 범위의 SINR 지도와 겹친 전송률 CDF를 그립니다.

allSinrDb = [comparison.sinrDb];
sinrRangeDb = [min(allSinrDb), max(allSinrDb)];
if sinrRangeDb(1) == sinrRangeDb(2)
    sinrRangeDb = sinrRangeDb + [-0.5, 0.5];
end

figure('Name', 'SINR 비교 지도');
for k = 1:numel(comparison)
    subplot(1, numel(comparison), k);
    scatter(userXY(:, 1), userXY(:, 2), 18, comparison(k).sinrDb, 'filled');
    axis equal tight; grid on; hold on;
    for bIndex = 1:size(campus.buildings, 1)
        b = campus.buildings(bIndex, :);
        rectangle('Position', [b(1), b(3), b(2)-b(1), b(4)-b(3)], ...
            'EdgeColor', [0.2 0.2 0.2], 'LineWidth', 1);
    end
    if ~isempty(campus.serviceSites)
        plot(campus.serviceSites(:, 1), campus.serviceSites(:, 2), '^k', ...
            'MarkerFaceColor', 'y');
    end
    if ~isempty(campus.interferenceSites)
        plot(campus.interferenceSites(:, 1), campus.interferenceSites(:, 2), 'xr', ...
            'LineWidth', 1.2);
    end
    if isfield(campus, 'proposedSites') && ~isempty(campus.proposedSites)
        plot(campus.proposedSites(:, 1), campus.proposedSites(:, 2), 'sg', ...
            'MarkerFaceColor', 'g');
    end
    caxis(sinrRangeDb);
    xlabel('x 좌표 (m)'); ylabel('y 좌표 (m)');
    title(sprintf('%.1f GHz / %.0f MHz', comparison(k).frequencyGHz, ...
        comparison(k).bandwidthHz / 1e6));
    hold off;
end
colorbar('Position', [0.93 0.15 0.02 0.7]);
colormap(parula);

figure('Name', '전송률 CDF 비교');
hold on; grid on;
colors = lines(numel(comparison));
legendText = cell(numel(comparison), 1);
for k = 1:numel(comparison)
    s = comparison(k).summary;
    plot(s.sortedRateBps / 1e6, s.cdfProbability, ...
        'LineWidth', 1.5, 'Color', colors(k, :));
    legendText{k} = sprintf('%.1f GHz / %.0f MHz (중앙 %.1f, 하위 5%% %.1f Mbit/s)', ...
        comparison(k).frequencyGHz, comparison(k).bandwidthHz / 1e6, ...
        s.medianBps / 1e6, s.p5Bps / 1e6);
end
xlabel('Shannon 전송률 (Mbit/s)'); ylabel('누적 확률');
title('조건별 전송률 CDF');
legend(legendText, 'Location', 'best');
hold off;
end

