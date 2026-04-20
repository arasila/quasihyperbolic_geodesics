function rst = generate_point_list(n, z0)
% 生成绕原点对称分布的点列表
% 输入:
%   n - 点数
%   z0 - 基准点
% 输出:
%   rst - 点坐标向量

temp_list = zeros(n, 1);
rho = abs(z0);
phi = angle(z0);
theta = 2 * pi / n;

for jj = 0:n-1
    temp_list(jj + 1) = rho * exp(1i * (phi + jj * theta));
end

rst = temp_list;
end