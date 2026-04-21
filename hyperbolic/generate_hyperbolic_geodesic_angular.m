function path = generate_hyperbolic_geodesic_angular(P1, P2, alpha_deg)
% Generate exact hyperbolic geodesic in an angular domain
% Input:
%   P1, P2 - points in the angular domain
%   alpha_deg - angle of the sector in degrees
% Output:
%   path - sequence of points on the hyperbolic geodesic

alpha = deg2rad(alpha_deg);

% Conformal mapping: sector -> upper half-plane
f = @(t) t.^(alpha/pi);
f_inv = @(t) t.^(pi/alpha);

% Use generic function
path = generate_hyperbolic_geodesic(P1, P2, f, f_inv);
end