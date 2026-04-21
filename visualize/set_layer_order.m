function set_layer_order(handles, position)
% Set layer order of graphics objects
% Input:
%   handles - array of graphics handles
%   position - 'top' or 'bottom'

for i = 1:length(handles)
    if strcmp(position, 'bottom')
        uistack(handles(i), 'bottom');
    elseif strcmp(position, 'top')
        uistack(handles(i), 'top');
    end
end
end