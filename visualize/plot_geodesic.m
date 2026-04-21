function varargout = plot_geodesic(gamma, varargin)
% Plot a geodesic path
% Input:
%   gamma - sequence of path points
%   varargin - optional parameters (Name-Value pairs)
%       'LineWidth', 'Color', 'LineStyle', 'DisplayName'
% Output:
%   h - graphics handle (optional)

p = inputParser;
addParameter(p, 'LineWidth', 1.5);
addParameter(p, 'Color', 'b');
addParameter(p, 'LineStyle', '-');
addParameter(p, 'DisplayName', '');
parse(p, varargin{:});

hold on;
h = plot(real(gamma), imag(gamma), ...
    'LineWidth', p.Results.LineWidth, ...
    'Color', p.Results.Color, ...
    'LineStyle', p.Results.LineStyle);

if ~isempty(p.Results.DisplayName)
    set(h, 'DisplayName', p.Results.DisplayName);
end

% Return handle if requested
if nargout > 0
    varargout{1} = h;
end
end