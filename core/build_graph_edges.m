function [mys, myt, myw, distzvbry] = build_graph_edges(zv, dir, h, obs_list, vertcOut, weight_type)
% Build graph edges and weights
% Input:
%   zv - grid point vector
%   dir - direction parameter m
%   h - grid step size
%   obs_list - list of obstacles (not used in weight calculation, only for intersection)
%   vertcOut - outer boundary (closed)
%   weight_type - 'qh' (quasihyperbolic) or 'hyp' (hyperbolic)
% Output:
%   mys, myt - start and end indices of edges
%   myw - edge weights
%   distzvbry - distance from each point to the boundary

if nargin < 6
    weight_type = 'qh';
end

n = length(zv);

% Compute distance from each point to the boundary
% In Antti_250930, distzvbry only uses vertcOut
distzvbry = zeros(1, n);
for jj = 1:n
    distzvbry(jj) = min(polydistNew(zv(jj), vertcOut));
end

% Build edges
mys = zeros(1, 4*n);
myt = zeros(1, 4*n);
ind = 1;

for jj = 1:n
    for kk = 1:n
        if dir*h - 1e-8 <= abs(zv(jj) - zv(kk)) && ...
           abs(zv(jj) - zv(kk)) <= sqrt(2)*dir*h + 1e-8 && (jj ~= kk)
            mys(ind) = jj;
            myt(ind) = kk;
            ind = ind + 1;
        end
    end
end

% Remove duplicates and first empty row
A = [mys' myt'];
A1 = unique(A, 'rows');
A1 = A1(2:end, :);
mys = A1(:, 1)';
myt = A1(:, 2)';
ind = ind-2;

% Compute weights
myw = zeros(1, ind);
for jj = 1:ind
    ps = zv(mys(jj));
    pt = zv(myt(jj));
    
    temp1 = check_intersect(ps, pt, obs_list);
    if temp1 == 0
        if strcmp(weight_type, 'qh')
            myw(jj) = abs(ps - pt) / min(distzvbry(mys(jj)), distzvbry(myt(jj)));
        else
            myw(jj) = minH2(ps, pt, vertcOut(1:end-1));
        end
    else
        myw(jj) = inf;
    end
end

% Remove invalid edges
valid_idx = ~isinf(myw);
mys = mys(valid_idx);
myt = myt(valid_idx);
myw = myw(valid_idx);
end