clc; clear;
load('leg_joints_val.mat', 'Leg_Joints');

q=Leg_Joints.joint_p;
qd=Leg_Joints.joint_dp;
q2d=diff(qd)/0.001;
u=Leg_Joints.joint_u;
time=Leg_Joints.lcm_timestamp;

q=q(2:8001,:);
qd=qd(2:8001,:);
u=u(2:8001,:);

path_to_val_data.q=q;
path_to_val_data.qd=qd;
path_to_val_data.q2d=q2d;
path_to_val_data.u=u;
path_to_val_data.time=time;
a=1;