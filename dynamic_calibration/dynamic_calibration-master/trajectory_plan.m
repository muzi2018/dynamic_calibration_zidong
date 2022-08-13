%% 自写cubicSpline_2函数测试
clc;clear;
q1 = [0, 0.2, 0.4, 0.6, 0.8, 1];
q2 = [0, -0.4, -0.6, -0.8, -1, -1.2];
q3 = [0, 0.1, 0.2, 0.4, 0.6, 0.8];
q4 = [0, 0.1, 0.2, 0.4, 0.6, 0.8];
q=q1;
t = [0, 2, 4, 6, 8, 10];
n = length(t);
v0 = 0; vn = 0; tt = 0.5;
[yy_1 dyy_1 ddyy_1] = cubicSpline_2(q1, t, v0, vn, tt);
[yy_2 dyy_2 ddyy_2] = cubicSpline_2(q2, t, v0, vn, tt);
[yy_3 dyy_3 ddyy_3] = cubicSpline_2(q3, t, v0, vn, tt);
[yy_4 dyy_4 ddyy_4] = cubicSpline_2(q4, t, v0, vn, tt);

index=size(yy_1);
fprintf('const std::vector<double> q1 = {');
for i=1:index(1,2)
    fprintf('%f', yy_1(1,i));
    fprintf(', ');
end
fprintf('};\n');

fprintf('const std::vector<double> q2 = {');
for i=1:index(1,2)
    fprintf('%f', yy_2(1,i));
    fprintf(', ');
end
fprintf('};\n');

fprintf('const std::vector<double> q3 = {');
for i=1:index(1,2)
    fprintf('%f', yy_3(1,i));
    fprintf(', ');
end
fprintf('};\n');

fprintf('const std::vector<double> q4 = {');
for i=1:index(1,2)
    fprintf('%f', yy_4(1,i));
    fprintf(', ');
end
fprintf('};\n');




fprintf('const std::vector<double> dq1 = {');
for i=1:index(1,2)
    fprintf('%f', dyy_1(1,i));
    fprintf(', ');
end
fprintf('};\n');

fprintf('const std::vector<double> dq2 = {');
for i=1:index(1,2)
    fprintf('%f', dyy_2(1,i));
    fprintf(', ');
end
fprintf('};\n');

fprintf('const std::vector<double> dq3 = {');
for i=1:index(1,2)
    fprintf('%f', dyy_3(1,i));
    fprintf(', ');
end
fprintf('};\n');

fprintf('const std::vector<double> dq4 = {');
for i=1:index(1,2)
    fprintf('%f', dyy_4(1,i));
    fprintf(', ');
end
fprintf('};\n');



fprintf('const std::vector<double> ddq1 = {');
for i=1:index(1,2)
    fprintf('%f', ddyy_1(1,i));
    fprintf(', ');
end
fprintf('};\n');

fprintf('const std::vector<double> ddq2 = {');
for i=1:index(1,2)
    fprintf('%f', ddyy_2(1,i));
    fprintf(', ');
end
fprintf('};\n');

fprintf('const std::vector<double> ddq3 = {');
for i=1:index(1,2)
    fprintf('%f', ddyy_3(1,i));
    fprintf(', ');
end
fprintf('};\n');

fprintf('const std::vector<double> ddq4 = {');
for i=1:index(1,2)
    fprintf('%f', ddyy_4(1,i));
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