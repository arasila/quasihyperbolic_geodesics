function y = rhoH(z, w)
% Compute hyperbolic distance in the upper half-plane H^2
% Formula: rho_{H^2}(z,w) = 2 * atanh(|z-w| / |z - conj(w)|)
% Input:
%   z, w - points in the upper half-plane
% Output:
%   y - hyperbolic distance

y = 2 * atanh(abs(z - w) / (abs(z - conj(w)) + eps));
end