function path = generate_hyperbolic_geodesic(P1, P2, f, f_inv)
% Generate exact hyperbolic geodesic via conformal mapping
% Input:
%   P1, P2 - points in domain G
%   f - mapping f: D -> G (from canonical domain to G)
%   f_inv - inverse mapping f_inv: G -> D
% Output:
%   path - sequence of points on the hyperbolic geodesic in G

% Map points to canonical domain (upper half-plane or unit disk)
P1_inv = f_inv(P1);
P2_inv = f_inv(P2);

% Generate geodesic in canonical domain
% Assumes canonical domain is upper half-plane
if abs(real(P1_inv) - real(P2_inv)) < 1e-10
    % Vertical line
    t_path = linspace(P1_inv, P2_inv, 100);
else
    % Circular arc orthogonal to real axis
    center = (abs(P2_inv)^2 - abs(P1_inv)^2) / (2 * (real(P2_inv) - real(P1_inv)));
    radius = sqrt(abs(P1_inv - center)^2);
    
    theta1 = angle(P1_inv - center);
    theta2 = angle(P2_inv - center);
    
    % Handle angle wrap-around
    if abs(theta1 - theta2) > pi
        if theta1 > theta2
            theta2 = theta2 + 2*pi;
        else
            theta1 = theta1 + 2*pi;
        end
    end
    
    theta_path = linspace(theta1, theta2, 100);
    t_path = center + radius * exp(1i * theta_path);
end

% Map back to original domain
path = f(t_path);
end