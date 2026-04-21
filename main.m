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
h = 0.05;       % Grid step size (smaller is more accurate but computationally expensive)
dir = 6;        % Neighborhood parameter (m in the paper)

% Visualization options
show_grid = false;       % Whether to display grid points
show_exact = true;       % Whether to display exact hyperbolic geodesic (requires SC Toolbox)

%% ========== Preprocessing ==========
fprintf('=== Hyperbolic and Quasihyperbolic Geodesic Computation ===\n\n');

% Check if points are inside the polygon
vertcOut = [vertOut; vertOut(1)];
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
fprintf('Parameters: h = %.4f, dir = %d\n\n', h, dir);

obs_list = {vertcOut.'};

%% ========== Compute Quasihyperbolic Geodesic ==========
fprintf('Computing QH geodesic P1->P2...\n');

% Generate mesh
xmi = min(real(P1), real(P2));
xma = max(real(P1), real(P2));
ymi = min(imag(P1), imag(P2));
yma = max(imag(P1), imag(P2));

[xx, yy] = meshgrid(double(xmi:h:xma), double(ymi:h:yma));
zz = xx + 1i*yy;

% Screen points outside the outer polygon or on the boundary
[in1, on1] = inpolygon(xx, yy, real(vertcOut), imag(vertcOut));
zz(~in1) = NaN + 1i*NaN;
zz(on1) = NaN + 1i*NaN;

zv = zz(abs(zz) >= 0);
zv = [zv; P1; P2];

% Build graph and find shortest path
[mys, myt, myw] = build_graph_edges(zv, dir, h, obs_list, vertcOut);
[gamma_qh, len_qh] = find_shortest_path(zv, mys, myt, myw, P1, P2);

fprintf('  QH geodesic length: %.5f\n', len_qh);

%% ========== Compute Exact Hyperbolic Geodesic ==========
if show_exact
    fprintf('Computing exact hyperbolic geodesic...\n');
    try
        poly = polygon(vertOut);
        halfplane_f = hplmap(poly);
        
        gamma_exact = generate_hyperbolic_geodesic_hplmap(P1, P2, halfplane_f);
        len_exact = compute_hyperbolic_distance_hplmap(P1, P2, halfplane_f);
        
        fprintf('  Exact Hyp geodesic length: %.5f\n', len_exact);
    catch ME
        fprintf('  Warning: SC Toolbox not available or mapping failed.\n');
        fprintf('  %s\n', ME.message);
        show_exact = false;
        gamma_exact = [];
        len_exact = NaN;
    end
end

%% ========== Visualization ==========
figure('Position', [100, 100, 800, 600]);
hold on;

% Plot domain boundary
plot_domain_boundary(vertOut, obs_list);

% Plot grid points (optional)
if show_grid
    margin = 0.5;
    xmi_grid = min(real([P1, P2])) - margin;
    xma_grid = max(real([P1, P2])) + margin;
    ymi_grid = min(imag([P1, P2])) - margin;
    yma_grid = max(imag([P1, P2])) + margin;
    xmi_grid = max(xmi_grid, min(real(vertOut)));
    xma_grid = min(xma_grid, max(real(vertOut)));
    ymi_grid = max(ymi_grid, min(imag(vertOut)));
    yma_grid = min(yma_grid, max(imag(vertOut)));
    
    [xx_grid, yy_grid] = meshgrid(double(xmi_grid:h:xma_grid), double(ymi_grid:h:yma_grid));
    zz_grid = xx_grid + 1i*yy_grid;
    [in_grid, on_grid] = inpolygon(xx_grid, yy_grid, real(vertcOut), imag(vertcOut));
    zz_grid(~in_grid) = NaN + 1i*NaN;
    zz_grid(on_grid) = NaN + 1i*NaN;
    zv_grid = zz_grid(abs(zz_grid) >= 0);
    
    plot_grid_points(zv_grid, 'MarkerSize', 2, 'Color', 'c');
end

% Plot quasihyperbolic geodesic
plot_geodesic(gamma_qh, 'Color', 'b', 'LineStyle', ':', 'LineWidth', 1.5, 'DisplayName', 'Quasihyperbolic');

% Plot exact hyperbolic geodesic
if show_exact && ~isempty(gamma_exact)
    h_exact = plot_geodesic(gamma_exact, 'Color', 'g', 'LineStyle', '-', 'LineWidth', 1.5, 'DisplayName', 'Hyperbolic (exact)');
    set_layer_order(h_exact, 'bottom');
end

% Plot points
plot_points([P1, P2], 'MarkerSize', 8, 'MarkerFaceColor', 'k');
text(real(P1)-0.15, imag(P1)-0.15, 'P1', 'FontSize', 10, 'FontWeight', 'bold');
text(real(P2)+0.1, imag(P2)+0.1, 'P2', 'FontSize', 10, 'FontWeight', 'bold');

setup_figure('Box', 'on', 'Grid', 'on');
xlabel('Re(z)');
ylabel('Im(z)');
title(sprintf('Geodesics in Polygonal Domain (h=%.3f, dir=%d)', h, dir));
legend('Location', 'best');

%% ========== Output Results ==========
fprintf('\n=== Results Summary ===\n');
fprintf('Quasihyperbolic length:      %.5f\n', len_qh);
if show_exact && ~isnan(len_exact)
    fprintf('Hyperbolic length (exact):   %.5f\n', len_exact);
    fprintf('Ratio k_G / rho_G:           %.4f\n', len_qh / len_exact);
end
fprintf('\n=== Done ===\n');