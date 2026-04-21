function [zv, vertcOut] = generate_grid_polygon(x_range, y_range, h, vertOut, obs_list, region_filter)
% Generate grid points inside a polygonal domain
% Input:
%   x_range - [xmin, xmax]
%   y_range - [ymin, ymax]
%   h - grid step size
%   vertOut - outer boundary vertices
%   obs_list - list of obstacles (cell array of inner boundary vertices)
%   region_filter - function handle for region filtering (optional)
% Output:
%   zv - grid point vector
%   vertcOut - closed outer boundary

xmi = x_range(1); xma = x_range(2);
ymi = y_range(1); yma = y_range(2);

[xx, yy] = meshgrid(double(xmi:h:xma), double(ymi:h:yma));
zz = xx + 1i*yy;

vertcOut = [vertOut; vertOut(1)];

% Filter points inside the outer boundary
[in1, on1] = inpolygon(xx, yy, real(vertcOut), imag(vertcOut));
zz(~in1) = NaN + 1i*NaN;
zz(on1) = NaN + 1i*NaN;

% Exclude points inside obstacles
for k = 1:length(obs_list)
    obs = obs_list{k};
    if size(obs, 1) == 1
        % Point obstacle: exclude points within distance h/2
        for ii = 1:size(zz, 1)
            for jj = 1:size(zz, 2)
                if ~isnan(zz(ii, jj)) && abs(zz(ii, jj) - obs) < h/2
                    zz(ii, jj) = NaN + 1i*NaN;
                end
            end
        end
    else
        % Polygonal obstacle
        obs_closed = [obs; obs(1)];
        [in_obs, on_obs] = inpolygon(xx, yy, real(obs_closed), imag(obs_closed));
        zz(in_obs) = NaN + 1i*NaN;
        zz(on_obs) = NaN + 1i*NaN;
    end
end

zv = zz(abs(zz) >= 0);

% Apply region filtering
if nargin >= 6 && ~isempty(region_filter)
    zv = region_filter(zv);
end

zv = unique(zv);
end