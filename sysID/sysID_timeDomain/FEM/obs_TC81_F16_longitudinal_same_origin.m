function y = obs_TC81_F16_longitudinal_same_origin(ts, x, u, param)         % CX, CZ, Cm 左右邊當作 "相同" 係數且使用 "完整" 公式
% 記得改路徑
proj             = currentProject;                                                                  % 返回一個專案物件proj 代表當前打開的Project專案       
fileNameGeometry = fullfile(proj.RootFolder,'\sysID\sysID_timeDomain\sysID_GeometryData_A1.mat');   % 飛機 Geometry data 的存檔位置
sys_temp         = load(fileNameGeometry,'ac','Sensor','g');
ac               = sys_temp.ac;
Sensor           = sys_temp.Sensor;
g                = sys_temp.g(3);
clear('sys_temp');          % 刪掉無用的變數，以釋放記憶體、保持 Workspace 乾淨

%% State variables
Vt      = x(1);
alpha   = x(2);
theta   = x(3);
q       = x(4);
%% Input variables
dre     = u(1);     % 右升降舵 
dle     = u(2);     % 左升降舵
dra     = u(3);     % 右副翼 
dla     = u(4);     % 左副翼
dr      = u(5);     % 方向舵
dry     = u(6);     % 右向量噴嘴上下偏轉(pitch)
drz     = u(7);     % 右向量噴嘴左右偏轉(yaw)
dly     = u(8);     % 左向量噴嘴上下偏轉(pitch)
dlz     = u(9);     % 左向量噴嘴左右偏轉(yaw)
dlef    = u(10);    % 翼前緣leading edge
dsb     = u(11);    % 減速版
%% pseudo input 虛擬輸入、Measured Values 量測值
% [eBook] 2015 Flight vehicle system identification - a time domain methodology, Second Edition p369：9.16.2節在分析橫向運動，但是state equation卻出現縱向的變數，我們將其視為虛擬輸入，將其視為已知變數，其值為time-history訊號的值
% [eBook] 2006 Aircraft System Identification - Theory And Practice p69：第3.9.2節 Substituting Measured Values
Tx      = u(12);
Ty      = u(13);
Tz      = u(14);
qbar    = u(15);
% N     = u(16);
% f     = u(17);
beta    = u(18);
phi     = u(19);
% psi   = u(20);    % 沒用到
p       = u(21);
r       = u(22);
% mu    = u(23);
% chi   = u(24);
% gamma = u(25);
%% Abbreviation
% sa = sin(alpha);  %sin(alpha)
% ca = cos(alpha);  %cos(alpha)
% sb = sin(beta);   %sin(beta)
% cb = cos(beta);   %cos(beta)
% tb = tan(beta);   %tan(beta)
% st = sin(theta); 
% ct = cos(theta);
% tt = tan(theta);
% sphi = sin(phi);
% cphi = cos(phi);
% spsi = sin(psi);
% cpsi = cos(psi);
%% Parameters
dCl_beta                = param(1);
Cl_delta_ail            = param(2);
Cl_delta_ail_lef        = param(2);
Cl_delta_r              = param(4);
Cl_p                    = param(5);
dCl_p_lef               = param(6);
Cl_r                    = param(7);
dCl_r_lef               = param(8);
Cm                      = param(9);
dC_m                    = param(10);
dCm_ds                  = param(11);
dCm_ds_elevatorPdeci    = param(12);        % Pdeci = +0.1(deg)
dCm_ds_elevatorNdeci    = param(13);        % Ndeci = -0.1(deg)
Cm_elevator0            = param(14);
Cm_elevatorPdeci        = param(15);        % Pdeci = +0.1(deg)
Cm_elevatorNdeci        = param(16);        % Ndeci = -0.1(deg)
Cm_lef                  = param(17);
Cm_q                    = param(18);
dCm_q_lef               = param(19);
dCm_sb                  = param(20);
eta_elevator            = param(21);
eta_elevatorPdeci       = param(22);        % Pdeci = +0.1(deg)
eta_elevatorNdeci       = param(23);        % Ndeci = -0.1(deg)
dCn_beta                = param(24);
Cn_delta_ail            = param(25);
Cn_delta_ail_lef        = param(26);
Cn_delta_r              = param(27);
Cn_p                    = param(28);
dCn_p_lef               = param(29);
Cn_r                    = param(30);
dCn_r_lef               = param(31);
CX                      = param(32);
CX_elevatorPdeci        = param(33);        % Pdeci = +0.1(deg)
CX_elevatorNdeci        = param(34);        % Ndeci = -0.1(deg)
CX_elevator0            = param(35);
CX_lef                  = param(36);
CX_q                    = param(37);
CX_q_lef                = param(38);
dCX_sb                  = param(39);
CY_delta_ail            = param(40);
CY_delta_ail_lef        = param(41);
CY_delta_r              = param(42);
CY_p                    = param(43);
dCY_p_lef               = param(44);
CY_r                    = param(45);
dCY_r_lef               = param(46);
CZ                      = param(47);
CZ_elevator0            = param(48);
CZ_elevatorPdeci        = param(49);        % Pdeci = +0.1(deg)
CZ_elevatorNdeci        = param(50);        % Ndeci = -0.1(deg)
CZ_lef                  = param(51);
CZ_q                    = param(52);
dCZ_q_lef               = param(53);
dCZ_sb                  = param(54);
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
biasalpha = Sensor.noseboom.biasalpha;       % 鼻桿測到alpha的偏差量
biasq     = Sensor.gyro.biasq;               % 陀螺儀在y軸上的偏差量
biasqdot  = Sensor.gyro.biasqdot;            % 陀螺儀在y軸上的偏差量
biasax    = Sensor.accelerometer.biasx;      % 加速度計在x軸上的偏差量
biasaz    = Sensor.accelerometer.biasz;      % 加速度計在z軸上的偏差量
biastheta = 0;                               % 預設值 Sensor.biastheta ，theta角的偏差量 
%% Intermediate variables
X_hat_delta_e = (CX_elevatorPdeci-CX_elevatorNdeci)/0.2;
CXT           = CX + q*cbar/(2*Vt)*(CX_q+CX_q_lef*(1-dlef/25)) + (CX_lef-CX_elevator0)*(1-dlef/25) + dCX_sb*(dsb/60) + (X_hat_delta_e/2*0.4)*(dra+dla);
CYT           = (CY_delta_r)*(dr/30) + p*b/(2*Vt)*(CY_p+dCY_p_lef*(1-dlef/25)) + r*b/(2*Vt)*(CY_r+dCY_r_lef*(1-dlef/25)) + ((CY_delta_ail)+(CY_delta_ail_lef-CY_delta_ail)*(1-dlef/25))/2*(dra/20-dla/20) + (CY_delta_ail)/2*0.68*((dre/25)-(dle/25));
Z_hat_delta_e = (CZ_elevatorPdeci-CZ_elevatorNdeci)/0.2;
CZT           = CZ + q*cbar/(2*Vt)*(CZ_q+dCZ_q_lef*(1-dlef/25)) + (CZ_lef-CZ_elevator0)*(1-dlef/25) + dCZ_sb*(dsb/60) + (Z_hat_delta_e/2*0.4)*(dra+dla);
CLT           = dCl_beta*beta + (Cl_delta_r)*(dr/30) + p*b/(2*Vt)*(Cl_p+dCl_p_lef*(1-dlef/25)) + r*b/(2*Vt)*(Cl_r+dCl_r_lef*(1-dlef/25)) + ((Cl_delta_ail) + (Cl_delta_ail_lef-Cl_delta_ail)*(1-dlef/25))/2*(dra/20-dla/20) + (Cl_delta_ail)/2*0.56*(dre/25-dle/25);
m_hat_delta_e = 1/0.2*(Cm_elevatorPdeci*eta_elevatorPdeci + dCm_ds_elevatorPdeci+(x_cg_ref-x_cg)*CZ_elevatorPdeci - Cm_elevatorNdeci*eta_elevatorNdeci - dCm_ds_elevatorNdeci - (x_cg_ref-x_cg)*CZ_elevatorNdeci);
CMT           = Cm*eta_elevator + (Cm_lef-Cm_elevator0)*(1-dlef/25) + CZT*(x_cg_ref-x_cg) + q*cbar/(2*Vt)*(Cm_q + dCm_q_lef*(1-dlef/25)) + dC_m + dCm_ds + dCm_sb*(dsb/60) + m_hat_delta_e/2*0.12*(dra+dla);
CNT           = - CYT*(x_cg_ref-x_cg)*cbar/b + p*b/(2*Vt)*(Cn_p+dCn_p_lef*(1-dlef/25)) + (Cn_delta_r)*(dr/30) + r*b/(2*Vt)*(Cn_r+dCn_r_lef*(1-dlef/25)) + dCn_beta*beta + ((Cn_delta_ail)+(Cn_delta_ail_lef-Cn_delta_ail)*(1-dlef/25))/2*((dra/20)-(dla/20)) + (Cn_delta_ail)/2*0.26*((dre/25)-(dle/25));
L_tot         = CLT*qbar*S*b;    %get moments from coefficients
M_tot         = CMT*qbar*S*cbar;
N_tot         = CNT*qbar*S*b;
T             = sqrt(Tx^2 + Ty^2 + Tz^2);
Tr            = T/2;
Tl            = T/2;
Mx_T          = Tl*(mt*cos(dlz)*sin(dly)) - Tr*(mt*cos(drz)*sin(dry));
My_T          = Tl*(-lt*cos(dlz)*sin(dly)) - Tr*(lt*cos(drz)*sin(dry));
Mz_T          = Tl*(-lt*sin(dlz)) - Tr*(lt*sin(drz));       % 這是仿照勁豪論文程式碼，這是錯誤的
% Mz_T        = Tl*(-lt*sin(dlz) + mt*cos(dlz)*cos(dly)) - Tr*(lt*sin(drz) - mt*cos(drz)*cos(dry));   % 這是正確的
Mx            = L_tot+Mx_T;
My            = M_tot+My_T;
Mz            = N_tot+Mz_T;
denom         = Ix*Iz - Ixz*Ixz;
p_dot         = (Iz*Mx + Ixz*Mz - (Iz*(Iz-Iy)+Ixz*Ixz)*q*r + Ixz*(Ix-Iy+Iz)*p*q + Ixz*q*Heng)/denom;     
q_dot         = (My + (Iz-Ix)*p*r - Ixz*(p*p-r*r) - r*Heng)/Iy;                                           
r_dot         = (Ix*Mz + Ixz*Mx + (Ix*(Ix-Iy)+Ixz*Ixz)*p*q - Ixz*(Ix-Iy+Iz)*q*r +  Ix*q*Heng)/denom; 
ax_offset     = (m*g*-sin(theta) + qbar*S*CXT + Tx)/m - ((q*q + r*r)*x_acc_cg - (p*q - r_dot)*y_acc_cg - (p*r + q_dot)*z_acc_cg);
az_offset     = (m*g*cos(theta)*cos(phi) + qbar*S*CZT + Tz)/m - (-(p*r - q_dot)*x_acc_cg - (q*r + p_dot)*y_acc_cg + (p*p + q*q)*z_acc_cg);
%% Observations
y(1)      = Vt;
y(2)      = alpha     + biasalpha;   %還要再討論，目前等號右邊為true value + bias(假設phi=0)
y(3)      = theta     + biastheta;
y(4)      = q         + biasq;
y(5)      = q_dot     + biasqdot;       
y(6)      = ax_offset + biasax;
y(7)      = az_offset + biasaz;
%% y must be a column vector
y = y';
return
% end of function