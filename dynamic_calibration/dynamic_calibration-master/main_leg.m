clear all; close all; clc;

% Define path to a urdf file
% path_to_urdf = 'leg.urdf';
% generate_legs_regressor(path_to_urdf);  

% Perform QR decompostion in order to get base parameters of the robot
include_motor_dynamics = 0;
[pi_lgr_base, baseQR] = base_params_qr(include_motor_dynamics);
