function varargout = plot_points(points, varargin)
% Plot point markers
% Input:
%   points - vector of complex coordinates
%   varargin - optional parameters (Name-Value pairs)
%       'MarkerSize', 'MarkerFaceColor', 'Marker', 'Color'
% Output:
%   h - graphics handle (optional)

p = inputParser;
addParameter(p, 'MarkerSize', 5);
addParameter(p, 'MarkerFaceColor', 'k');
addParameter(p, 'Marker', 'o');
addParameter(p, 'Color', 'k');
parse(p, varargin{:});

hold on;
h = plot(real(points), imag(points), ...
    'Marker', p.Results.Marker, ...
    'MarkerSize', p.Results.MarkerSize, ...
    'MarkerFaceColor', p.Results.MarkerFaceColor, ...
    'Color', p.Results.Color, ...
    'LineStyle', 'none');

if nargout > 0
    varargout{1} = h;
end
end