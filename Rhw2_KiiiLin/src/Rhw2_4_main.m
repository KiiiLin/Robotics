clear all; clc; addpath(genpath('.'));

function inverse_solution(org_angle)

    R = eul2rotm(org_angle) ;
    
    alpha = atan(R(2,1)/R(1,1));
    beta = asin(-R(3,1));
    gamma = atan(R(3,2)/R(3,3)) ;
    
    eul_angles = [alpha, beta, gamma];
    
    disp('程序反解结果：');
    disp(eul_angles);
    disp('rotm2eul函数反解结果：');
    disp(rotm2eul(R));
    disp('原参数：');
    disp(org_angle);
end

disp('第一行数据验证：')
inverse_solution([10*pi/180, 20*pi/180, 30*pi/180]);
disp('第二行数据验证：')
inverse_solution([30*pi/180, 90*pi/180, -55*pi/180]);

rmpath(genpath('.'))