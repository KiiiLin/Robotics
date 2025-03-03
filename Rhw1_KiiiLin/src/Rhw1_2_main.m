clear all; clc; addpath(genpath('.'));

L(1) = Link([0 0 2 0], 'standard');
L(2) = Link([0 0 1 0], 'standard');
robot = SerialLink(L); 
%使用SerialLink 类建立该机构的机器人模型

q = [pi/6, pi/6];
T = robot.fkine(q);
J = robot.jacob0(q); 
%代入q参数计算末端位姿和Jacobian矩阵

x = T.t(1);      
y = T.t(2);      
phi = q(1) + q(2);
pose_vector = [x; y; phi];
J_linear = J([1,2,6], :);  
%删去无需参数

disp('末端位姿:');
disp(pose_vector);
disp('Jacobian矩阵:');
disp(J_linear); 
%输出末端位姿和Jacobian矩阵

rmpath(genpath('.'))