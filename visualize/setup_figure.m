function setup_figure(varargin)
% Set up figure properties
% Input:
%   varargin - optional parameters (Name-Value pairs)
%       'AxisEqual', 'Box', 'Grid', 'AxisVisible', 'XLim', 'YLim', 'Title', 'Legend'

p = inputParser;
addParameter(p, 'AxisEqual', true);
addParameter(p, 'Box', 'off');
addParameter(p, 'Grid', 'off');
addParameter(p, 'AxisVisible', 'on');
addParameter(p, 'XLim', []);
addParameter(p, 'YLim', []);
addParameter(p, 'Title', '');
addParameter(p, 'Legend', {});
parse(p, varargin{:});

if p.Results.AxisEqual
    axis equal;
end

box(p.Results.Box);

if strcmp(p.Results.Grid, 'on')
    grid on;
else
    grid off;
end

if strcmp(p.Results.AxisVisible, 'off')
    set(gca, 'Visible', 'off');
end

if ~isempty(p.Results.XLim)
    xlim(p.Results.XLim);
end

if ~isempty(p.Results.YLim)
    ylim(p.Results.YLim);
end

if ~isempty(p.Results.Title)
    title(p.Results.Title);
end

if ~isempty(p.Results.Legend)
    legend(p.Results.Legend{:});
end
end