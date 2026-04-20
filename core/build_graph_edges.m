function [mys, myt, myw_qh, distzvbry] = build_graph_edges(zv, dir, h, obs_list, vertcOut, weight_type)
% Build graph edges and weights
% Input:
%   zv - grid point vector
%   dir - direction parameter m
%   h - grid step size
%   obs_list - list of obstacles
%   vertcOut - outer boundary
%   weight_type - 'qh' (quasihyperbolic) or 'hyp' (hyperbolic)
% Output:
%   mys, myt - start and end indices of edges
%   myw_qh - edge weights
%   distzvbry - distance from each point to the boundary

if nargin < 6
    weight_type = 'qh';
end

n = length(zv);

% Compute distance from each point to the boundary
distzvbry = zeros(1, n);
for jj = 1:n
    dist_to_obs = inf;
    for k = 1:length(obs_list)
        obs = obs_list{k};
        if size(obs, 1) == 1
            dist_to_obs = min(dist_to_obs, abs(zv(jj) - obs));
        else
            dist_to_obs = min(dist_to_obs, polydistNew(zv(jj), obs));
        end
    end
    distzvbry(jj) = min([dist_to_obs, polydistNew(zv(jj), vertcOut(1:end-1))]);
end

% Build edges
max_edges = 8 * n;
mys = zeros(1, max_edges);
myt = zeros(1, max_edges);
ind = 1;

for jj = 1:n
    for kk = jj+1:n
        dist_val = abs(zv(jj) - zv(kk));
        if dir*h - 1e-8 <= dist_val && dist_val <= sqrt(2)*dir*h + 1e-8
            mys(ind) = jj;
            myt(ind) = kk;
            ind = ind + 1;
        end
    end
end

mys = mys(1:ind-1);
myt = myt(1:ind-1);
ind = ind - 1;

% Compute weights
myw_qh = zeros(1, ind);

for jj = 1:ind
    ps = zv(mys(jj));
    pt = zv(myt(jj));
    
    % Check for intersection with obstacles
    if check_intersect(ps, pt, obs_list) == 0
        if strcmp(weight_type, 'qh')
            myw_qh(jj) = abs(ps - pt) / min(distzvbry(mys(jj)), distzvbry(myt(jj)));
        else
            myw_qh(jj) = minH2(ps, pt, vertcOut(1:end-1));
        end
    else
        myw_qh(jj) = inf;
    end
end

% Remove invalid edges
valid_idx = ~isinf(myw_qh);
mys = mys(valid_idx);
myt = myt(valid_idx);
myw_qh = myw_qh(valid_idx);
end