close all; clear;

% ========== Parameter Settings ==========
h = 0.1;
m = 4;
alpha = 60;  % Angle (degrees)
beta = alpha / 2;

P1 = sqrt(3) + 0.5i;
P2 = 5*sqrt(3) + 5*1.5i;

alpha_rad = deg2rad(alpha);
beta_rad = deg2rad(beta);

% Conformal mapping f: sector -> upper half-plane
f = @(t) t.^(alpha_rad/pi);
f_inv = @(t) t.^(pi/alpha_rad);

% ========== Boundary Definition ==========
vertOut = [1e4 + 0i; 0; 1e4 * exp(alpha_rad * 1i)];
vertcOut = vertOut;
obs_list = {vertcOut.'};

% ========== Generate Grid ==========
xmi = min(real(P1), real(P2));
xma = max(real(P1), real(P2));
ymi = min(imag(P1), imag(P2));
yma = max(imag(P1), imag(P2));

zv = generate_grid_polygon([xmi, xma], [ymi, yma], h, vertOut, obs_list, []);
zv = [zv; P1; P2];

% ========== Build Graph and Compute Shortest Path ==========
[mys, myt, myw] = build_graph_edges(zv, m, h, vertOut, obs_list, 'qh');
[gamma_qh, len_qh] = find_shortest_path(zv, mys, myt, myw, P1, P2);

% ========== Compute Exact Hyperbolic Geodesic ==========
gamma_exact = compute_exact_geodesic_angular(P1, P2, f, f_inv);
len_exact = compute_exact_length_angular(P1, P2, f_inv);

% ========== Visualization ==========
figure;
plot_domain(vertOut, obs_list);
plot([0, 1e4*exp(beta_rad*1i)], 'k--', 'LineWidth', 0.5);  % Angle bisector
plot_path(gamma_exact, 'Color', 'g', 'LineStyle', '-', 'DisplayName', 'Exact');
plot_path(gamma_qh, 'Color', 'b', 'LineStyle', ':', 'DisplayName', 'QH');
plot_points([P1, P2], 'MarkerSize', 5);

xlim([xmi-h, xma+h]);
ylim([ymi-h, yma+h]);
legend('Location', 'best');
box off;

% ========== Output Results ==========
fprintf('Exact hyperbolic length: %.5f\n', len_exact);
fprintf('QH approximated length:  %.5f\n', len_qh);
fprintf('Error: %.5f\n', abs(len_exact - len_qh));