function plotResults(userXY, sinrDb, summary, campus)
%PLOTRESULTS 계산이 끝난 실험의 SINR 지도와 전송률 CDF를 그립니다.

if size(userXY, 1) ~= numel(sinrDb)
    error('사용자 위치마다 SINR 값이 하나씩 있어야 합니다.');
end

figure('Name', 'Sejong SINR map');
scatter(userXY(:, 1), userXY(:, 2), 18, sinrDb(:), 'filled');
axis equal tight;
grid on;
xlabel('x 좌표 (m)'); ylabel('y 좌표 (m)');
title('평가 위치별 SINR (dB)');
cb = colorbar; ylabel(cb, 'SINR (dB)');
hold on;

if isfield(campus, 'buildings')
    for k = 1:size(campus.buildings, 1)
        b = campus.buildings(k, :); % [xmin xmax ymin ymax]
        rectangle('Position', [b(1), b(3), b(2)-b(1), b(4)-b(3)], ...
            'EdgeColor', [0.2 0.2 0.2], 'LineWidth', 1, 'DisplayName', '건물');
    end
end
if isfield(campus, 'serviceSites') && ~isempty(campus.serviceSites)
    plot(campus.serviceSites(:, 1), campus.serviceSites(:, 2), '^k', ...
        'MarkerFaceColor', 'y', 'DisplayName', '서비스 기지국');
end
if isfield(campus, 'interferenceSites') && ~isempty(campus.interferenceSites)
    plot(campus.interferenceSites(:, 1), campus.interferenceSites(:, 2), 'xr', ...
        'LineWidth', 1.5, 'DisplayName', '간섭 기지국');
end
hold off;

figure('Name', 'Throughput CDF');
plot(summary.sortedRateBps / 1e6, summary.cdfProbability, 'LineWidth', 1.5);
grid on;
xlabel('Shannon 전송률 (Mbit/s)'); ylabel('누적 확률');
title(sprintf('전송률 CDF: 중앙값 %.1f Mbit/s, 하위 5%% %.1f Mbit/s', ...
    summary.medianBps / 1e6, summary.p5Bps / 1e6));
end
