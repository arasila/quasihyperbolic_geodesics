function len = compute_hyperbolic_distance_hplmap(P1, P2, halfplane_f)
% Compute exact hyperbolic distance using hplmap
% Input:
%   P1, P2 - points in domain G
%   halfplane_f - hplmap object
% Output:
%   len - hyperbolic distance

P1_inv = evalinv(halfplane_f, P1);
P2_inv = evalinv(halfplane_f, P2);

len = acosh(1 + abs(P1_inv - P2_inv)^2 / (2 * imag(P1_inv) * imag(P2_inv)));
end