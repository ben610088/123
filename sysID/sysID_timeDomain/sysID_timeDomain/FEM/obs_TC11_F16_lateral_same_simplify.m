function y = obs_TC11_F16_lateral_same_simplify(ts, x, u, param)
% 記得改路徑
proj             = currentProject;                                                                  % 返回一個專案物件proj 代表當前打開的Project專案       
fileNameGeometry = fullfile(proj.RootFolder,'\sysID\sysID_timeDomain\sysID_GeometryData_A1.mat');   % 飛機 Geometry data 的存檔位置
sys_temp         = load(fileNameGeometry,'ac','Sensor','g');
ac               = sys_temp.ac;
Sensor           = sys_temp.Sensor;
g                = sys_temp.g(3);
clear('sys_temp');          % 刪掉無用的變數，以釋放記憶體、保持 Workspace 乾淨

%% State variables
beta    = x(1);
phi     = x(2);
psi     = x(3);    
p       = x(4);
r       = x(5);
%% Input variables
dre     = u(1);    % 右升降舵 
dle     = u(2);    % 左升降舵
dra     = u(3);    % 右副翼 
dla     = u(4);    % 左副翼
dr      = u(5);    % 方向舵
dry     = u(6);    % 右向量噴嘴上下偏轉(pitch)
drz     = u(7);    % 右向量噴嘴左右偏轉(yaw)
dly     = u(8);    % 左向量噴嘴上下偏轉(pitch)
dlz     = u(9);    % 左向量噴嘴左右偏轉(yaw)
dlef    = u(10);   % 翼前緣leading edge
% dsb   = u(11);   % 減速版
%% pseudo input 虛擬輸入、Measured Values 量測值
% [eBook] 2015 Flight vehicle system identification - a time domain methodology, Second Edition p369：9.16.2節在分析橫向運動，但是state equation卻出現縱向的變數，我們將其視為虛擬輸入，將其視為已知變數，其值為time-history訊號的值
% [eBook] 2006 Aircraft System Identification - Theory And Practice p69：第3.9.2節 Substituting Measured Values
Tx      = u(12);
Ty      = u(13);
Tz      = u(14);
qbar     = u(15);
% N     = u(16);
% f     = u(17);
Vt      = u(18);
% alpha = u(19);
theta   = u(20);
q       = u(21);
% mu    = u(22);
% chi   = u(23);
% gamma = u(24);
%% Abbreviation
% sa    = sin(alpha);
% ca    = cos(alpha);
% sb    = sin(beta);
% cb    = cos(beta);    
% tb    = tan(beta);     
% st    = sin(theta);   
% ct    = cos(theta);      
% tt    = tan(theta);      
% sphi  = sin(phi);
% cphi  = cos(phi);
% spsi  = sin(psi);      
% cpsi  = cos(psi);      
%% Parameters
Cl                 = param(1);
dCl_beta           = param(2);
Cl_delta_ail       = param(3);
Cl_delta_ail_lef   = param(4);
Cl_delta_r         = param(5);
Cl_elevator0       = param(6);
Cl_lef             = param(7);
Cl_p               = param(8);
dCl_p_lef          = param(9);
Cl_r               = param(10);
dCl_r_lef          = param(11);
Cn                 = param(12);
dCn_beta           = param(13);
Cn_delta_ail       = param(14);
Cn_delta_ail_lef   = param(15);
Cn_delta_r         = param(16);
Cn_elevator0       = param(17);
Cn_lef             = param(18);
Cn_p               = param(19);
dCn_p_lef          = param(20);
Cn_r               = param(21);
dCn_r_lef          = param(22);
% CX                 = param(23);
% CX_elevator0       = param(24);
% CX_lef             = param(25);
% CX_q               = param(26);
% CX_q_lef           = param(27);
% dCX_sb             = param(28);
% X_hat_delta_e      = param(29);              % X_hat_delta_e/2*0.4 = CX_delta_ra = CX_delta_la
CY                 = param(30);
CY_delta_ail       = param(31);
CY_delta_ail_lef   = param(32);
CY_delta_r         = param(33);
CY_lef             = param(34);
CY_p               = param(35);
dCY_p_lef          = param(36);
CY_r               = param(37);
dCY_r_lef          = param(38);
% CZ                 = param(39);
% CZ_elevator0       = param(40);
% CZ_lef             = param(41);
% CZ_q               = param(42);
% dCZ_q_lef          = param(43);
% dCZ_sb             = param(44);
% Z_hat_delta_e      = param(45);              % Z_hat_delta_e/2*0.4 = CZ_delta_ra = CZ_delta_la
%% Geometry data
b         = ac.b;                            % span, ft
cbar      = ac.cbar;                         % mean aero chord, ft
Heng      = ac.Heng;                         % turbine momentum along roll axis slug*ft^2，turbine momentum along roll axis  (文獻記載：假設是固定值 160 slug*ft^2)
Ix        = ac.Ix;                           % slug-ft^2
Ixz       = ac.Ixz;                          % slug-ft^2
Iy        = ac.Iy;                           % slug-ft^2
Iz        = ac.Iz;                           % slug-ft^2
lt        = ac.lt;
m         = ac.m;                            % mass, slugs
mt        = ac.mt;                           % 預設值 15552 ft, 向量噴嘴旋轉中心點至重心的距離 Engine nozzle after of cg
S         = ac.S;                            % planform area, ft^2
x_cg      = ac.x_cg;                         % center of gravity as a fraction of cbar
x_cg_ref  = ac.x_cg_ref;                     % reference center of gravity as a fraction of cbar
x_acc_cg  = Sensor.accelerometer.positionx;  % 加速度計安裝位置的座標x(相對於飛機cg)
y_acc_cg  = Sensor.accelerometer.positiony;  % 加速度計安裝位置的座標y(相對於飛機cg)
z_acc_cg  = Sensor.accelerometer.positionz;  % 加速度計安裝位置的座標z(相對於飛機cg)
biasbeta  = Sensor.noseboom.biasbeta;        % 鼻桿測到beta的偏差量
biasp     = Sensor.gyro.biasp;               % 陀螺儀在x軸上的偏差量
biasr     = Sensor.gyro.biasr;               % 陀螺儀在z軸上的偏差量
biaspdot  = Sensor.gyro.biaspdot;            % 陀螺儀在x軸上的偏差量
biasrdot  = Sensor.gyro.biasrdot;            % 陀螺儀在z軸上的偏差量
biasay    = Sensor.accelerometer.biasy;      % 加速度計在y軸上的偏差量
biasphi   = Sensor.biasphi;                  % phi角的偏差量
biaspsi   = Sensor.biaspsi;                  % psi角的偏差量
%% Intermediate variables
CYT       = CY + (CY_lef-CY)*(1-dlef/25) + (CY_delta_r-CY)*(dr/30) + p*b/(2*Vt)*(CY_p+dCY_p_lef*(1-dlef/25)) + r*b/(2*Vt)*(CY_r+dCY_r_lef*(1-dlef/25)) + ((CY_delta_ail-CY)+(CY_delta_ail_lef-CY_lef-CY_delta_ail+CY)*(1-dlef/25))/2*(dra/20-dla/20) + (CY_delta_ail-CY)/2*0.68*((dre/25)-(dle/25));
CLT       = Cl + (Cl_lef-Cl_elevator0)*(1-dlef/25) + dCl_beta*beta + (Cl_delta_r-Cl_elevator0)*(dr/30) + p*b/(2*Vt)*(Cl_p+dCl_p_lef*(1-dlef/25)) + r*b/(2*Vt)*(Cl_r+dCl_r_lef*(1-dlef/25)) + ((Cl_delta_ail-Cl_elevator0) + (Cl_delta_ail_lef-Cl_lef-Cl_delta_ail+Cl_elevator0)*(1-dlef/25))/2*(dra/20-dla/20) + (Cl_delta_ail-Cl_elevator0)/2*0.56*(dre/25-dle/25);
CNT       = Cn + (Cn_lef-Cn_elevator0)*(1-dlef/25) - CYT*(x_cg_ref-x_cg)*cbar/b + p*b/(2*Vt)*(Cn_p+dCn_p_lef*(1-dlef/25)) + (Cn_delta_r-Cn_elevator0)*(dr/30) + r*b/(2*Vt)*(Cn_r+dCn_r_lef*(1-dlef/25)) + dCn_beta*beta + ((Cn_delta_ail-Cn_elevator0)+(Cn_delta_ail_lef-Cn_lef-Cn_delta_ail+Cn_elevator0)*(1-dlef/25))/2*((dra/20)-(dla/20)) + (Cn_delta_ail-Cn_elevator0)/2*0.26*((dre/25)-(dle/25));
L_tot     = CLT*qbar*S*b;    %get moments from coefficients */
N_tot     = CNT*qbar*S*b;
T         = sqrt(Tx^2 + Ty^2 + Tz^2);
Mx_T          = T/2*(mt*cos(dlz)*sin(dly) - mt*cos(drz)*sin(dry));
Mz_T          = T/2*(-lt*sin(dlz) - lt*sin(drz));       % 這是仿照勁豪論文程式碼，這是錯誤的
% Mz_T        = T/2*(-lt*sin(dlz) + mt*cos(dlz)*cos(dly) - lt*sin(drz) - mt*cos(drz)*cos(dry));   % 這是正確的
Mx        = L_tot+Mx_T;
Mz        = N_tot+Mz_T;
denom     = Ix*Iz - Ixz*Ixz;
p_dot     = (Iz*Mx + Ixz*Mz - (Iz*(Iz-Iy)+Ixz*Ixz)*q*r + Ixz*(Ix-Iy+Iz)*p*q + Ixz*q*Heng)/denom;     
r_dot     = (Ix*Mz + Ixz*Mx + (Ix*(Ix-Iy)+Ixz*Ixz)*p*q - Ixz*(Ix-Iy+Iz)*q*r +  Ix*q*Heng)/denom; 
ay_offset = (m*g*cos(theta)*sin(phi) + qbar*S*CYT + Ty)/m - (-(p*q + r_dot)*x_acc_cg + (p*p + r*r)*y_acc_cg - (q*r - p_dot)*z_acc_cg);
%% Observations
y(1)      = beta + biasbeta;     %?
y(2)      = phi + biasphi;
y(3)      = psi + biaspsi;
y(4)      = p + biasp;
y(5)      = r + biasr;
y(6)      = p_dot + biaspdot;    
y(7)      = r_dot + biasrdot;    
y(8)      = ay_offset + biasay;
%% y must be a column vector
y = y';
return
% end of function