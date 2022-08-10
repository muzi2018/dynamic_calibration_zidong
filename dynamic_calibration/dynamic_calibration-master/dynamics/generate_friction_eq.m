function generate_friction_eq()

% Create symbolic generilized coordiates, their first and second deriatives
qd_sym = sym('qd%d',[6,1],'real');

% Create symbolic experssions for friction parameters
pi_frcn = sym('pi_frcn_%d%d', [18,1], 'real');

% Friction torque
% \tau_{1f}=f_{1c} * \dot{q}_1 + f_{2v} * sign(\dot{q_1}) + f_{3o}
pi_frcn_tmp = reshape(pi_frcn, [3, 6])';
tau_frcn = pi_frcn_tmp(:,1).*qd_sym + pi_frcn_tmp(:,2).*sign(qd_sym) + pi_frcn_tmp(:,3);

% Generate a fucnction from symbolic expressions
matlabFunction(tau_frcn, 'File','autogen/F_vctr_fcn',...
               'Vars',{qd_sym, pi_frcn}, 'Optimize', true);