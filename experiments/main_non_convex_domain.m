close all; clear;

% ========== Parameter Settings ==========
h = 0.05;
dir = 10;

P1 = -2 + 0i;
P2 = 0 - 1i;
P3 = 0 + 1i;
y_theoretical = -1 + 0i;

% ========== Domain Definition ==========
vertOut = [-4+1i; -1+1i; -1+4i; 4+4i; 4-4i; -1-4i; -1-1i; -4-1i];
vertcOut = [vertOut; vertOut(1)];
obs_list = {vertcOut.'};

% ========== Conformal Mapping (requires SC Toolbox) ==========
poly = polygon(vertOut);
halfplane_f = hplmap(poly);

% ========== Plot Domain Boundary ==========
figure;
plot(real(vertcOut), imag(vertcOut), 'k-', 'LineWidth', 2);
axis equal;
hold on;

% ========== Compute Quasihyperbolic Geodesic P1->P2 ==========
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

zv1 = zz(abs(zz) >= 0);
zv1 = [zv1; P1; P2];

% Build graph and find shortest path
[mys1, myt1, myw1] = build_graph_edges(zv1, dir, h, obs_list, vertcOut);
[gamma_qh1, len_qh1] = find_shortest_path(zv1, mys1, myt1, myw1, P1, P2);

fprintf('  QH length P1->P2: %.5f\n', len_qh1);

% ========== Compute Quasihyperbolic Geodesic P1->P3 ==========
fprintf('Computing QH geodesic P1->P3...\n');

% Generate mesh
xmi = min(real(P1), real(P3));
xma = max(real(P1), real(P3));
ymi = min(imag(P1), imag(P3));
yma = max(imag(P1), imag(P3));

[xx, yy] = meshgrid(double(xmi:h:xma), double(ymi:h:yma));
zz = xx + 1i*yy;

% Screen points outside the outer polygon or on the boundary
[in1, on1] = inpolygon(xx, yy, real(vertcOut), imag(vertcOut));
zz(~in1) = NaN + 1i*NaN;
zz(on1) = NaN + 1i*NaN;

zv2 = zz(abs(zz) >= 0);
zv2 = [zv2; P1; P3];

% Build graph and find shortest path
[mys2, myt2, myw2] = build_graph_edges(zv2, dir, h, obs_list, vertcOut);
[gamma_qh2, len_qh2] = find_shortest_path(zv2, mys2, myt2, myw2, P1, P3);

fprintf('  QH length P1->P3: %.5f\n', len_qh2);

% ========== Compute Exact Hyperbolic Geodesics ==========
fprintf('Computing exact hyperbolic geodesics...\n');

gamma_exact1 = generate_hyperbolic_geodesic_hplmap(P1, P2, halfplane_f);
gamma_exact2 = generate_hyperbolic_geodesic_hplmap(P1, P3, halfplane_f);

len_exact1 = compute_hyperbolic_distance_hplmap(P1, P2, halfplane_f);
len_exact2 = compute_hyperbolic_distance_hplmap(P1, P3, halfplane_f);

fprintf('  Exact Hyp length P1->P2: %.5f\n', len_exact1);
fprintf('  Exact Hyp length P1->P3: %.5f\n', len_exact2);

% ========== Bifurcation Point Analysis ==========
w = find_bifurcation_on_real_axis(gamma_qh1);

fprintf('\n=== Bifurcation Analysis ===\n');
fprintf('Approximated bifurcation point w: %.4f\n', w);
fprintf('Theoretical bifurcation point y:  %.4f\n', y_theoretical);
fprintf('Error |w - y|: %.4f\n', abs(w - y_theoretical));

% ========== Visualization ==========
plot_geodesic(gamma_qh1, 'Color', 'r', 'LineStyle', ':', 'DisplayName', 'QH (P1->P2)');
plot_geodesic(gamma_qh2, 'Color', 'r', 'LineStyle', ':', 'DisplayName', 'QH (P1->P3)');
h1 = plot_geodesic(gamma_exact1, 'Color', 'g', 'LineStyle', '-', 'DisplayName', 'Exact (P1->P2)');
h2 = plot_geodesic(gamma_exact2, 'Color', 'g', 'LineStyle', '-', 'DisplayName', 'Exact (P1->P3)');

plot_points([P1, P2, P3, y_theoretical], 'MarkerSize', 5, 'MarkerFaceColor', 'k');

setup_figure('Box', 'off');

set_layer_order([h1, h2], 'bottom');
legend('Location', 'best');

% ========== Output Results ==========
fprintf('\n=== Path Lengths ===\n');
fprintf('QH geodesic P1->P2: %.5f\n', len_qh1);
fprintf('QH geodesic P1->P3: %.5f\n', len_qh2);
fprintf('Exact Hyp geodesic P1->P2: %.5f\n', len_exact1);
fprintf('Exact Hyp geodesic P1->P3: %.5f\n', len_exact2);