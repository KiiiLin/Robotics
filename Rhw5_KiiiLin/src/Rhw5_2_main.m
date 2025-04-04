clear all; clc; addpath(genpath('.'));

%% 定义机械臂与任务点
L(1) = Link('d', 2, 'a', 0, 'alpha',0 , 'offset', 0, 'modified');
L(2) = Link('d', 0, 'a', 0, 'alpha',-pi/2 , 'offset', 0, 'modified');
L(3) = Link('d', 0, 'a', 1, 'alpha',0 , 'offset', -pi/2, 'modified');
L(4) = Link('d', 2, 'a', 0, 'alpha',-pi/2 , 'offset', 0, 'modified');
L(5) = Link('d', 0, 'a', 0, 'alpha',pi/2 , 'offset', 0, 'modified');
L(6) = Link('d', 2, 'a', 0, 'alpha', -pi/2, 'offset', 0, 'modified');

Six_Link = SerialLink(L,'name','6R机械臂');
%Six_Link.display ;

T1 = [0 0 1 3; 0 -1 0 -2; 1 0 0 0; 0 0 0 1];
T2 = [0 0 1 3; 0 -1 0 2; 1 0 0 2; 0 0 0 1];
T3 = [0 0 1 3; 0 -1 0 -2; 1 0 0 4; 0 0 0 1];

%% 计算
% 计算对应关节角
q0 = [0,1,1,0,0,0] ;
q1 = Six_Link.ikine(T1,'q0', q0, 'tol', 1e-4, 'ilimit', 2000, 'rlimit', 1000);
q2 = Six_Link.ikine(T2,'q0', q1, 'tol', 1e-4, 'ilimit', 2000, 'rlimit', 1000);
q3 = Six_Link.ikine(T3,'q0', q2, 'tol', 1e-4, 'ilimit', 2000, 'rlimit', 1000);

% 对各关节角进行插值
t_points = [0, 1, 2];
q_points = [q1; q2; q3];
time_b = linspace(0, 2, 100);
q_b = zeros(100, 6);
for j = 1:6
    q_b(:, j) = interp1(t_points, q_points(:, j), time_b, 'spline');
end

% 计算末端平移向量与旋转向量
pos_b = zeros(100, 3);
eul_b = zeros(100, 3);
for i = 1:100
    T = Six_Link.fkine(q_b(i, :));
    pos_b(i, :) = transl(T);
    eul_b(i, :) = tr2rpy(T);
end

%% 绘制末端平移向量-时间图
figure('Name','末端平移向量-时间图');
subplot(3, 1, 1); plot(time_b, pos_b(:, 1)); ylabel('X');
subplot(3, 1, 2); plot(time_b, pos_b(:, 2)); ylabel('Y');
subplot(3, 1, 3); plot(time_b, pos_b(:, 3)); ylabel('Z');

%% 绘制末端旋转向量-时间图
figure('Name','末端旋转向量-时间图');
subplot(3, 1, 1); plot(time_b, eul_b(:, 1)); ylabel('Roll');
subplot(3, 1, 2); plot(time_b, eul_b(:, 2)); ylabel('Pitch');
subplot(3, 1, 3); plot(time_b, eul_b(:, 3)); ylabel('Yaw');

%% 绘制关节角的轨迹图
figure('Name','关节角轨迹图');
for j = 1:6
    subplot(6, 1, j);
    plot(time_b, q_b(:, j));
    ylabel(['关节', num2str(j)]);
end
xlabel('时间 (s)');

%% 绘制仿真动画
figure('Name','仿真动画');
Six_Link.plot(q_b, 'trail', 'r-', 'loop');

rmpath(genpath('.'))