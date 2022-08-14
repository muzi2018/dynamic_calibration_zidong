clear all; close all; clc;

% Define path to a urdf file
path_to_urdf = 'leg.urdf';
ur10 = parse_urdf(path_to_urdf);
% generate_legs_regressor(path_to_urdf);  
% generate_legs_regressor(path_to_urdf);
% Perform QR decompostion in order to get base parameters of the robot
include_motor_dynamics = 0;
[pi_lgr_base, baseQR] = base_params_qr_leg(include_motor_dynamics);
path_to_est_data=struct();
load('path_to_est_data.mat');
idxs = [635, 3510];
drive_gains = [14.87; 13.26; 11.13; 10.62; 11.03; 11.47]; 

sol = estimate_dynamic_params_leg(path_to_est_data, idxs, ...
                              drive_gains, baseQR, 'OLS');
                          





load('path_to_val_data.mat');
idxs = [700, 4200];
rre = validate_dynamic_params_leg(path_to_val_data, idxs, ...
                              drive_gains, baseQR, sol.pi_b, sol.pi_fr);

beta = baseQR.beta;
bb = baseQR.numberOfBaseParameters;
E = baseQR.permutationMatrix;
pi_full(1:10,1)=ur10.pi(1:10,1);
pi_full(11:20,1)=ur10.pi(1:10,2);
pi_full(21:30,1)=ur10.pi(1:10,3);
pi_full(31:40,1)=ur10.pi(1:10,4);
pi_lgr_base = [eye(bb) beta]*E'*ur10.pi;


E1=baseQR.permutationMatrix(:,1:baseQR.numberOfBaseParameters);
pi=E1*sol.pi_b;

                        
                 
                          
