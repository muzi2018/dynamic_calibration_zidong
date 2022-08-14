W=[1,2,4;
    2,1,1;
    1,0,1;
    2,1,2;
    1,2,2];
[Q, R, E] = qr(W);

% matrix W has rank bb which is number number of base parameters 
bb = rank(W);
R1 = R(1:bb,1:bb);
R2 = R(1:bb,bb+1:end);


a=1;