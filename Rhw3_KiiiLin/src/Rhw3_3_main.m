clear all; clc; addpath(genpath('.'));

L(1) = Link('d', 500, 'a', 0, 'alpha', -pi/2, 'offset', 0);
L(2) = Link('d', 0, 'a', 500, 'alpha', 0, 'offset', 0);
L(3) = Link('d', 0, 'a', 0, 'alpha', pi/2, 'offset', pi/2);
L(4) = Link('d', 600, 'a', 0, 'alpha', -pi/2, 'offset', 0);
L(5) = Link('d', 0, 'a', 0, 'alpha', pi/2, 'offset', 0);
L(6) = Link('d', 500, 'a', 0, 'alpha', 0, 'offset', 0);

Six_Link = SerialLink(L,'name','6R机械臂');
Six_Link.display ;
Six_Link.plot([0,0,0,0,0,0]);

rmpath(genpath('.'))