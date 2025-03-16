function u = DAISY_CHAINING(IN_MAT)

% IN_MAT = [B     d
%           umin' 0
%           umax' 0
%           INDX  LPmethod 無用，已廢棄
%           N     0        ]

% disp('執行 DAISY_CHAINING')

[k2,m1] = size(IN_MAT);
m = m1-1; %這邊矩陣IN_MAT的列與行分別要減掉11和1，求取B矩陣的行與列
k = k2-(m+6);

%這個步驟主要是將原先在MakeINMAT模塊中組成的IN_MAT做劃分
B = IN_MAT(1:k,1:m);         % 3*9
v = IN_MAT(1:k,end);         % 3*1
umax = IN_MAT(k+2,1:m)';     % 1*9
umin = IN_MAT(k+3,1:m)';     % 1*9
% INDX =IN_MAT(k+3,1:m)';      % 1*9
N = IN_MAT(k+7:k+15,1:m); % 9*9

switch m
    case 9
    %start----- !!!!!九個控制面!!!!!-----
    %將B矩陣分成兩組，第一組為氣動力控制翼面，第二組為向量噴嘴
    B1 = B(1:k,1:5);
    B2 = B(1:k,6:9);
    N1 = N(1:5,1:5);
    N2 = N(6:9,6:9);
    %end----- !!!!!九個控制面!!!!!-----
    
    case 7
    %start----- !!!!!七個控制面!!!!!-----
    %將B矩陣分成兩組，第一組為氣動力控制翼面，第二組為向量噴嘴
    B1 = B(1:k,1:5);
    B2 = B(1:k,6:7);
    N1 = N(1:5,1:5);
    N2 = N(6:7,6:7);
    %end----- !!!!!七個控制面!!!!!----- 
       
    case 5
    %start----- !!!!!五個控制面!!!!!-----
    %將B矩陣分成兩組，第一組為氣動力控制翼面，第二組為向量噴嘴
    B1 = B(1:k,1:3);
    B2 = B(1:k,4:5);
    N1 = N(1:3,1:3);
    N2 = N(4:5,4:5);
    %end----- !!!!!五個控制面!!!!!-----
end

p1 = pinv(B1*N1);
u_aero = N1*p1*v;
for i = 1:size(B1,2)
    if u_aero(i) > umax(i)
        u_aero(i) = umax(i);
        
    elseif u_aero(i) < umin(i)
        u_aero(i) = umin(i);
        
    end
end

v_last = v-B1*u_aero;
v_last_magnitude = norm(v_last);

if v_last_magnitude == 0
    switch m
        case 9
            %start----- !!!!!九個控制面!!!!!-----
            u_nozzle = zeros(4,1);
            %end----- !!!!!九個控制面!!!!!-----
            
        case 7
            %start----- !!!!!七個控制面!!!!!-----
            u_nozzle = zeros(2,1);
            %end----- !!!!!七個控制面!!!!!-----
            
        case 5
            %start----- !!!!!五個控制面!!!!!-----
            u_nozzle = zeros(2,1);
            %end----- !!!!!五個控制面!!!!!-----
    end
else 
    p2 = pinv(B2*N2);
    u_nozzle = N2*p2*v_last;
end

u = [u_aero; u_nozzle];

end %function [u] = DAISY_CHAINING(IN_MAT)