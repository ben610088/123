function u = Weighted_Pseudo_inverses(IN_MAT)

% IN_MAT =      1-3  [B       v           前面數字代表所佔列數
%         (k+1)   4   upast   dt
%         (k+2)   5   Umax'   0
%         (k+3)   6   Umin'   0
%         (k+4)   7   DUmax'  0
%         (k+5)   8   DUmin'  0
%         (k+6)   9   INDX    LPmethod 無用，已廢棄
%              10~18  Ninv    0        ] 18*10

% disp('執行 Weighted_Pseudo_inverses')

[k2,m1] = size(IN_MAT);
m = m1-1; %這邊矩陣IN_MAT的列與行分別要減掉12和1，求取B矩陣的行與列
k = k2-(m+6);


% if k<1 || m<1 || norm(IN_MAT)<1e-16
%     u=zeros(7,1);
%     return
% end 

%這個步驟主要是將原先在MakeINMAT模塊中組成的IN_MAT做劃分
B = IN_MAT(1:k,1:m);         % 3*9
v = IN_MAT(1:k,end);         % 3*1
% umax = IN_MAT(k+2,1:m)';     % 1*9
% umin = IN_MAT(k+3,1:m)';     % 1*9
% INDX =IN_MAT(k+6,1:m)';      % 1*9
Ninv = IN_MAT(k+7:k+15,1:m); % 9*9


pseudo_inv_B_f = pinv(B*Ninv);
u = Ninv*pseudo_inv_B_f*v;
% N1 = inv(N);
% u = N1*(B*N1)'*inv(B*N1*(B*N1)')*v;

end