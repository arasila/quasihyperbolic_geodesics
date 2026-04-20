function plot_inscribed_circle(radius, varargin)
% Plot an inscribed circle
% Input:
%   radius - radius of the circle
%   varargin - optional parameters (Name-Value pairs)
%       'LineWidth', 'Color', 'LineStyle', 'Center'

p = inputParser;
addParameter(p, 'LineWidth', 1.5);
addParameter(p, 'Color', 'r');
addParameter(p, 'LineStyle', ':');
addParameter(p, 'Center', 0 + 0i);
parse(p, varargin{:});

theta = linspace(0, 2*pi, 200);
x = p.Results.Center + radius * cos(theta);
y = p.Results.Center + radius * sin(theta);

hold on;
plot(x, y, ...
    'LineWidth', p.Results.LineWidth, ...
    'Color', p.Results.Color, ...
    'LineStyle', p.Results.LineStyle);
end