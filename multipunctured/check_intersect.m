function rst=check_intersect(z1, z2, obs_list)
    rst = false;
    for jj=1:length(obs_list)
        if is_Intersect(z1, z2, obs_list{jj})
            rst = true;
            return;
        end
    end
end

function is_sect = is_Intersect(z1, z2, vertex)  
    m = length(vertex);
    if m == 1
        ab = z1 - z2;
        ap = vertex(1) - z1;
    
        % 计算叉积的虚部
        cross_product = imag(conj(ab) * ap);

        if abs(cross_product) < 1e-10
            is_sect = true;
        else
            is_sect = false;
        end
        return;
    end

    % 将复数转换为直角坐标  
    x1 = real(z1); y1 = imag(z1);  
    x2 = real(z2); y2 = imag(z2);  
    
    

    % 提取多边形的顶点坐标  
    xPoly = real(vertex);  
    yPoly = imag(vertex);  
    xPoly = [xPoly real(vertex(1))];
    yPoly = [yPoly imag(vertex(1))];

    x_seg = [x1 x2];
    y_seg = [y1 y2];

    [x,y] = polyxpoly(x_seg, y_seg, xPoly, yPoly);

    if isempty(x)
        is_sect = false;
    else
        is_sect = true;
    end
end