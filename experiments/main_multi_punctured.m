close all; clear;

% ========== Parameter Settings ==========
P1 = -0.5 + 0i;
P2 = (sqrt(3)*3 + 0.5) + 0i;
h = 0.05;
dir = 3;

% Outer boundary
vertOut = [-1-1i; (3*sqrt(3)+1)-1i; (3*sqrt(3)+1)+1i; -1+1i];

% Inner obstacles
vertInt1 = [sqrt(3)/2+0.5i; sqrt(3)/2+1i];
vertInt2 = [sqrt(3)/2-0.5i; sqrt(3)/2-1i];
vertInt3 = [1.5*sqrt(3)+0.5i; 1.5*sqrt(3)+1i];
vertInt4 = [1.5*sqrt(3)-0.5i; 1.5*sqrt(3)-1i];
vertInt5 = [2.5*sqrt(3)+0.5i; 2.5*sqrt(3)+1i];
vertInt6 = [2.5*sqrt(3)-0.5i; 2.5*sqrt(3)-1i];

% Point obstacles
p1 = 0 + 0i;
p2 = sqrt(3) + 0i;
p3 = 2*sqrt(3) + 0i;
p4 = 3*sqrt(3) + 0i;

obs_list = {vertInt1, vertInt2, vertInt3, vertInt4, vertInt5, vertInt6, p1, p2, p3, p4};

% ========== Generate Grid ==========
xmi = real(P1); xma = real(P2);
ymi = min(imag(vertOut)) - 1; yma = max(imag(vertOut)) + 1;

zv = generate_grid_polygon([xmi, xma], [ymi, yma], h, vertOut, obs_list, ...
    @(z) z(imag(z) >= 0 & imag(z) <= 0.5));

zv = [zv; P1; P2];

% ========== Build Graph and Compute Shortest Path ==========
vertcOut = [vertOut; vertOut(1)];
[mys, myt, myw, ~] = build_graph_edges(zv, dir, h, obs_list, vertcOut);
[gamma, path_len, ~] = find_shortest_path(zv, mys, myt, myw, P1, P2);

% ========== Visualization ==========
figure;
plot_domain_boundary(vertOut, obs_list);
plot_geodesic(gamma, 'Color', 'k');
plot(real(P1), imag(P1), 'o', 'MarkerSize', 5, 'MarkerFaceColor', 'k');
plot(real(P2), imag(P2), 'o', 'MarkerSize', 5, 'MarkerFaceColor', 'k');
setup_figure('AxisVisible', 'off');

fprintf('Length of geodesic path: %.5f\n', path_len);