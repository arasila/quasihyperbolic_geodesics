function len = compute_hyperbolic_distance(P1, P2, f_inv)
% Compute exact hyperbolic distance between two points
% Input:
%   P1, P2 - points in domain G
%   f_inv - inverse mapping f_inv: G -> D (to upper half-plane)
% Output:
%   len - hyperbolic distance

P1_inv = f_inv(P1);
P2_inv = f_inv(P2);

% Hyperbolic distance formula in upper half-plane
len = acosh(1 + abs(P1_inv - P2_inv)^2 / (2 * imag(P1_inv) * imag(P2_inv)));
end