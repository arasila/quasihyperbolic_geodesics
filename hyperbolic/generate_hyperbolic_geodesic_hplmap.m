function path = generate_hyperbolic_geodesic_hplmap(P1, P2, halfplane_f)
% Generate exact hyperbolic geodesic using hplmap from SC Toolbox
% Input:
%   P1, P2 - points in domain G
%   halfplane_f - hplmap object (mapping f: H -> G)
% Output:
%   path - sequence of points on the hyperbolic geodesic in G

% Map points to upper half-plane
P1_inv = evalinv(halfplane_f, P1);
P2_inv = evalinv(halfplane_f, P2);

% Generate geodesic in upper half-plane
if abs(real(P1_inv) - real(P2_inv)) < 1e-10
    t_path = linspace(P1_inv, P2_inv, 100);
else
    center = (abs(P2_inv)^2 - abs(P1_inv)^2) / (2 * (real(P2_inv) - real(P1_inv)));
    radius = sqrt(abs(P1_inv - center)^2);
    
    theta1 = angle(P1_inv - center);
    theta2 = angle(P2_inv - center);
    
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
path = halfplane_f(t_path);
end