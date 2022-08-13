%% 自写cubicSpline_2函数测试
clc;clear;
q1 = [0, 0.2, 0.4, 0.6, 0.8, 1];
q2 = [0, -0.4, -0.6, -0.8, -1, -1.2];
q3 = [0, 0.1, 0.2, 0.4, 0.6, 0.8];
q4 = [0, 0.1, 0.2, 0.4, 0.6, 0.8];
q=q1;
t = [0, 0.2, 0.4, 0.6, 0.8, 1];
n = length(t);
v0 = 0; vn = 0; tt = 0.05;
[yy dyy ddyy] = cubicSpline_2(q, t, v0, vn, tt);

subplot(3, 1, 1)
plot(t, q, 'o');
ylabel('位置')
grid on
hold on
plot([t(1):tt:t(n)], yy);
subplot(3, 1, 2)
plot([t(1), t(n)], [v0, vn], 'o');
grid on
hold on
plot([t(1):tt:t(n)], dyy);
ylabel('速度')
subplot(3, 1, 3)
grid on
hold on
plot([t(1):tt:t(n)], ddyy);
ylabel('加速度')