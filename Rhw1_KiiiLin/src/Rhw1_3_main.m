clear all; clc; addpath(genpath('.'));

L(1) = Link([0 0 2 0], 'standard');
L(2) = Link([0 0 1 0], 'standard');
robot = SerialLink(L); 
%使用SerialLink 类建立该机构的机器人模型

x=input('请输入x：');
y=input('请输入y：');
phi=input('请输入phi：');
p = [x, y, phi] ;
%读入p数据

L1 = 2; L2 = 1;
r_min = abs(L1 - L2); 
r_max = L1 + L2;      
target_radius = sqrt(x^2 + y^2);
if target_radius < r_min || target_radius > r_max
    error('无法求解！');
end
%计算解是否存在，不存在时报错

T_desired = SE3(p(1), p(2), 0) * SE3.Rz(p(3));
q0 = [0,0];
options = optimset('Display', 'off');
q_sol = robot.ikine(T_desired, 'q0', q0, 'tol', 1e-6, 'mask', [1 1 0 0 0 0]);
disp('求解q为:');
disp(q_sol);
%使用ikine函数运动学反解

rmpath(genpath('.'))

