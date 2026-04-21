function [gamma, path_len, myshort] = find_shortest_path(zv, mys, myt, myw, P1, P2)
% Find shortest path using Dijkstra's algorithm
% Input:
%   zv - grid point vector (without endpoints)
%   mys, myt - start and end indices of edges (based on zv)
%   myw - edge weights
%   P1, P2 - start and end points
% Output:
%   gamma - coordinates of points on the shortest path
%   path_len - length of the path
%   myshort - node indices of the path

% Build graph with original zv
G = graph(mys, myt, myw);

% Find closest grid points to endpoints
[~, idx1] = min(abs(zv - P1));
[~, idx2] = min(abs(zv - P2));

% Compute shortest path
myshort = shortestpath(G, idx1, idx2);

% Extract path points from original zv
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