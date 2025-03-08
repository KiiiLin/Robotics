clear all; clc; addpath(genpath('.'));

function T_inv = inversion(T)
    R = T(1:3, 1:3);
    p = T(1:3, 4);
    % 提取旋转矩阵R和平移向量p

    R_inv = R';
    t_inv = -R_inv * p;
    T_inv = [R_inv, t_inv; 0 0 0 1];
    % 计算逆矩阵
end

T=[eul2rotm([0.1, 0.2, 0.3]), [1; 2; 3]; 0 0 0 1];
% 示例齐次矩阵

tic;
T_inv_custom = inversion(T);
time_custom = toc;

tic;
T_inv_matlab = inv(T);
time_matlab = toc;
% 求逆测试并记录时间

disp('程序求逆结果:');
disp(T_inv_custom);
disp('inv函数结果:');
disp(T_inv_matlab);
disp(['程序求逆时间: ', num2str(time_custom), ' 秒']);
disp(['inv函数求逆时间: ', num2str(time_matlab), ' 秒']);
% 对比结果

rmpath(genpath('.'))