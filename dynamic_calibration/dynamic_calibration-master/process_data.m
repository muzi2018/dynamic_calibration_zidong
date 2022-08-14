clc; clear;
load('leg_joints.mat', 'Leg_Joints');
q=Leg_Joints.joint_p;
qd=diff(q); %按列求
q2d=diff(qd);
a=[3,5;8,1;5,9];
diff(a);