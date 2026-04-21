function [bif_point, err] = find_bifurcation_point(gamma_1, gamma_2)
% Identify the bifurcation point of two geodesics
% Input:
%   gamma_1, gamma_2 - point sequences of the two paths
% Output:
%   bif_point - coordinate of the bifurcation point
%   err - estimated error

tol = 1e-6;

% Find shared points
shared_pts = [];
for i = 1:length(gamma_1)
    for j = 1:length(gamma_2)
        if abs(gamma_1(i) - gamma_2(j)) < tol
            shared_pts = [shared_pts; gamma_1(i)];
        end
    end
end

if isempty(shared_pts)
    bif_point = NaN;
    err = NaN;
    return;
end

% Compute tangent directions of the two paths near shared points
k1 = angle(diff(gamma_1));
k2 = angle(diff(gamma_2));
k1 = unwrap(k1);
k2 = unwrap(k2);

% Find the directional bifurcation point
for s = 1:length(shared_pts)
    p = shared_pts(s);
    idx1 = find(abs(gamma_1 - p) < tol, 1);
    idx2 = find(abs(gamma_2 - p) < tol, 1);
    
    if ~isempty(idx1) && ~isempty(idx2) && idx1 < length(gamma_1) && idx2 < length(gamma_2)
        if abs(k1(idx1) - k2(idx2)) > 1e-3
            bif_point = p;
            err = abs(k1(idx1) - k2(idx2));
            return;
        end
    end
end

% Return the last shared point
bif_point = shared_pts(end);
err = 0;
end