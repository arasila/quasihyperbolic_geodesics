function plot_grid_points(zv, varargin)
% Plot grid points
% Input:
%   zv - grid point vector
%   varargin - optional parameters (Name-Value pairs)
%       'MarkerSize', 'Color', 'Marker'

p = inputParser;
addParameter(p, 'MarkerSize', 2);
addParameter(p, 'Color', 'c');
addParameter(p, 'Marker', '.');
parse(p, varargin{:});

hold on;
plot(real(zv), imag(zv), ...
    'Marker', p.Results.Marker, ...
    'MarkerSize', p.Results.MarkerSize, ...
    'Color', p.Results.Color, ...
    'LineStyle', 'none');
end