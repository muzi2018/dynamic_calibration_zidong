% 三次样条：指定初始速度v0和终止速度vn，但是中间点速度未知
% Input：
%   q：给定点的位置
%   t：给定点位置对应的时间
%   v0：初始速度
%   vn：终止速度
%   tt：插补周期
% Output：
%   yy dyy ddyy：样条曲线函数值、速度、加速度值
function [yy dyy ddyy] = cubicSpline_2(q, t, v0, vn, tt);
if length(q) ~= length(t)
    error('输入的数据应成对');
end
n = length(q);
c = zeros(n-2, 1);
% 矩阵A是个(n-2)*(n-2)的对角占优矩阵
A = zeros(n-2);
for i = 1: n-2
    Tk_1 = t(i+2) - t(i+1);
    Tk = t(i+1) - t(i);
    if i == 1
        A(i, i) = 2*(Tk + Tk_1);
        A(i, i+1) = Tk;
        c(i, 1) = (3/(Tk*Tk_1))*(Tk^2*(q(i+2)-q(i+1))+Tk_1^2*(q(i+1)-q(i))) - Tk_1*v0;
    elseif i == n-2
        A(i, i-1) = Tk_1;
        A(i, i) = 2*(Tk + Tk_1);
        c(i, 1) = (3/(Tk*Tk_1))*(Tk^2*(q(i+2)-q(i+1))+Tk_1^2*(q(i+1)-q(i))) - Tk*vn;
    else
        A(i, i-1) = Tk_1;
        A(i, i) = 2*(Tk + Tk_1);
        A(i, i+1) = Tk;
        c(i, 1) = (3/(Tk*Tk_1))*(Tk^2*(q(i+2)-q(i+1))+Tk_1^2*(q(i+1)-q(i)));

    end
end
% 经过上述步骤得到对角占优矩阵A和c
% vk = A \ c; % 这一步matlab计算很慢，应换成追赶法求vk
for i = 1: n-2
    a(i) = A(i, i); % 对角线
    if i == n-3
        b(i) = A(i, i+1); % 上边
        d(i) = A(i+1, i); % 下边
        continue;
    elseif i < n-2
        b(i) = A(i, i+1); % 上边
        d(i) = A(i+1, i); % 下边
    end
end
[~, ~, vk] = crout(a, b, d, c); % 追赶法

% 得到中间插补点的速度vk，然后调用cubicSpline_1即可
v_ = [v0, vk, vn];
[yy dyy ddyy] = cubicSpline_1(q, t, v_, tt);

end


%追赶法求解三对角线性方程组，Ax=b，A用一维数组a，c，d存储。
function [L,U,x]=crout(a,c,d,b)%数组a存储三角矩阵A的主对角线元素，c、d存储主对角线上边下边带宽为1的元素
    n=length(a);
    n1=length(c);
    n2=length(d);
    %错误检查
    if n1~=n2%存储矩阵的数组维数错误
        error('MATLAB:Crout:不是三对角矩阵，参数数组中元素个数错误.');
    elseif n~=n1+1
        error('MATLAB:Crout:不是三对角矩阵，参数数组中元素个数错误.');
    end

    %初始化
    L=zeros(n);%生成n*n的全零矩阵
    U=zeros(n);
    p=1:n;
    q=1:n-1;
    x=1:n;
    y=1:n;

    %追赶法程序主体
    p(1)=a(1);
    for i=1:n-1
        q(i)=c(i)/p(i);
        p(i+1)=a(i+1)-d(i)*q(i);%d的下标改为1到n-1
    end
    %正解y
    y(1)=b(1)/p(1);%用x存储y
    for i=2:n
        y(i)=(b(i)-d(i-1)*y(i-1))/p(i);
    end
    %倒解x
    x(n)=y(n);
    for i=(n-1):-1:1
        x(i)=y(i)-q(i)*x(i+1);
    end
    %L,U矩阵
    for i=1:n
        L(i,i)=p(i);
        U(i,i)=1;
    end
    for i=1:n-1
        L(i+1,i)=d(i);
        U(i,i+1)=q(i);
    end
end %end of function



% 三次样条：指定初始速度v0和终止速度vn，并且中间插补点的速度已知，这是最简单的情况
% Input：
%   q：给定点的位置
%   t：给定点位置对应的时间
%   v：包括给定起始、中间及终止速度的速度向量
%   tt：插补周期
% Output：
%   yy dyy ddyy：样条曲线函数值、速度、加速度值
function [yy dyy ddyy] = cubicSpline_1(q, t, v, tt)
if length(q) ~= length(t)
    error('输入的数据应成对')
end
n = length(q);
T = t(n) - t(1); % 运行总时长
nn = T / tt; % 总点数
yy = zeros(1, nn);
dyy = zeros(1, nn);
ddyy = zeros(1, nn);
j = 1;
for i = 1: n-1
    Tk = t(i+1) - t(i);
    a0 = q(i);
    a1 = v(i);
    a2 = (1/Tk) * ((3*(q(i+1)-q(i)))/Tk - 2*v(i) - v(i+1));
    a3 = (1/(Tk*Tk)) * ((2*(q(i)-q(i+1)))/Tk + v(i) + v(i+1));

    for tk = t(i): tt: t(i+1)
        if i > 1 && tk == t(i)
            continue
        end
        yy(j) = a0 + a1*(tk-t(i)) + a2*power(tk-t(i), 2) + a3*power(tk-t(i), 3);
        dyy(j) = a1 + 2*a2*(tk-t(i)) + 3*a3*power(tk-t(i), 2);
        ddyy(j) = 2*a2 + 6*a3*(tk-t(i));
        j = j + 1;
    end
end

end