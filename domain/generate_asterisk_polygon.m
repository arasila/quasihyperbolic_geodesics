function vertOut = generate_asterisk_polygon(n, r, l1)
% Generate vertices of an n-asterisk polygon
% Input:
%   n - number of arms (n >= 3)
%   r - inner radius parameter
%   l1 - arm length parameter
% Output:
%   vertOut - vertex coordinates (3n x 1)

beta = pi / n;
rho = sqrt(l1^2 + r^2 + 2 * l1 * r * cos(beta));
phi = atan(r * sin(beta) / (r * cos(beta) + l1));
theta = 2 * pi / n;

vertOut = zeros(3 * n, 1);

for jj = 0:n-1
    % C_j
    vertOut(3*jj + 1) = rho * exp(1i * (-phi + jj * theta));
    % A_j
    vertOut(3*jj + 2) = rho * exp(1i * (phi + jj * theta));
    % B_j
    vertOut(3*jj + 3) = r * exp(1i * (beta + jj * theta));
end
end