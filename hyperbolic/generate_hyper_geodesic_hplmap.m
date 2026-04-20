function [path1, path2] = generate_hyper_geodesic_hplmap(P1, P2, P3, halfplane_f)
% Generate hyperbolic geodesics using upper half-plane mapping
% Input:
%   P1 - start point (in domain G)
%   P2, P3 - two end points (in domain G)
%   halfplane_f - hplmap object (mapping f: H -> G)
% Output:
%   path1 - geodesic from P1 to P2
%   path2 - geodesic from P1 to P3

% Map to upper half-plane
P1_inv = evalinv(halfplane_f, P1);
P2_inv = evalinv(halfplane_f, P2);
P3_inv = evalinv(halfplane_f, P3);

% Generate geodesic from P1 to P2
if abs(real(P1_inv) - real(P2_inv)) < 1e-10
    t_path1 = linspace(P1_inv, P2_inv, 100);
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
    t_path1 = center + radius * exp(1i * theta_path);
end

% Generate geodesic from P1 to P3
if abs(real(P1_inv) - real(P3_inv)) < 1e-10
    t_path2 = linspace(P1_inv, P3_inv, 100);
else
    center = (abs(P3_inv)^2 - abs(P1_inv)^2) / (2 * (real(P3_inv) - real(P1_inv)));
    radius = sqrt(abs(P1_inv - center)^2);
    
    theta1 = angle(P1_inv - center);
    theta2 = angle(P3_inv - center);
    
    if abs(theta1 - theta2) > pi
        if theta1 > theta2
            theta2 = theta2 + 2*pi;
        else
            theta1 = theta1 + 2*pi;
        end
    end
    
    theta_path = linspace(theta1, theta2, 100);
    t_path2 = center + radius * exp(1i * theta_path);
end

% Map back to original domain
path1 = halfplane_f(t_path1);
path2 = halfplane_f(t_path2);
end