function [u] = LP_thrust(IN_MAT) %論文模擬用



% Make single input, single output version of Linear Programming for use in
% Simulink via the MATLAB Fcn block
% IN_MAT = 1-3  [B       d           前面數字代表所佔列數
%            4   upast   dt
%            5   Umax'   0
%            6   Umin'   0
%            7   DUmax'  0
%            8   DUmin'  0
%            9   INDX    LPmethod 無用，已廢棄
%         10~18  N       0        ] 18*10


% Get sizes  取得維度

[k2,m1] = size(IN_MAT);
m = m1-1;
k = k2-(m+6);

% If matrices too small, set contols to zero and return
% if k<1 || m<1 || norm(IN_MAT)<1e-16
%     u=zeros(NumU,1);
%     return
% end
% Partition input matrix into component matrices 劃分INMAT
B    = IN_MAT(1:k,1:m);
v    = IN_MAT(1:k,end);
umax = IN_MAT(k+2,1:m)';
umin = IN_MAT(k+3,1:m)';

upast = IN_MAT(k+1,1:m)';
dt    = IN_MAT(k+1,end);
DUmax = IN_MAT(k+4,1:m)';
DUmin = IN_MAT(k+5,1:m)';
INDX  = IN_MAT(k+6,1:m);



% change variable names to be consistent with Roger's documentation
yd = v;
uMin=umin;
uMax=umax;
% uMin = max(umin,(upast+dt*DUmin));
% uMax = min(umax,(upast+dt*DUmax));

% Some variables not specifically defined for generic case
% Values below are suggestions for now
% Users may add code here to specify alternative values
up = zeros(9,1);
wu = ones(9,1);      
wu(6:9,1)   = 100 ;  % 最小向量推力
itlim = 1e3;

[u] = DB_LPCA(yd,B,wu,up,uMin,uMax);


end

function [u] = DB_LPCA(yd,B,wu,up,uMin,uMax)

[n,m] = size(B);

%Call Feasibility branch
[u_f,lambda] = DPscaled_LPCA(yd,B,uMin,uMax);

lambda;
% [u,J, inBout, eout, errout,itlim] = DBcaLP1f_sol(yd,B,wd,emax,up,uMin,uMax,n,m,itlim)
%Check if feasible...if so call sufficiency branch if not exit

if  lambda == 1 
    [u_s,~] = DBcaLP1s_sol(yd,B,wu,up,uMin,uMax,m);
    u = u_s;
else
    u = u_f;

end
end

function [u,lambda] = DPscaled_LPCA(yd,B,uMin,uMax)
[n m] = size(B);
ct  = [zeros(1,m) -1];
A   = [];
b   = [];
Aeq   = [B -yd];
beq   = -B*uMin;
h   = [uMax-uMin
       1];
xMin = [uMin
        0];
xMax = [uMax
        1];
h = xMax-xMin;
opt  = optimoptions('linprog','Algorithm','dual-simplex');
[x] = linprog(ct',A,b,Aeq,beq,zeros(10,1),h,opt);
u   = x(1:9)+uMin;
lambda = x(10);
end

function [u,J] = DBcaLP1s_sol(yd,B,wu,up, uMin,uMax,m)

A = [B -B];
b = yd-B*up;
c = [wu
     wu];
h = [uMax-up
     up-uMin];
hs = size(h);
hz = zeros(hs);
opt  = optimoptions('linprog','algorithm','dual-simplex');
[xout] = linprog(c,[],[],A,b,hz,h,hz,opt);

%Compute cost output

J =c' *xout;
%Convert solution back to control variable
u = xout(1:m)-xout(m+1:2*m)+up;

end %DBcaLP1s_sol

