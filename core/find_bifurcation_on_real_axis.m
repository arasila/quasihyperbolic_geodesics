function w = find_bifurcation_on_real_axis(gamma, tol)
% Find bifurcation point among intersections of geodesic with real axis
% Input:
%   gamma - sequence of points on the geodesic
%   tol - tolerance (default 1e-8)
% Output:
%   w - coordinate of bifurcation point (rightmost intersection on real axis)

if nargin < 2
    tol = 1e-8;
end

% Find points on the real axis
real_points = gamma(abs(imag(gamma)) < tol);

if isempty(real_points)
    w = NaN;
    return;
end

% Return the point with maximum real part
[~, idx] = max(real(real_points));
w = real_points(idx);
end