close all; clear;

%% ========== User Input Section ==========
% Please define your polygon vertices and two points here

% Define closed polygon vertices (in order, clockwise or counterclockwise)
vertOut = [
    -4 + 1i;
    -1 + 1i;
    -1 + 4i;
     4 + 4i;
     4 - 4i;
    -1 - 4i;
    -1 - 1i;
    -4 - 1i
];

% Define two target points (must be inside the polygon)
P1 = -2 + 0i;
P2 =  2 + 2i;

% Algorithm parameters
h = 0.02;       % Grid step size (smaller is more accurate but computationally expensive)
m = 6;          % Neighborhood parameter (dir in the paper, controls number of neighbors per point)

% Visualization options
show_grid = false;       % Whether to display grid points
show_exact = true;       % Whether to display exact hyperbolic geodesic (requires SC Toolbox)
save_figure = false;     % Whether to save the figure
output_filename = 'geodesic_result.png';

%% ========== Preprocessing ==========
fprintf('=== Hyperbolic and Quasihyperbolic Geodesic Computation ===\n\n');

% Close polygon
vertcOut = [vertOut; vertOut(1)];

% Check if points are inside the polygon
[in1, ~] = inpolygon(real(P1), imag(P1), real(vertcOut), imag(vertcOut));
[in2, ~] = inpolygon(real(P2), imag(P2), real(vertcOut), imag(vertcOut));

if ~in1
    error('P1 = %.2f + %.2fi is not inside the polygon!', real(P1), imag(P1));
end
if ~in2
    error('P2 = %.2f + %.2fi is not inside the polygon!', real(P2), imag(P2));
end

fprintf('Domain: polygon with %d vertices\n', length(vertOut));
fprintf('Points: P1 = %.3f + %.3fi, P2 = %.3f + %.3fi\n', real(P1), imag(P1), real(P2), imag(P2));
fprintf('Parameters: h = %.4f, m = %d\n\n', h, m);

obs_list = {};  % No inner holes

%% ========== Step 1: Generate Grid ==========
fprintf('Step 1: Generating grid...\n');

% Compute grid range (with margin around points)
margin = 0.5;
xmi = min(real([P1, P2])) - margin;
xma = max(real([P1, P2])) + margin;
ymi = min(imag([P1, P2])) - margin;
yma = max(imag([P1, P2])) + margin;

% Ensure grid does not exceed polygon boundary
xmi = max(xmi, min(real(vertOut)));
xma = min(xma, max(real(vertOut)));
ymi = max(ymi, min(imag(vertOut)));
yma = min(yma, max(imag(vertOut)));

zv = generate_grid_polygon([xmi, xma], [ymi, yma], h, vertOut, obs_list, []);
zv = [zv; P1; P2];

fprintf('  Generated %d grid points\n', length(zv));

%% ========== Step 2: Build Weighted Graph ==========
fprintf('Step 2: Building weighted graph...\n');

% Graph with quasihyperbolic metric
[mys_qh, myt_qh, myw_qh] = build_graph_edges(zv, m, h, vertOut, obs_list, 'qh');
fprintf('  QH graph: %d edges\n', length(myw_qh));

% Graph with hyperbolic metric (approximate)
[mys_hyp, myt_hyp, myw_hyp] = build_graph_edges(zv, m, h, vertOut, obs_list, 'hyp');
fprintf('  Hyp graph: %d edges\n', length(myw_hyp));

%% ========== Step 3: Compute Shortest Paths ==========
fprintf('Step 3: Computing shortest paths...\n');

% Quasihyperbolic geodesic
[gamma_qh, len_qh] = find_shortest_path(zv, mys_qh, myt_qh, myw_qh, P1, P2);
fprintf('  QH geodesic length: %.5f\n', len_qh);

% Approximate hyperbolic geodesic
[gamma_hyp_approx, len_hyp_approx] = find_shortest_path(zv, mys_hyp, myt_hyp, myw_hyp, P1, P2);
fprintf('  Hyp geodesic length (approx): %.5f\n', len_hyp_approx);

%% ========== Step 4: Exact Hyperbolic Geodesic (requires SC Toolbox) ==========
if show_exact
    fprintf('Step 4: Computing exact hyperbolic geodesic...\n');
    try
        poly = polygon(vertOut);
        halfplane_f = hplmap(poly);
        
        % Map to upper half-plane
        P1_inv = evalinv(halfplane_f, P1);
        P2_inv = evalinv(halfplane_f, P2);
        
        % Generate half-plane geodesic
        t_path = generate_halfplane_geodesic(P1_inv, P2_inv, 200);
        
        % Map back to original domain
        gamma_hyp_exact = halfplane_f(t_path);
        
        % Compute exact length
        len_hyp_exact = acosh(1 + abs(P1_inv - P2_inv)^2 / (2 * imag(P1_inv) * imag(P2_inv)));
        fprintf('  Exact Hyp geodesic length: %.5f\n', len_hyp_exact);
    catch ME
        fprintf('  Warning: SC Toolbox not available or mapping failed.\n');
        fprintf('  %s\n', ME.message);
        show_exact = false;
        gamma_hyp_exact = [];
        len_hyp_exact = NaN;
    end
end

%% ========== Step 5: Visualization ==========
fprintf('Step 5: Visualizing results...\n');

figure('Position', [100, 100, 900, 700]);
hold on;

% Plot polygon boundary
plot(real(vertcOut), imag(vertcOut), 'k-', 'LineWidth', 2.5, 'DisplayName', 'Domain boundary');

% Plot grid points (optional)
if show_grid
    plot(real(zv), imag(zv), 'c.', 'MarkerSize', 2, 'DisplayName', 'Grid points');
end

% Plot exact hyperbolic geodesic
if show_exact && ~isempty(gamma_hyp_exact)
    h_exact = plot(real(gamma_hyp_exact), imag(gamma_hyp_exact), ...
        'g-', 'LineWidth', 2, 'DisplayName', 'Hyperbolic (exact)');
end

% Plot approximate hyperbolic geodesic
h_hyp = plot(real(gamma_hyp_approx), imag(gamma_hyp_approx), ...
    'm--', 'LineWidth', 1.5, 'DisplayName', 'Hyperbolic (approx)');

% Plot quasihyperbolic geodesic
h_qh = plot(real(gamma_qh), imag(gamma_qh), ...
    'b:', 'LineWidth', 1.5, 'DisplayName', 'Quasihyperbolic');

% Plot start and end points
plot(real(P1), imag(P1), 'ko', 'MarkerSize', 10, ...
    'MarkerFaceColor', 'k', 'DisplayName', sprintf('P1 (%.2f, %.2f)', real(P1), imag(P1)));
plot(real(P2), imag(P2), 'ks', 'MarkerSize', 10, ...
    'MarkerFaceColor', 'k', 'DisplayName', sprintf('P2 (%.2f, %.2f)', real(P2), imag(P2)));

% Figure settings
axis equal;
xlim([xmi - 0.5, xma + 0.5]);
ylim([ymi - 0.5, yma + 0.5]);
xlabel('Re(z)');
ylabel('Im(z)');
title(sprintf('Geodesics in Polygonal Domain (h=%.3f, m=%d)', h, m));
legend('Location', 'best');
box on;
grid on;

%% ========== Output Results Summary ==========
fprintf('\n=== Results Summary ===\n');
fprintf('Quasihyperbolic length:      %.5f\n', len_qh);
fprintf('Hyperbolic length (approx):  %.5f\n', len_hyp_approx);
if show_exact && ~isnan(len_hyp_exact)
    fprintf('Hyperbolic length (exact):   %.5f\n', len_hyp_exact);
    fprintf('Approximation error:         %.5f\n', abs(len_hyp_exact - len_hyp_approx));
end

% Distance ratio (paper formula 4.1)
ratio = len_qh / len_hyp_approx;
fprintf('\nRatio k_G / rho_G: %.4f\n', ratio);
fprintf('Theoretical bounds: 1 <= k_G/rho_G <= 2 (for simply connected domains)\n');

%% ========== Save Figure ==========
if save_figure
    saveas(gcf, output_filename);
    fprintf('\nFigure saved to: %s\n', output_filename);
end

fprintf('\n=== Done ===\n');