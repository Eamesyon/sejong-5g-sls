function plotResults(userXY, sinrDb, summary, campus)
%PLOTRESULTS Draw the SINR map and throughput CDF for a completed run.

if size(userXY, 1) ~= numel(sinrDb)
    error('There must be one SINR value for each user location.');
end

figure('Name', 'Sejong SINR map');
scatter(userXY(:, 1), userXY(:, 2), 18, sinrDb(:), 'filled');
axis equal tight;
grid on;
xlabel('x (m)'); ylabel('y (m)');
title('SINR by evaluation location (dB)');
cb = colorbar; ylabel(cb, 'SINR (dB)');
hold on;

if isfield(campus, 'buildings')
    for k = 1:size(campus.buildings, 1)
        b = campus.buildings(k, :); % [xmin xmax ymin ymax]
        rectangle('Position', [b(1), b(3), b(2)-b(1), b(4)-b(3)], ...
            'EdgeColor', [0.2 0.2 0.2], 'LineWidth', 1);
    end
end
if isfield(campus, 'serviceSites') && ~isempty(campus.serviceSites)
    plot(campus.serviceSites(:, 1), campus.serviceSites(:, 2), '^k', ...
        'MarkerFaceColor', 'y', 'DisplayName', 'Service site');
end
if isfield(campus, 'interferenceSites') && ~isempty(campus.interferenceSites)
    plot(campus.interferenceSites(:, 1), campus.interferenceSites(:, 2), 'xr', ...
        'LineWidth', 1.5, 'DisplayName', 'Interference site');
end
hold off;

figure('Name', 'Throughput CDF');
plot(summary.sortedRateBps / 1e6, summary.cdfProbability, 'LineWidth', 1.5);
grid on;
xlabel('Shannon rate (Mbit/s)'); ylabel('Cumulative probability');
title(sprintf('Rate CDF: median %.1f Mbit/s, 5th percentile %.1f Mbit/s', ...
    summary.medianBps / 1e6, summary.p5Bps / 1e6));
end
