function varargout = plot_domain_boundary(vertOut, obs_list, varargin)
% Plot domain boundary
% Input:
%   vertOut - outer boundary vertices
%   obs_list - list of obstacles
%   varargin - optional parameters (Name-Value pairs)
%       'LineWidth', 'Color', 'LineStyle', 'PlotBisector', 'BisectorAngle', 'BisectorLength'
% Output:
%   h - graphics handle (optional)

p = inputParser;
addParameter(p, 'LineWidth', 2);
addParameter(p, 'Color', 'k');
addParameter(p, 'LineStyle', '-');
addParameter(p, 'PlotBisector', false);
addParameter(p, 'BisectorAngle', 0);
addParameter(p, 'BisectorLength', 1e4);
parse(p, varargin{:});

hold on;

% Plot outer boundary
vertcOut = [vertOut; vertOut(1)];
h1 = plot(real(vertcOut), imag(vertcOut), ...
    'LineWidth', p.Results.LineWidth, ...
    'Color', p.Results.Color, ...
    'LineStyle', p.Results.LineStyle);

% Plot obstacles
h2 = [];
for k = 1:length(obs_list)
    obs = obs_list{k};
    if size(obs, 1) == 1
        h2(end+1) = plot(real(obs), imag(obs), 'o', 'MarkerSize', 5, ...
            'MarkerFaceColor', p.Results.Color);
    else
        obs_closed = [obs; obs(1)];
        h2(end+1) = plot(real(obs_closed), imag(obs_closed), ...
            'LineWidth', p.Results.LineWidth, ...
            'Color', p.Results.Color);
    end
end

% Plot angle bisector
h3 = [];
if p.Results.PlotBisector
    beta = p.Results.BisectorAngle;
    h3 = plot(real([0, p.Results.BisectorLength * exp(beta*1i)]), ...
              imag([0, p.Results.BisectorLength * exp(beta*1i)]), ...
              'k--', 'LineWidth', 0.5);
end

axis equal;

% Return handle if requested
if nargout > 0
    varargout{1} = [h1; h2(:); h3(:)];
end
end