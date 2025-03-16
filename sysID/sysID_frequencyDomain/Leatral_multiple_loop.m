%% 橫向運動
u1w1 = diag(input_chy(index(:,1),1));
u1w2 = diag(input_chy(index(:,2),1));
u1w3 = diag(input_chy(index(:,3),1));
u2w1 = diag(input_chy(index(:,1),2));
u2w2 = diag(input_chy(index(:,2),2));
u2w3 = diag(input_chy(index(:,3),2));
u3w1 = diag(input_chy(index(:,1),3));
u3w2 = diag(input_chy(index(:,2),3));
u3w3 = diag(input_chy(index(:,3),3));

y1w1=output_chy(index(:,1),1);
y1w2=output_chy(index(:,2),1);
y1w3=output_chy(index(:,3),1);
y2w1=output_chy(index(:,1),2);
y2w2=output_chy(index(:,2),2);
y2w3=output_chy(index(:,3),2);
y3w1=output_chy(index(:,1),3);
y3w2=output_chy(index(:,2),3);
y3w3=output_chy(index(:,3),3);

n = size(u1w1,1);
e = ones(n,1);
A_1 = spdiags([0*e -1*e 0*e],-1:1,n,n);                  % -1 對角矩陣

N=3;    % 線性插補切N等份
i=1;    % 內插第i個點
j=1;    % 外插第j個點

B2to1 = spdiags([(1-j/N)*e (j/N)*e 0*e],-1:1,n,n);       % 外插前面
B2to1(1) = 2-j/N;
B2to1(1,2) =-(1-j/N);
B1to2 = spdiags([0*e (1-j/N)*e j/N*e],-1:1,n,n);         % 外插後面
B1to2(end) = 1+j/N;
B1to2(end,end-1) = -j/N;

first_B_staet = B2to1;                                   % 外插最前面第一個點的矩陣
first_B_end   = B1to2;                                   % 外插最後面第一個點的矩陣                      

N=3;    % 線性插補切N等份
i=2;    % 內插第i個點
j=2;    % 外插第j個點
 
B2to1= spdiags([(1-j/N)*e (j/N)*e 0*e],-1:1,n,n);        % 外插前面
B2to1(1) = 2-j/N;
B2to1(1,2) =-(1-j/N);
B1to2 = spdiags([0*e (1-j/N)*e j/N*e],-1:1,n,n);         % 外插後面
B1to2(end) = 1+j/N;
B1to2(end,end-1)=-j/N;

second_B_start = B2to1;                                  % 外插最前面第二個點的矩陣
second_B_end   = B1to2;                                  % 外插最後面第二個點的矩陣

zero=zeros(size(u1w1,1));
A11 = [u1w1 zero zero u2w1 zero zero u3w1 zero zero;zero u1w1 zero zero u2w1 zero zero u3w1 zero;zero zero u1w1 zero zero u2w1 zero zero u3w1];
A22 = [u1w2 zero zero u2w2 zero zero u3w2 zero zero;zero u1w2 zero zero u2w2 zero zero u3w2 zero;zero zero u1w2 zero zero u2w2 zero zero u3w2];
A33 = [u1w3 zero zero u2w3 zero zero u3w3 zero zero;zero u1w3 zero zero u2w3 zero zero u3w3 zero;zero zero u1w3 zero zero u2w3 zero zero u3w3];

A41 =
A42 = [A_1  zero zero zero zero zero zero zero zero;...
       zero zero zero zero zero zero zero zero zero;...
       zero A_1  zero zero zero zero zero zero zero;...
       zero zero zero zero zero zero zero zero zero;...
       zero zero A_1  zero zero zero zero zero zero;...
       zero zero zero zero zero zero zero zero zero];
A43 = [zero zero zero zero zero zero zero zero zero;...
       A_1  zero zero zero zero zero zero zero zero;...
       zero zero zero zero zero zero zero zero zero;...
       zero A_1  zero zero zero zero zero zero zero;...
       zero zero zero zero zero zero zero zero zero;...
       zero zero A_1  zero zero zero zero zero zero ];
% ----------------------------
A51 = [zero zero zero A_1  zero zero zero zero zero;...
       zero zero zero zero zero zero zero zero zero;...
       zero zero zero zero A_1  zero zero zero zero;...
       zero zero zero zero zero zero zero zero zero;...
       zero zero zero zero zero A_1  zero zero zero ;...
       zero zero zero zero zero zero zero zero zero];

A52 = [zero zero zero second_B_start zero           zero            zero zero zero;...
       zero zero zero first_B_end    zero           zero            zero zero zero;...
       zero zero zero zero           second_B_start zero            zero zero zero;...
       zero zero zero zero           first_B_end    zero            zero zero zero;...
       zero zero zero zero           zero           second_B_start  zero zero zero ;...
       zero zero zero zero           zero           first_B_end     zero zero zero];

A53 = [zero zero zero zero zero zero zero zero zero;...
       zero zero zero A_1  zero zero zero zero zero;...
       zero zero zero zero zero zero zero zero zero;...
       zero zero zero zero A_1  zero zero zero zero;...
       zero zero zero zero zero zero zero zero zero ;...
       zero zero zero zero zero A_1  zero zero zero];

A61 = [zero zero zero zero zero A_1  zero zero zero;...
       zero zero zero zero zero zero zero zero zero;...
       zero zero zero zero zero zero zero A_1  zero;...
       zero zero zero zero zero zero zero zero zero;...
       zero zero zero zero zero zero zero zero A_1 ;...
       zero zero zero zero zero zero zero zero zero];
A62 = [zero zero zero zero zero zero zero zero zero;...
       zero zero zero zero zero A_1  zero zero zero;...
       zero zero zero zero zero zero zero zero zero;...
       zero zero zero zero zero zero zero A_1  zero;...
       zero zero zero zero zero zero zero zero zero;...
       zero zero zero zero zero zero zero zero A_1 ];
A63 = [zero zero zero zero zero zero first_B_staet  zero           zero;...
       zero zero zero zero zero zero second_B_start zero           zero;...
       zero zero zero zero zero zero zero           first_B_staet  zero;...
       zero zero zero zero zero zero zero           second_B_start zero;...
       zero zero zero zero zero zero zero           zero           first_B_staet;...
       zero zero zero zero zero zero zero           zero           second_B_start];

zero1 = zeros(size(A11,1),size(A11,2));
InterpMatrix = [A11 zero1 zero1;zero1 A22 zero1;zero1 zero1 A33;A41 A42 A43;A51 A52 A53;A61 A62 A63];
b1 = [y1w1; y2w1;y3w1];
b2 = [y1w2; y2w2;y3w2];
b3 = [y1w3; y2w3;y3w3];
zero2 = zeros(size(A41,1)+size(A51,1)+size(A61,1),1);
b = [b1; b2;zero2];
HMatrix = InterpMatrix\b;    % inv(InterpMatrix)*b
hh = size(u1w1,1);
H11w1 = HMatrix(     1:  hh);
H21w1 = HMatrix(  hh+1:2*hh);
H31w1 = HMatrix(2*hh+1:3*hh);
H12w1 = HMatrix(3*hh+1:4*hh); 
H22w1 = HMatrix(4*hh+1:5*hh);
H32w1 = HMatrix(5*hh+1:6*hh);
H13w1 = HMatrix(6*hh+1:7*hh);
H23w1 = HMatrix(7*hh+1:8*hh);
H33w1 = HMatrix(8*hh+1:9*hh);

H11w2 = HMatrix(9 *hh+1 :10*hh);
H21w2 = HMatrix(10*hh+1:11*hh);
H31w2 = HMatrix(11*hh+1:12*hh);
H12w2 = HMatrix(12*hh+1:13*hh);
H22w1 = HMatrix(13*hh+1:14*hh);
H32w2 = HMatrix(14*hh+1:15*hh);
H13w2 = HMatrix(15*hh+1:16*hh);
H23w2 = HMatrix(16*hh+1:17*hh);
H33w2 = HMatrix(17*hh+1:18*hh);

H11w3 = HMatrix(18*hh+1:19*hh);
H21w3 = HMatrix(19*hh+1:20*hh);
H31w3 = HMatrix(20*hh+1:21*hh);
H12w3 = HMatrix(21*hh+1:22*hh);
H22w3 = HMatrix(22*hh+1:23*hh);
H32w3 = HMatrix(23*hh+1:24*hh);
H13w3 = HMatrix(24*hh+1:25*hh);
H23w3 = HMatrix(25*hh+1:26*hh);
H33w3 = HMatrix(26*hh+1:  end);
% -------------------------------------------------------
% 判斷兩相鄰相位角是否超越180度，若超過則判斷為有跳變點(即有wrap的意思)，故-2*pi使相位角unwrap
% 註：選擇使用下方程式碼if…else…判斷式的原因是因為想做到Real time，想節省運算時間
%     (因為印象中使用內建的 unwrap()指令後，還要記錄轉了N次2pi，再扣掉N次*2pi…好像還要用到除法!?
%     硬體實現除法相較於減法複雜，所以會增加運算時間)：
H11w1_rad =  angle(H11w1);
for i = 2 : 14
    if  H11w1_rad(i) - H11w1_rad(i-1) > pi                  
        H11w1_rad(i) = H11w1_rad(i) - 2*pi;
    elseif H11w1_rad(i) - H11w1_rad(i-1) < (-1*pi)                  
        H11w1_rad(i) = H11w1_rad(i) + 2*pi;
    else
    end
end
H11w2_rad =  angle(H11w2);
for i = 2 : 14
    if  H11w1_rad(i) - H11w1_rad(i-1) > pi
        H11w1_rad(i) = H11w1_rad(i) - 2*pi;
    elseif H11w1_rad(i) - H11w1_rad(i-1) < (-1*pi)
        H11w1_rad(i) = H11w1_rad(i) + 2*pi;
    else
    end
end
H11w3_rad =  angle(H11w3);
for i = 2 : 14
    if  H11w1_rad(i) - H11w1_rad(i-1) > pi
        H11w1_rad(i) = H11w1_rad(i) - 2*pi;
    elseif H11w1_rad(i) - H11w1_rad(i-1) < (-1*pi)
        H11w1_rad(i) = H11w1_rad(i) + 2*pi;
    else
    end
end


H12w1_rad =  angle(H12w1);
for i = 2 : 14
    if  H12w1_rad(i) - H12w1_rad(i-1) > pi                  
        H12w1_rad(i) = H12w1_rad(i) - 2*pi;
    elseif H11w1_rad(i) - H12w1_rad(i-1) < (-1*pi)                  
        H12w1_rad(i) = H12w1_rad(i) + 2*pi;
    else
    end
end
H22w2_rad =  angle(H22w2);
for i = 2 : 14
    if  H22w1_rad(i) - H22w1_rad(i-1) > pi                  
        H22w1_rad(i) = H22w1_rad(i) - 2*pi;
    elseif H22w1_rad(i) - H22w1_rad(i-1) < (-1*pi)                  
        H22w1_rad(i) = H22w1_rad(i) + 2*pi;
    else
    end
end
H21w1_rad =  angle(H21w1);
for i = 2 : 14 
    if  H21w1_rad(i) - H21w1_rad(i-1) > pi 
        H21w1_rad(i) = H21w1_rad(i) - 2*pi;
    end
end
H21w2_rad =  angle(H21w2);
for i = 2 : 14 
    if  H21w2_rad(i) - H21w2_rad(i-1) > pi 
        H21w2_rad(i) = H21w2_rad(i) - 2*pi;
    end
end
H22w2_rad =  angle(H22w2);
for i = 2 : 14 
    if  H22w2_rad(i) - H22w2_rad(i-1) > pi 
        H22w2_rad(i) = H22w2_rad(i) - 2*pi;
    end
end
H22w1_rad =  angle(H22w1);
for i = 2 : 14 
    if  H22w1_rad(i) - H22w1_rad(i-1) > pi 
        H22w1_rad(i) = H22w1_rad(i) - 2*pi;
    end
end
% -------------------------------------------------------