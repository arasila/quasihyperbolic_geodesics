filename = 'complex_data.txt';

% 读取文件内容
file_content = fileread(filename);

% 预处理：将复数格式转换为 MATLAB 可识别的格式
% 处理 a+bi 格式
file_content = regexprep(file_content, '([+-]?\d*\.?\d*)([+-]\d*\.?\d*)i', '($1+$2*1i)');
% 处理纯虚数 bi 格式
file_content = regexprep(file_content, '([+-]?\d*\.?\d*)i', '($1*1i)');
% 处理纯实数
file_content = regexprep(file_content, '\s([+-]?\d*\.?\d*)\s', ' ($1+0i) ');

% 写入临时文件
temp_filename = 'temp_processed.txt';
fid_temp = fopen(temp_filename, 'w');
fprintf(fid_temp, '%s', file_content);
fclose(fid_temp);

% 使用 textscan 读取
fid = fopen(temp_filename, 'r');
data_cell = textscan(fid, '%s', 'Delimiter', '\n', 'MultipleDelimsAsOne', true);
fclose(fid);

% 删除临时文件
delete(temp_filename);

% 解析数据
all_data = [];
for ii = 1:length(data_cell{1})
    line = data_cell{1}{ii};
    if ~isempty(line)
        % 使用 str2num 解析复数
        row_data = str2num(line); %#ok<ST2NM>
        all_data = [all_data; row_data]; %#ok<AGROW>
    end
end

err = 0;
c1 = sqrt(3)/4;
for jj = 1:length(all_data)
    temp = all_data(jj);
    rt = real(temp);
    for n = 1:3
        if rt >= (4*n-5)*c1-1e-8&& rt <= (4*n-3)*c1 + 1e-8
            t_dist = abs(rt - (n-1)*sqrt(3));
            break;
        elseif rt >= (4*n-3)*c1-1e-8&& rt <= (4*n-1)*c1 + 1e-8
            t_dist =  abs(rt - ((n-1)*sqrt(3) + sqrt(3)/2*1i));
            break;
        elseif rt <= -c1
            t_dist =  abs(rt-0);
            break;
        else
            t_dist =  abs(rt - 3*sqrt(3));
            break;
        end
    end
    err = abs(t_dist - 0.5);
end

err