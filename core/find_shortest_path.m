function [gamma, path_len, myshort] = find_shortest_path(zv, mys, myt, myw, P1, P2, P3)
% Find shortest path using Dijkstra's algorithm
% Input:
%   zv - grid point vector
%   mys, myt - start and end indices of edges
%   myw - edge weights
%   P1, P2 - start and end points (optional third point P3)
% Output:
%   gamma - coordinates of points on the shortest path
%   path_len - length of the path
%   myshort - node indices of the path

% Add endpoints to grid
zv = [zv; P1; P2];
if nargin >= 7
    zv = [zv; P3];
end

% Build graph
G = graph(mys, myt, myw);

% Find indices of endpoints
[~, idx1] = min(abs(zv - P1));
[~, idx2] = min(abs(zv - P2));

% Compute shortest path
myshort = shortestpath(G, idx1, idx2);

% Extract path points
gamma = zv(myshort);

% Compute path length
if nargout >= 2
    d = distances(G);
    path_len = 0;
    for jj = 1:(length(myshort) - 1)
        path_len = path_len + d(myshort(jj), myshort(jj+1));
    end
end
end