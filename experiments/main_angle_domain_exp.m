close all; clear;

% ========== Parameter Settings ==========
h = 0.025;
dir = 8;
n = 10;
j = 2;
varphi = atan(1/2) * 2;
theta_j = j/n * (pi + varphi)/2;
l = 3;
r = l * tan(varphi/2);

% Target points
z_j = (l - r*1i) + r * exp(1i * (-varphi/2 + theta_j));
if j == 0
    z_j = z_j + 1e-8i;
end
zs_j = conj(z_j);

P1 = 0.5;
P2 = z_j;
P3 = zs_j;

alpha = varphi;
beta = alpha/2;

% Boundary
vertOut = [1e4*exp(-beta*1i); 0; 1e4*exp(beta*1i)];
vertcOut = [vertOut; vertOut(1)];
obs_list = {vertcOut.'};

disp('Generating upper uniform grid')
% ========== Generate Upper Grid ==========
xmi = 0.5; xma = l + r;
ymi = imag(P2); yma = 0;
[xx, yy] = meshgrid(xmi:h:xma, floor(ymi):h:0);
zz = xx + 1i*yy;
[in1, on1] = inpolygon(xx, yy, real(vertcOut), imag(vertcOut));
zz(~in1) = NaN; zz(on1) = NaN;
zv1 = zz(abs(zz) >= 0);
zv1 = zv1(angle(zv1) >= angle(P2));
zv1 = [zv1; P1; P2];

disp('Start approximate geodesic 1')
% ========== Build Graph and Compute Shortest Path 1 ==========
[mys1, myt1, myw1, dist1] = build_graph_edges(zv1, dir, h, obs_list, vertcOut);
[gamma_1, ~, ~] = find_shortest_path(zv1, mys1, myt1, myw1, P1, P2);

disp('Geodesic 1 is finished')

disp('Generating lower uniform grid')
% ========== Generate Lower Grid ==========
yma = imag(P3); ymi = 0;
[xx, yy] = meshgrid(xmi:h:xma, ymi:h:yma);
zz = xx + 1i*yy;
[in1, on1] = inpolygon(xx, yy, real(vertcOut), imag(vertcOut));
zz(~in1) = NaN; zz(on1) = NaN;
zv2 = zz(abs(zz) >= 0);
zv2 = zv2(angle(zv2) <= angle(P3));
zv2 = [zv2; P1; P3];

disp('Start approximate geodesic 2')
% ========== Build Graph and Compute Shortest Path 2 ==========
[mys2, myt2, myw2, dist2] = build_graph_edges(zv2, dir, h, obs_list, vertcOut);
[gamma_2, ~, ~] = find_shortest_path(zv2, mys2, myt2, myw2, P1, P3);

disp('Geodesic 2 is finished')

% ========== Visualization ==========
figure;
plot_domain_boundary(vertOut, obs_list, 'PlotBisector', true, 'BisectorAngle', beta);
plot_geodesic(gamma_1, 'Color', 'b', 'LineStyle', ':');
plot_geodesic(gamma_2, 'Color', 'b', 'LineStyle', ':');
plot(real(P1), imag(P1), 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'k');
plot(real(P2), imag(P2), 'ks', 'MarkerSize', 5, 'MarkerFaceColor', 'k');
plot(real(P3), imag(P3), 'ks', 'MarkerSize', 5, 'MarkerFaceColor', 'k');
setup_figure('XLim', [0 6], 'YLim', [-3 3]);

% ========== Bifurcation Point Analysis ==========
[bif_point, ~] = find_bifurcation_point(gamma_1, gamma_2);
fprintf('Approximated bifurcation point: %.4f\n', bif_point);
fprintf('Theoretical bifurcation point: %.4f\n', l);
fprintf('Error: %.4f\n', abs(bif_point - l));

% ========== Error Calculation ==========
gamma_1_nonzero = gamma_1(imag(gamma_1) ~= 0);
gamma_2_nonzero = gamma_2(imag(gamma_2) ~= 0);
err1 = mean(abs(abs(gamma_1_nonzero - (l - r*1i)) - r));
err2 = mean(abs(abs(gamma_2_nonzero - (l + r*1i)) - r));
fprintf('Average error gamma_1: %.6f\n', err1);
fprintf('Average error gamma_2: %.6f\n', err2);