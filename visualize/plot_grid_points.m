function varargout = plot_grid_points(zv, varargin)
% Plot grid points
% Input:
%   zv - grid point vector
%   varargin - optional parameters (Name-Value pairs)
%       'MarkerSize', 'Color', 'Marker'
% Output:
%   h - graphics handle (optional)

p = inputParser;
addParameter(p, 'MarkerSize', 2);
addParameter(p, 'Color', 'c');
addParameter(p, 'Marker', '.');
parse(p, varargin{:});

hold on;
h = plot(real(zv), imag(zv), ...
    'Marker', p.Results.Marker, ...
    'MarkerSize', p.Results.MarkerSize, ...
    'Color', p.Results.Color, ...
    'LineStyle', 'none');

% Return handle if requested
if nargout > 0
    varargout{1} = h;
end
end