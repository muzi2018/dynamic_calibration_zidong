function generate_zidong_regressor(path_to_urdf)
% ---------------------------------------------------------------------
% The function generates regressor for UR10E. It assumes that links of
% the robot are rigid bodies. Thus the inverse dynamics can be written
% in linear-in-parameters from: tau = Y(q, dq, ddq) pi
% ---------------------------------------------------------------------

% Parse urdf to get robot description
zidong = parse_urdf(path_to_urdf);

% Create symbolic generilized coordiates, their first and second deriatives
q_sym = sym('q%d',[16,1],'real');
qd_sym = sym('qd%d',[16,1],'real');
q2d_sym = sym('q2d%d',[16,1],'real');

% ------------------------------------------------------------------------
% Getting gradient of energy functions, to derive dynamics
% ------------------------------------------------------------------------
T_pk = sym(zeros(4,4,16)); % transformation between links
w_kk(:,1) = sym(zeros(3,1)); % angular velocity k in frame k
v_kk(:,1) = sym(zeros(3,1)); % linear velocity of the origin of frame k in frame k
g_kk(:,1) = sym([0,0,9.81])'; % vector of graviatational accelerations in frame k
p_kk(:,1) = sym(zeros(3,1)); % origin of frame k in frame k

for i = 1:16
    jnt_axs_k = str2num(zidong.robot.joint{i}.axis.Attributes.xyz)';
    % Transformation from parent link frame p to current joint frame
    rpy_k = sym(str2num(zidong.robot.joint{i}.origin.Attributes.rpy));
    R_pj = RPY(rpy_k);
    R_pj(abs(R_pj)<sqrt(eps)) = sym(0); % to avoid numerical errors
    p_pj = str2num(zidong.robot.joint{i}.origin.Attributes.xyz)';
    T_pj = sym([R_pj, p_pj; zeros(1,3), 1]); % to avoid numerical errors
    % Tranformation from joint frame of the joint that rotaties body k to
    % link frame. The transformation is pure rotation
    R_jk = Rot(q_sym(i),sym(jnt_axs_k));
    p_jk = sym(zeros(3,1));
    T_jk = [R_jk, p_jk; sym(zeros(1,3)),sym(1)];
    % Transformation from parent link frame p to current link frame k
    T_pk(:,:,i) = T_pj*T_jk;
    z_kk(:,i) = sym(jnt_axs_k);
        
    w_kk(:,i+1) = T_pk(1:3,1:3,i)'*w_kk(:,i) + sym(jnt_axs_k)*qd_sym(i);
    v_kk(:,i+1) = T_pk(1:3,1:3,i)'*(v_kk(:,i) + cross(w_kk(:,i),sym(p_pj)));
    g_kk(:,i+1) = T_pk(1:3,1:3,i)'*g_kk(:,i);
    p_kk(:,i+1) = T_pk(1:3,1:3,i)'*(p_kk(:,i) + sym(p_pj));
        
    beta_K(i,:) = [sym(0.5)*w2wtlda(w_kk(:,i+1)),...
                   v_kk(:,i+1)'*vec2skewSymMat(w_kk(:,i+1)),...
                   sym(0.5)*v_kk(:,i+1)'*v_kk(:,i+1)];
    beta_P(i,:) = [sym(zeros(1,6)), g_kk(:,i+1)',...
                   g_kk(:,i+1)'*p_kk(:,i+1)];
end


% ---------------------------------------------------------------------
% Dynamic regressor of the full paramters
% ---------------------------------------------------------------------
beta_Lf = [beta_K(1,:) - beta_P(1,:), beta_K(2,:) - beta_P(2,:),...
         beta_K(3,:) - beta_P(3,:), beta_K(4,:) - beta_P(4,:),...
         beta_K(5,:) - beta_P(5,:), beta_K(6,:) - beta_P(6,:),...
         beta_K(7,:) - beta_P(7,:), beta_K(8,:) - beta_P(8,:),...
         beta_K(9,:) - beta_P(9,:), beta_K(10,:) - beta_P(10,:),...
         beta_K(11,:) - beta_P(11,:), beta_K(12,:) - beta_P(12,:),...
         beta_K(13,:) - beta_P(13,:), beta_K(14,:) - beta_P(14,:),...
         beta_K(15,:) - beta_P(15,:), beta_K(16,:) - beta_P(16,:)];
dbetaLf_dq = jacobian(beta_Lf,q_sym)';
dbetaLf_dqd = jacobian(beta_Lf,qd_sym)';
tf = sym(zeros(16,160));
for i = 1:16
   tf = tf + diff(dbetaLf_dqd,q_sym(i))*qd_sym(i)+...
                diff(dbetaLf_dqd,qd_sym(i))*q2d_sym(i);
end
Y_f = tf - dbetaLf_dq;

% Generate function from a symbolic expression for the regressor
matlabFunction(Y_f,'File','autogen/standard_regressor_UR10E',...
               'Vars',{q_sym,qd_sym,q2d_sym});
