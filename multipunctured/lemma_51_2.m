%This program is write to provide experimental support for lemma 5.1 in the following paper
%R. Klén, A. Rasila and J. Talponen: On the smoothness of quasihyperbolic balls. Ann. Acad. Sci. Fenn. Math. 42 (2017), 439-452.
%Here I make the scale 10:1 to the examples in paper, in order to faciliate the program

close all
clear

% the points P1,P2 to be connected
P1= -0.5 + 0*i;
P2= (sqrt(3)*3+0.5) + 0*i;

% density of the grid (increment)
h=0.025;
dir = 4;

%number of inner polygons
in_poly = 4;

% outer polygon
vertOut = [-1-i;(3*sqrt(3)+1)-i;(3*sqrt(3)+1)+i;-1+i];
%vertOut = vertOut*10;
vertcOut = [vertOut;vertOut(1)];
% inner polygon
vertInt = [sqrt(3)/2+0.5i; sqrt(3)/2+i];
%vertInt = vertInt*10;
vertcInt = [vertInt;vertInt(1)];

% Define the second inner polygon (second obstacle)
vertInt2 = [sqrt(3)/2-0.5i; sqrt(3)/2-i];
%vertInt2 = vertInt2*10;
vertcInt2 = [vertInt2; vertInt2(1)];

vertInt3 = [1.5*sqrt(3)+0.5i; 1.5*sqrt(3)+i];
vertcInt3 = [vertInt3; vertInt3(1)];

vertInt4 = [1.5*sqrt(3)-0.5i; 1.5*sqrt(3)-i];
vertcInt4 = [vertInt4; vertInt4(1)];

vertInt5 = [2.5*sqrt(3)+0.5i; 2.5*sqrt(3)+i];
vertcInt5 = [vertInt5; vertInt5(1)];

vertInt6 = [2.5*sqrt(3)-0.5i; 2.5*sqrt(3)-i];
vertcInt6 = [vertInt6; vertInt6(1)];

vertpcInt1 = 0+0*i;
vertpcInt2 = sqrt(3)+0*i;
vertpcInt3 = 2*sqrt(3)+0*i;
vertpcInt4 = 3*sqrt(3)+0*i;

% construct obs_list
obs_list = {vertcInt.', vertcInt2.', vertcInt3.', vertcInt4.', vertcInt5.', vertcInt6.',...
            vertpcInt1.',vertpcInt2.',vertpcInt3.',vertpcInt4.'};


obs_list2 = {vertcOut.'};

% generate the mesh
xmi=real(P1); xma=real(P2);
ymi=min(imag(vertOut))-1; yma=max(imag(vertOut))+1;
[xx,yy] = meshgrid(double(xmi:h:xma),double(ymi:h:yma));
zz = xx+i*yy;
% screen points outside the outer polygon or on the boundary
[in1,on1] = inpolygon(xx,yy,real(vertcOut),imag(vertcOut));
% ~ means not
zz(~in1) = NaN+i*NaN; zz(on1) = NaN+i*NaN;


% screen points inside the inner polygon or on the boundary
[in2,on2] = inpolygon(xx,yy,real(vertcInt),imag(vertcInt));
[in3,on3] = inpolygon(xx,yy,real(vertcInt2), imag(vertcInt2));
[in4,on4] = inpolygon(xx,yy,real(vertcInt3), imag(vertcInt3));
[in5,on5] = inpolygon(xx,yy,real(vertcInt4), imag(vertcInt4));
[in6,on6] = inpolygon(xx,yy,real(vertcInt5), imag(vertcInt5));
[in7,on7] = inpolygon(xx,yy,real(vertcInt6), imag(vertcInt6));
zz(in2) = NaN+i*NaN; zz(on2) = NaN+i*NaN;
zz(in3) = NaN+i*NaN; zz(on3) = NaN+i*NaN;
zz(in4) = NaN+i*NaN; zz(on4) = NaN+i*NaN;
zz(in5) = NaN+i*NaN; zz(on5) = NaN+i*NaN;
zz(in6) = NaN+i*NaN; zz(on6) = NaN+i*NaN;
zz(in7) = NaN+i*NaN; zz(on7) = NaN+i*NaN;


zz = zz(imag(zz) >= 0);
zz = zz(0.5 >= imag(zz));
zv = zz(abs(zz)>=0);

zv2 = zv;
for jj = 1:length(zv2)
    if real(zv2(jj)) >= sqrt(3)/2 && 2.5*sqrt(3) >= real(zv2(jj))
        zv2(jj) = conj(zv2(jj));
    end
end

% Here if we do not want whitney, just annotate the following two lines
% itr_num = 1
% zv = whitney(zv, h, itr_num, obs_list2, obs_list);

zv = [zv; P1];
zv = [zv; P2];

n=length(zv);

%plot part
%plot(real(zv), imag(zv),'c.')
%hold on
plot(real(P1), imag(P1), 'o', 'MarkerSize', 2, 'MarkerFaceColor', 'black');
hold on;
plot(real(P2), imag(P2), 'o', 'MarkerSize', 2, 'MarkerFaceColor', 'black');
hold on;

plot(real(vertcOut), imag(vertcOut),'k-',...
     real(vertcInt), imag(vertcInt),'k-',...
     real(vertcInt2), imag(vertcInt2),'k-',...
     real(vertcInt3), imag(vertcInt3),'k-',...
     real(vertcInt4), imag(vertcInt4),'k-',...
     real(vertcInt5), imag(vertcInt5),'k-',...
     real(vertcInt6), imag(vertcInt6),'k-','LineWidth',2)
hold on

plot(real(vertpcInt1), imag(vertpcInt1),'o', 'MarkerSize', 5, 'MarkerFaceColor', 'black');
plot(real(vertpcInt2), imag(vertpcInt2),'o', 'MarkerSize', 5, 'MarkerFaceColor', 'black');
plot(real(vertpcInt3), imag(vertpcInt3),'o', 'MarkerSize', 5, 'MarkerFaceColor', 'black');
plot(real(vertpcInt4), imag(vertpcInt4),'o', 'MarkerSize', 5, 'MarkerFaceColor', 'black');
hold on
%for jj=1:n
%    text(real(zv(jj))+0.05, imag(zv(jj)),num2str(jj));
%end

widemarg(gcf)
n=length(zv);
distzvbry=zeros(1,n);
19
for jj=1:n
    distzvbry(jj)=min([polydistNew(zv(jj,1),vertcInt),...
                       polydistNew(zv(jj,1),vertcInt2),...
                       polydistNew(zv(jj,1),vertcInt3),...
                       polydistNew(zv(jj,1),vertcInt4),...
                       polydistNew(zv(jj,1),vertcInt5),...
                       polydistNew(zv(jj,1),vertcInt6),...
                       polydistNew(zv(jj,1),vertpcInt1),...
                       polydistNew(zv(jj,1),vertpcInt2),...
                       polydistNew(zv(jj,1),vertpcInt3),...
                       polydistNew(zv(jj,1),vertpcInt4),...
                       polydistNew(zv(jj,1),vertcOut)]) ;
end
20
mys=zeros(1,4*n);
myt=zeros(1,4*n);
ind=1;
for jj=1:n
    for kk=1:n
        if dir*h - 1e-8 <= abs(zv(jj,1)-zv(kk,1)) &&...
            abs(zv(jj,1)-zv(kk,1)) <= sqrt(2) * dir * h + 1e-8&&(jj~=kk)
          mys(ind) =jj; myt(ind)=kk;
          ind=ind+1;
        end
    end
end
21
A=[mys'  myt'];
A1=unique(A,'rows');
mys=A1 (:,1)'; myt=A1 (:,2)';
ind=ind-1;

% compute the discrete weigh function (conformal density)
myw=zeros(1,ind);
for jj=1:length(myw)
    ps = zv(mys(1,jj));
    pt = zv(myt(1,jj));
    %pm = 0.5*(ps+pt);

    temp1 = check_intersect(ps, pt, obs_list);
    %temp2 = check_intersect(ps, pt, obs_list2);
    %temp3 = check_intersect2(pm, obs_list);
    %temp4 = check_intersect2(pm, obs_list2);

    if  temp1 == 0
        myw(1,jj)=abs(ps-pt)/min(distzvbry(mys(1,jj)), distzvbry(myt(1,jj)));
    else
        myw(1,jj) = inf;
    end
end

%figure
myG = digraph(mys(1,1:length(myw)),myt(1,1:length(myw)),myw(1,1:length(myw)));
%plot(myG,'EdgeLabel',myG.Edges.Weight)
d=distances(myG);

% first find indices of the closes grid points to the points P1,P2

[val1,idx1]= min(abs(zv-P1));
[val2,idx2]= min(abs(zv-P2));

% P = shortestpath(G,s,t) computes the shortest path between nodes
myshort=shortestpath(myG, idx1,idx2);
len1=0;
for jj=1:(length(myshort)-1)
   len1=len1+d(myshort(jj),myshort(jj+1));  
end
fprintf('Length of initial geodesic path= %12.5f\n',len1)
fprintf('Initial geodesic nodes: ')
fprintf('%4d',myshort)
fprintf('\n')

figure(1)
hold on
plot(real(zv(myshort)),imag(zv(myshort)), 'g-','LineWidth',1.5)
%title(sprintf('P1= %.3f + %.3fi; P2= %.3f + %.3fi; d_h = %.3f; dir = %d', real(P1), imag(P1), real(P2), imag(P2), h,dir));
axis equal;

zv2 = [zv2; P1];
zv2 = [zv2; P2];
n=length(zv2);
distzvbry=zeros(1,n);
19
for jj=1:n
    distzvbry(jj)=min([polydistNew(zv2(jj,1),vertcInt),...
                       polydistNew(zv2(jj,1),vertcInt2),...
                       polydistNew(zv2(jj,1),vertcInt3),...
                       polydistNew(zv2(jj,1),vertcInt4),...
                       polydistNew(zv2(jj,1),vertcInt5),...
                       polydistNew(zv2(jj,1),vertcInt6),...
                       polydistNew(zv2(jj,1),vertpcInt1),...
                       polydistNew(zv2(jj,1),vertpcInt2),...
                       polydistNew(zv2(jj,1),vertpcInt3),...
                       polydistNew(zv2(jj,1),vertpcInt4),...
                       polydistNew(zv2(jj,1),vertcOut)]) ;
end
20
mys=zeros(1,4*n);
myt=zeros(1,4*n);
ind=1;
for jj=1:n
    for kk=1:n
        if dir*h - 1e-8 <= abs(zv2(jj,1)-zv2(kk,1)) &&...
            abs(zv2(jj,1)-zv2(kk,1)) <= sqrt(2) * dir * h + 1e-8&&(jj~=kk)
          mys(ind) =jj; myt(ind)=kk;
          ind=ind+1;
        end
    end
end
21
A=[mys'  myt'];
A1=unique(A,'rows');
mys=A1 (:,1)'; myt=A1 (:,2)';
ind=ind-1;

% compute the discrete weigh function (conformal density)
myw=zeros(1,ind);
for jj=1:length(myw)
    ps = zv2(mys(1,jj));
    pt = zv2(myt(1,jj));
    %pm = 0.5*(ps+pt);

    temp1 = check_intersect(ps, pt, obs_list);
    %temp2 = check_intersect(ps, pt, obs_list2);
    %temp3 = check_intersect2(pm, obs_list);
    %temp4 = check_intersect2(pm, obs_list2);

    if  temp1 == 0
        myw(1,jj)=abs(ps-pt)/min(distzvbry(mys(1,jj)), distzvbry(myt(1,jj)));
    else
        myw(1,jj) = inf;
    end
end

%figure
myG = digraph(mys(1,1:length(myw)),myt(1,1:length(myw)),myw(1,1:length(myw)));
%plot(myG,'EdgeLabel',myG.Edges.Weight)
d=distances(myG);

% first find indices of the closes grid points to the points P1,P2

[val1,idx1]= min(abs(zv2-P1));
[val2,idx2]= min(abs(zv2-P2));

% P = shortestpath(G,s,t) computes the shortest path between nodes
myshort=shortestpath(myG, idx1,idx2);
len1=0;
for jj=1:(length(myshort)-1)
   len1=len1+d(myshort(jj),myshort(jj+1));  
end
fprintf('Length of initial geodesic path= %12.5f\n',len1)
fprintf('Initial geodesic nodes: ')
fprintf('%4d',myshort)
fprintf('\n')

figure(1)
hold on
plot(real(zv2(myshort)),imag(zv2(myshort)), 'k:','LineWidth',1.5)


% 移除坐标轴和边框
set(gca, 'Visible', 'off');

% 确保图形充满整个figure
set(gca, 'Position', [0 0 1 1]);
%set(gcf, 'Color', 'none');

% 创建复数数据
final_data = zv(myshort);
final_data = final_data.';

% 写入文件，MATLAB 会自动以 a+bi 格式写入
%dlmwrite('complex_data.txt', final_data, 'delimiter', '\t', '-append');







function val = integrand3(t, z1, z2)
    % outer polygon
    vertOut = [-1-i;(sqrt(3)+1)-i;(sqrt(3)+1)+i;-1+i];
    %vertOut = vertOut*10;
    vertcOut = [vertOut;vertOut(1)];
    % inner polygon
    vertInt = [sqrt(3)/2+0.5i; sqrt(3)/2+i];
    %vertInt = vertInt*10;
    vertcInt = [vertInt;vertInt(1)];

    % Define the second inner polygon (second obstacle)
    vertInt2 = [sqrt(3)/2-0.5i; sqrt(3)/2-i];
    %vertInt2 = vertInt2*10;
    vertcInt2 = [vertInt2; vertInt2(1)];

    % Define the third inner polygon (second obstacle)
    %vertInt3 = [0+0*i; 0+0.01*i; 0.01+0.01*i; 0.01+0*i];
    %vertInt3 = vertInt3*10;
    %vertcInt3 = [vertInt3; vertInt3(1)];
    vertcInt3 = 0+0*i;

    % Define the fourth inner polygon (second obstacle)
    %vertInt4 = [sqrt(3)+0*i; sqrt(3)+0.01*i; sqrt(3)+0.01+0.01*i; sqrt(3)+0.01+0*i];
    %vertInt4 = vertInt4*10;
    %vertcInt4 = [vertInt4; vertInt4(1)];
    vertcInt4 = sqrt(3)+0*i;


    % 直线段参数化
    z = z1 + t.*(z2 - z1);
    
    % 计算被积函数：2|dz|/(1-|z|^2)
    dz = z2 - z1;
    val = abs(dz) ./ min([polydistNew(z,vertcInt),...
                          polydistNew(z,vertcInt2),...
                          polydistNew(z,vertcInt3),...
                          polydistNew(z,vertcInt4),...
                          polydistNew(z,vertcOut)]) ;
end

function dist = adaptive_hyperbolic3(z1, z2, tol)
    % 使用直线段参数化的自适应积分
    f = @(t) integrand3(t, z1, z2);
    
    max_depth = 20;  
    min_interval = 1e-10;  
    dist = adaptive_recursive(f, 0, 1, tol, max_depth, min_interval, 0);
end

function I = adaptive_recursive(f, a, b, tol, max_depth, min_interval, depth)
    % 自适应积分递归函数（通用）
    if depth > max_depth || (b - a) < min_interval
        c = (a + b)/2;
        I = (b - a)/6 * (f(a) + 4*f(c) + f(b));
        return;
    end
    
    c = (a + b)/2;
    
    % Simpson 公式计算
    I1 = (b - a)/6 * (f(a) + 4*f(c) + f(b));
    
    % 更精细的分割
    d = (a + c)/2;
    e = (c + b)/2;
    I2_left = (c - a)/6 * (f(a) + 4*f(d) + f(c));
    I2_right = (b - c)/6 * (f(c) + 4*f(e) + f(b));
    I2 = I2_left + I2_right;
    
    % 误差估计
    err = abs(I1 - I2);
    
    if err < 15 * tol  
        I = I2 + (I2 - I1)/15;  % Richardson 外推
    else
        % 递归细分区间
        I = adaptive_recursive(f, a, c, tol/2, max_depth, min_interval, depth+1) + ...
            adaptive_recursive(f, c, b, tol/2, max_depth, min_interval, depth+1);
    end
end
