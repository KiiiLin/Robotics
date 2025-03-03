clear all; clc; addpath(genpath('.'));

L(1) = Link([0 0 2 0], 'standard');
L(2) = Link([0 0 1 0], 'standard');
robot = SerialLink(L,'name', '2R-Robot');
%使用SerialLink 类建立该机构的机器人模型

t = 0:0.01:1;
N = length(t);
x_theory = zeros(1, N);
y_theory = zeros(1, N);
phi_theory = zeros(1, N);
q_traj = zeros(N, 2);
q0 = [0, 0];
%初始化参数

for i = 1:N
    x_theory(i) = 9/2 - 3*sin(pi/3*t(i) + pi/6);
    y_theory(i) = 3*sqrt(3)/2 - 3*cos(pi/3*t(i) + pi/6);
    phi_theory(i) = pi/3*t(i) + 2*pi/3;
    % 计算理论轨迹

    T_desired = SE3(x_theory(i), y_theory(i), 0) * SE3.Rz(phi_theory(i));
    q_sol = robot.ikine(T_desired, 'q0', q0, 'tol', 1e-6, 'mask', [1 1 0 0 0 0]);
    %逆解计算

    q_traj(i, :) = q_sol;
    q0 = q_sol;

end
%计算逆解并存储数据

%% 绘制θ1和θ2随时间的变化曲线
theta1_values = q_traj(:, 1)';
theta2_values = q_traj(:, 2)';

figure;
subplot(2,1,1);
plot(t, theta1_values, 'b-', 'LineWidth', 1.5);
title('关节角度 \theta_1 随时间变化');
grid on;

subplot(2,1,2);
plot(t, theta2_values, 'b-', 'LineWidth', 1.5);
title('关节角度 \theta_2 随时间变化');
grid on;

%% 绘制运动动画
figure;
robot.plot(q_traj, 'trail', 'r', 'fps', 60,  'noarrow');

%% 绘制末端轨迹图
T_achieved = robot.fkine(q_traj);
positions = arrayfun(@(T) T.t(1:2), T_achieved, 'UniformOutput', false);
traj_achieved = cell2mat(positions)';
%获得机构的末端位姿

figure;
plot(x_theory, y_theory, 'b-', 'LineWidth', 2); hold on;
plot(traj_achieved(:,1), traj_achieved(:,2), 'r--', 'LineWidth', 1.5);
xlabel('x'); ylabel('y');
legend('理论轨迹', '实际轨迹');
title('末端轨迹对比图');
grid on;
%绘制轨迹对比图

rmpath(genpath('.'))