function rst = check_intersect(z1, z2, obs_list)
% Check if a line segment intersects with any obstacle in the list
% Input:
%   z1, z2 - endpoints of the line segment (complex numbers)
%   obs_list - cell array of obstacles (each obstacle is a vector of complex vertices)
% Output:
%   rst - true if intersection exists, false otherwise

    rst = false;
    for jj = 1:length(obs_list)
        if is_Intersect(z1, z2, obs_list{jj})
            rst = true;
            return;
        end
    end
end

function is_sect = is_Intersect(z1, z2, vertex)
% Check if a line segment intersects with a single obstacle
% Input:
%   z1, z2 - endpoints of the line segment (complex numbers)
%   vertex - vertices of the obstacle (complex vector, or single point)
% Output:
%   is_sect - true if intersection exists, false otherwise

    m = length(vertex);
    
    % Case: obstacle is a single point
    if m == 1
        ab = z1 - z2;
        ap = vertex(1) - z1;
    
        % Compute imaginary part of cross product
        cross_product = imag(conj(ab) * ap);

        if abs(cross_product) < 1e-10
            is_sect = true;
        else
            is_sect = false;
        end
        return;
    end

    % Convert complex numbers to Cartesian coordinates
    x1 = real(z1); y1 = imag(z1);  
    x2 = real(z2); y2 = imag(z2);  
    
    % Extract polygon vertex coordinates
    xPoly = real(vertex);  
    yPoly = imag(vertex);  
    xPoly = [xPoly real(vertex(1))];
    yPoly = [yPoly imag(vertex(1))];

    x_seg = [x1 x2];
    y_seg = [y1 y2];

    [x, y] = polyxpoly(x_seg, y_seg, xPoly, yPoly);

    if isempty(x)
        is_sect = false;
    else
        is_sect = true;
    end
end