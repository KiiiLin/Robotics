clear all; clc; addpath(genpath('.'));

L(1) = Link('d', 500, 'a', 0, 'alpha', -pi/2, 'offset', 0);
L(2) = Link('d', 0, 'a', 500, 'alpha', 0, 'offset', 0);
L(3) = Link('d', 0, 'a', 0, 'alpha', pi/2, 'offset', pi/2);
L(4) = Link('d', 600, 'a', 0, 'alpha', -pi/2, 'offset', 0);
L(5) = Link('d', 0, 'a', 0, 'alpha', pi/2, 'offset', 0);
L(6) = Link('d', 500, 'a', 0, 'alpha', 0, 'offset', 0);
Six_Link = SerialLink(L,'name','6R机械臂');

T = [-0.2357 -0.9120 -0.3358 42.18;
    0.8894 -0.3417 0.3037 -0.7691;
    -0.3918 -0.2271 0.8916 1892.0;
    0 0 0 1];

q0 = [-0.6, -0.7, -1, 0, 0, 0]; 
q = Six_Link.ikine(T, 'q0', q0);
disp('逆解结果1：');
disp(q);

q0 = [2.5, -0.7, -1, 0, 0, 0]; 
q = Six_Link.ikine(T, 'q0', q0);
disp('逆解结果2：');
disp(q);

q0 = [-0.6, -1.3, -1, 0, 0, 0]; 
q = Six_Link.ikine(T, 'q0', q0);
disp('逆解结果3：');
disp(q);

q0 = [2.5, -0.7, -1, 3, 0, 0]; 
q = Six_Link.ikine(T, 'q0', q0);
disp('逆解结果4：');
disp(q);


rmpath(genpath('.'))