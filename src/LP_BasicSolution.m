 function u = LP_BasicSolution(IN_MAT) 
 
[k2,m1] = size(IN_MAT);
m = m1-1; %這邊矩陣IN_MAT的列與行分別要減掉11和1，求取B矩陣的行與列
k = k2-(m+6);

% 這個步驟主要是將原先在MakeINMAT模塊中組成的IN_MAT做劃分
B     = IN_MAT(1:k,1:m);  %控制效率矩陣
v_des = IN_MAT(1:k,end); %期望力矩
umax  = IN_MAT(k+2,1:m)'; %各個控制面的最大偏轉量
umin  = IN_MAT(k+3,1:m)'; %各個控制面的最小偏轉量


ct  = [zeros(1,m) -1];
A   = [];
b   = [];
Aeq   = [ B -v_des];
beq   = -B*umin;
h   = [umax-umin
       1];
xMin = [umin
        0];
xMax = [umax
        1];
h = xMax-xMin;
opt  = optimoptions('linprog','Algorithm','dual-simplex');
[x] = linprog(ct',A,b,Aeq,beq,zeros(10,1),h,opt);
u   = x(1:9)+umin;


 end%function u = Weighted_Pseudo_inverses(IN_MAT)
