function len = compute_exact_length_angular(P1, P2, f_inv)
% Compute exact hyperbolic distance between two points in an angular domain
% Input:
%   P1, P2 - points in the domain
%   f_inv - inverse mapping f_inv: G -> D
% Output:
%   len - hyperbolic distance

P1_inv = f_inv(P1);
P2_inv = f_inv(P2);

% Hyperbolic distance formula in the upper half-plane
len = acosh(1 + abs(P1_inv - P2_inv)^2 / (2 * imag(P1_inv) * imag(P2_inv)));
end