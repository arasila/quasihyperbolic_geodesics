close all; clear;

% ========== Parameter Settings ==========
h = 0.01;
m = 10;

P1 = -2 + 0i;
P2 = 0 - 1i;
P3 = 0 + 1i;
y_theoretical = -1 + 0i;

% ========== Domain Definition ==========
vertOut = [-4+1i; -1+1i; -1+4i; 4+4i; 4-4i; -1-4i; -1-1i; -4-1i];
obs_list = {};

% ========== Conformal Mapping (requires SC Toolbox) ==========
poly = polygon(vertOut);
halfplane_f = hplmap(poly);

% ========== Compute Quasihyperbolic Geodesics ==========
fprintf('Computing QH geodesic P1->P2...\n');
[gamma_qh1, len_qh1] = compute_single_geodesic(P1, P2, h, m, vertOut, obs_list);

fprintf('Computing QH geodesic P1->P3...\n');
[gamma_qh2, len_qh2] = compute_single_geodesic(P1, P3, h, m, vertOut, obs_list);

% ========== Compute Exact Hyperbolic Geodesics ==========
fprintf('Computing exact hyperbolic geodesics...\n');
[gamma_exact1, gamma_exact2] = compute_exact_geodesic_hplmap(P1, P2, P3, halfplane_f);

% ========== Bifurcation Point Analysis ==========
w = find_bifurcation_on_real_axis(gamma_qh1);
fprintf('\n=== Bifurcation Analysis ===\n');
fprintf('Approximated bifurcation point w: %.4f\n', w);
fprintf('Theoretical bifurcation point y:  %.4f\n', y_theoretical);
fprintf('Error |w - y|: %.4f\n', abs(w - y_theoretical));

% ========== Visualization ==========
figure;
plot_domain(vertOut, {});
plot_path(gamma_qh1, 'Color', 'r', 'LineStyle', ':', 'DisplayName', 'QH (P1->P2)');
plot_path(gamma_qh2, 'Color', 'r', 'LineStyle', ':', 'DisplayName', 'QH (P1->P3)');
h1 = plot_path(gamma_exact1, 'Color', 'g', 'LineStyle', '-', 'DisplayName', 'Exact (P1->P2)');
h2 = plot_path(gamma_exact2, 'Color', 'g', 'LineStyle', '-', 'DisplayName', 'Exact (P1->P3)');
plot_points([P1, P2, P3, y_theoretical], 'MarkerSize', 5, 'MarkerFaceColor', 'k');
setup_figure('Box', 'off');

% Set layer order
set_layer_order([h1, h2], 'bottom');
legend('Location', 'best');

% ========== Output Results ==========
fprintf('\n=== Path Lengths ===\n');
fprintf('QH geodesic P1->P2: %.5f\n', len_qh1);
fprintf('QH geodesic P1->P3: %.5f\n', len_qh2);