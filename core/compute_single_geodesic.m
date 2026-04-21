function [gamma, path_len] = compute_single_geodesic(P_start, P_end, h, m, vertOut, obs_list)
% Compute a single quasihyperbolic geodesic
% Input:
%   P_start, P_end - start and end points
%   h - grid step size
%   m - neighborhood parameter
%   vertOut - outer boundary vertices
%   obs_list - list of obstacles
% Output:
%   gamma - sequence of points on the geodesic
%   path_len - length of the path

vertcOut = [vertOut; vertOut(1)];

xmi = min(real(P_start), real(P_end));
xma = max(real(P_start), real(P_end));
ymi = min(imag(P_start), imag(P_end));
yma = max(imag(P_start), imag(P_end));

zv = generate_grid_polygon([xmi, xma], [ymi, yma], h, vertOut, obs_list, []);
zv = [zv; P_start; P_end];

[mys, myt, myw] = build_graph_edges(zv, m, h, obs_list, vertcOut);
[gamma, path_len] = find_shortest_path(zv, mys, myt, myw, P_start, P_end);
end