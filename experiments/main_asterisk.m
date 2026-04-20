close all; clear;

% ========== Parameter Settings ==========
h = 0.05;
dir = 4;
n = 3;
l3 = 1;
r = l3 / sin(pi/n);
l1 = 6;
l4 = 1;

% Generate domain
vertOut = generate_asterisk_polygon(n, r, l1);
vertcOut = [vertOut; vertOut(1)];

z0 = l1 + r*cos(pi/n) - l4 + 0i;
z_list = generate_point_list(n, z0);

% Conformal mapping
f = hplmap(polygon(vertOut));
f_inv = inv(f);

obs_list = {vertcOut.'};

% ========== Generate Grid ==========
xmi = min(real(vertOut)) - 1; xma = max(real(vertOut)) + 1;
ymi = min(imag(vertOut)) - 1; yma = max(imag(vertOut)) + 1;

zv = generate_grid_polygon([xmi, xma], [ymi, yma], h, vertOut, obs_list, ...
    @(z) z(abs(z) <= real(z0)));

% ========== Build Graph ==========
[mys, myt, myw, ~] = build_graph_edges(zv, dir, h, obs_list, vertcOut);

% ========== Visualization ==========
figure;
plot_domain_boundary(vertOut, obs_list);

z_list_closed = [z_list; z_list(1)];
hyper_radius = inf;
qh_radius = inf;

for jj = 1:length(z_list)
    P1 = z_list_closed(jj);
    P2 = z_list_closed(jj+1);
    
    % Quasihyperbolic geodesic
    [gamma_qh, ~, ~] = find_shortest_path(zv, mys, myt, myw, P1, P2);
    plot_geodesic(gamma_qh, 'Color', 'g');
    qh_radius = min(qh_radius, min(abs(gamma_qh)));
    
    % Hyperbolic geodesic
    gamma_hyp = generate_hyper_geodesic(P1, P2, f, f_inv);
    plot_geodesic(gamma_hyp, 'Color', 'r');
    hyper_radius = min(hyper_radius, min(abs(gamma_hyp)));
end

% Draw inscribed circles
plot_inscribed_circle(hyper_radius, 'Color', 'r', 'LineStyle', ':');
plot_inscribed_circle(qh_radius, 'Color', 'g', 'LineStyle', ':');

setup_figure();

fprintf('Hyperbolic inscribed circle radius: %.6f\n', hyper_radius);
fprintf('Quasihyperbolic inscribed circle radius: %.6f\n', qh_radius);
fprintf('Ratio r_rho / r_k: %.6f\n', hyper_radius / qh_radius);