clear all; clc; addpath(genpath('.'));

%% 定义机械臂与任务点
L(1) = Link('d', 500, 'a', 0, 'alpha',0 , 'offset', 0, 'modified');
L(2) = Link('d', 0, 'a', 0, 'alpha',-pi/2 , 'offset', 0, 'modified');
L(3) = Link('d', 0, 'a', 500, 'alpha',0 , 'offset', pi/2, 'modified');
L(4) = Link('d', 600, 'a', 0, 'alpha',pi/2 , 'offset', 0, 'modified');
L(5) = Link('d', 0, 'a', 0, 'alpha',-pi/2 , 'offset', 0, 'modified');
L(6) = Link('d', 500, 'a', 0, 'alpha', pi/2, 'offset', 0, 'modified');

Six_Link = SerialLink(L,'name','6R机械臂');
%Six_Link.display ;

T1 = [0 0 1 3; 0 -1 0 -2; 1 0 0 0; 0 0 0 1];
T2 = [0 0 1 3; 0 -1 0 2; 1 0 0 2; 0 0 0 1];
T3 = [0 0 1 3; 0 -1 0 -2; 1 0 0 4; 0 0 0 1];

%% 计算
% 末端轨迹插值
traj1 = ctraj(T1, T2, 50);
traj2 = ctraj(T2, T3, 50);
traj_a = cat(3, traj1, traj2);

% 计算关节角
q_a = zeros(100, 6);
q0 = [0,1,1,0,0,0] ;
for i = 1:size(traj_a, 3)
    q_i = Six_Link.ikine(traj_a(:, :, i), 'q0', q0, 'tol', 1e-5, 'ilimit', 2000 ,'rlimit',1000);
    q_a(i, :) = q_i;
    q0 = q_i;
end

%% 绘制末端平移向量-时间图
time_a = linspace(0, 2, 100);
pos_a = transl(traj_a);
figure('Name','末端平移向量-时间图');
subplot(3, 1, 1); plot(time_a, pos_a(:, 1)); ylabel('X');
subplot(3, 1, 2); plot(time_a, pos_a(:, 2)); ylabel('Y');
subplot(3, 1, 3); plot(time_a, pos_a(:, 3)); ylabel('Z');

%% 绘制末端旋转向量-时间图
eul_a = zeros(size(traj_a,3),3);
for k = 1:size(traj_a,3)
    q = dcm2quat(traj_a(1:3,1:3,k)) ;
    eul_a(k,:) = quat2angle(q,'zyx'); 
end
figure('Name','末端旋转向量-时间图');
subplot(3, 1, 1); plot(time_a, eul_a(:, 1)); ylabel('Roll');
subplot(3, 1, 2); plot(time_a, eul_a(:, 2)); ylabel('Pitch');
subplot(3, 1, 3); plot(time_a, eul_a(:, 3)); ylabel('Yaw');

%% 绘制关节角的轨迹图
figure('Name','关节角轨迹图');
for j = 1:6
    subplot(6, 1, j);
    plot(time_a, q_a(:, j));
    ylabel(['关节', num2str(j)]);
end
xlabel('时间 (s)');

%% 绘制仿真动画
figure('Name','仿真动画');
Six_Link.plot(q_a, 'trail', 'r-', 'loop');

rmpath(genpath('.'))