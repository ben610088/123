%% 2021/01/11 建立多級偽逆法 Cascaded Generalized Inverse, CGI
function u = CGIwrap(IN_MAT)

% IN_MAT = [B     d
%           umin' 0
%           umax' 0
%           INDX  LPmethod 無用，已廢棄
%           N     0        ]

% disp('執行 CGIwrap')

[k2,m1] = size(IN_MAT);
m = m1-1;%這邊矩陣IN_MAT的列與行分別要減掉(m+3)和1，求取B矩陣的行與列
k = k2-(m+6);

%這個步驟主要是將原先在MakeINMAT模塊中組成的IN_MAT做劃分
B    = IN_MAT(1:k,1:m);         % 3*9
v    = IN_MAT(1:k,end);         % 3*1
umax = IN_MAT(k+2,1:m)';        % 1*9
umin = IN_MAT(k+3,1:m)';        % 1*9
% INDX = IN_MAT(k+3,1:m)';      % 1*9
N    = IN_MAT(k+7:k+15,1:m); % 9*9

% B1 = B;
p = pinv(B*N);
u = N*p*v;
u1 = zeros(m,1);
I = zeros(1,m);

switch m  
    case 9
        %start--------------------------------- !!!!!九個控制面使用此while迴圈!!!!!---------------------------------
        while u(1)>umax(1) || u(2)>umax(2) || u(3)>umax(3) || u(4)>umax(4) || u(5)>umax(5) || u(6)>umax(6) || u(7)>umax(7) || u(8)>umax(8) || u(9)>umax(9) || u(1)<umin(1) || u(2)<umin(2) || u(3)<umin(3) || u(4)<umin(4) || u(5)<umin(5) || u(6)<umin(6) || u(7)<umin(7) || u(8)<umin(8) || u(9)<umin(9)
            for i = 1:m
                if u(i) > umax(i)
                    u(i) = umax(i);
                    v = v-B(:,i)*u(i);
                    u1(i) = umax(i);
                    N(i,:) = zeros(1,m);
                    
                elseif u(i) < umin(i)
                    u(i) = umin(i);
                    v = v-B(:,i)*u(i);
                    u1(i) = umin(i);
                    N(i,:) = zeros(1,m);
                end  %if u(i)>umax(i) u(i) < umin(i)
            end   %for i = 1:m
            
            p = pinv(B*N);
            u = N*p*v;
        end  %while u(1)>umax(1) || u(2)>umax(2) || u(3)>umax(3) || u(4)>umax(4) || u(5)>umax(5) || u(6)>umax(6) || u(7)>umax(7) || u(8)>umax(8) || u(9)>umax(9) || u(1)<umin(1) || u(2)<umin(2) || u(3)<umin(3) || u(4)<umin(4) || u(5)<umin(5) || u(6)<umin(6) || u(7)<umin(7) || u(8)<umin(8) || u(9)<umin(9)
        %end--------------------------------- !!!!!九個控制面使用此while迴圈!!!!!---------------------------------
        
    case 7
        %start--------------------------------- !!!!!七個控制面使用此while迴圈!!!!!---------------------------------
        while u(1)>umax(1) || u(2)>umax(2) || u(3)>umax(3) || u(4)>umax(4) || u(5)>umax(5) || u(6)>umax(6) || u(7)>umax(7) || u(1)<umin(1) || u(2)<umin(2) || u(3)<umin(3) || u(4)<umin(4) || u(5)<umin(5) || u(6)<umin(6) || u(7)<umin(7)
            for i = 1:m
                if u(i) > umax(i)
                    u(i) = umax(i);
                    v = v-B(:,i)*u(i);
                    u1(i) = umax(i);
                    N(i,:) = zeros(1,m);
                    
                elseif u(i) < umin(i)
                    u(i) = umin(i);
                    v = v-B(:,i)*u(i);
                    u1(i) = umin(i);
                    N(i,:) = zeros(1,m);
                end  %if u(i)>umax(i) u(i) < umin(i)
            end   %for i = 1:m
            
            p = pinv(B*N);
            u = N*p*v;
        end  %while u(1)>umax(1) || u(2)>umax(2) || u(3)>umax(3) || u(4)>umax(4) || u(5)>umax(5) || u(6)>umax(6) || u(7)>umax(7) || u(1)<umin(1) || u(2)<umin(2) || u(3)<umin(3) || u(4)<umin(4) || u(5)<umin(5) || u(6)<umin(6) || u(7)<umin(7)
        %end--------------------------------- !!!!!七個控制面使用此while迴圈!!!!!---------------------------------
        
    case 5
        %start--------------------------------- !!!!!五個控制面使用此while迴圈!!!!!---------------------------------
        while u(1)>umax(1) || u(2)>umax(2) || u(3)>umax(3) || u(4)>umax(4) || u(5)>umax(5) || u(1)<umin(1) || u(2)<umin(2) || u(3)<umin(3) || u(4)<umin(4) || u(5)<umin(5)
            for i = 1:m
                if u(i) > umax(i)
                    u(i) = umax(i);
                    v = v-B(:,i)*u(i);
                    u1(i) = umax(i);
                    N(i,:) = zeros(1,m);
                    
                elseif u(i) < umin(i)
                    u(i) = umin(i);
                    v = v-B(:,i)*u(i);
                    u1(i) = umin(i);
                    N(i,:) = zeros(1,m);
                end  %if u(i)>umax(i) u(i) < umin(i)
            end   %for i = 1:m
            
            p = pinv(B*N);
            u = N*p*v;
        end  %while u(1)>umax(1) || u(2)>umax(2) || u(3)>umax(3) || u(4)>umax(4) || u(5)>umax(5) ||  u(1)<umin(1) || u(2)<umin(2) || u(3)<umin(3) || u(4)<umin(4) || u(5)<umin(5)
        %end--------------------------------- !!!!!五個控制面使用此while迴圈!!!!!---------------------------------
end

ind = sum(N,2)==0;
for i = 1:m
    I(i)=i;
end %for i = 1:m

for i = 1:m
    I(i) = ind(i)*I(i);
end %for i = 1:m

I = I(I~=0);
u(I) = u1(I);

end





