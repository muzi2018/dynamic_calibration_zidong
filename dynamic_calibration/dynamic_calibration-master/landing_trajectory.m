%% 自写cubicSpline_2函数测试
clc;clear;
% simu_data
% q1 = [0, 0.2, 0.4, 0.6, 0.8, 1];
% q2 = [0, -0.4, -0.6, -0.8, -1, -1.2];
% q3 = [0, 0.1, 0.2, 0.4, 0.6, 0.8];
% q4 = [0, 0.1, 0.2, 0.4, 0.6, 0.8];

% vali_data

x = [-0.02, -0.01, -0.008, 0];
z = [0.52, 0.48, 0.45, 0.42];

t = [0, 0.4, 0.8, 1];
n = length(t);
v0 = 0.42; vn = 0; tt = 0.1;
[yy_1 dyy_1 ddyy_1] = cubicSpline_2(x, t, v0, vn, tt);
[yy_2 dyy_2 ddyy_2] = cubicSpline_2(z, t, v0, vn, tt);


index=size(yy_1);
fprintf('const std::vector<double> x_ref_landing_temp = {');
for i=1:index(1,2)
    fprintf('%f', yy_1(1,i));
    fprintf(', ');
end
fprintf('};\n');

fprintf('const std::vector<double> z_ref_landing = {');
for i=1:index(1,2)
    fprintf('%f', yy_2(1,i));
    fprintf(', ');
end
fprintf('};\n');


fprintf('const std::vector<double> xdot_ref_landing = {');
for i=1:index(1,2)
    fprintf('%f', dyy_1(1,i));
    fprintf(', ');
end
fprintf('};\n');

fprintf('const std::vector<double> zdot_ref_landing = {');
for i=1:index(1,2)
    fprintf('%f', dyy_2(1,i));
    fprintf(', ');
end
fprintf('};\n');


fprintf('const std::vector<double> xddot_ref_landing = {');
for i=1:index(1,2)
    fprintf('%f', ddyy_1(1,i));
    fprintf(', ');
end
fprintf('};\n');

fprintf('const std::vector<double> zddot_ref_landing = {');
for i=1:index(1,2)
    fprintf('%f', ddyy_2(1,i));
    fprintf(', ');
end
fprintf('};\n');




subplot(3, 1, 1)
plot(t, q, 'o');
ylabel('位置')
grid on
hold on
plot([t(1):tt:t(n)], yy_1);
subplot(3, 1, 2)
plot([t(1), t(n)], [v0, vn], 'o');
grid on
hold on
plot([t(1):tt:t(n)], dyy_1);
ylabel('速度')
subplot(3, 1, 3)
grid on
hold on
plot([t(1):tt:t(n)], ddyy_1);
ylabel('加速度')