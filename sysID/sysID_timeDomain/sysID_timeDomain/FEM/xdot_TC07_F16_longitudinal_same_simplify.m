function xdot = xdot_TC07_F16_longitudinal_same_simplify(ts, x, u, param)
% 記得改路徑
proj             = currentProject;                                                                  % 返回一個專案物件proj 代表當前打開的Project專案       
fileNameGeometry = fullfile(proj.RootFolder,'\sysID\sysID_timeDomain\sysID_GeometryData_A1.mat');   % 飛機 Geometry data 的存檔位置
sys_temp         = load(fileNameGeometry,'ac','g');
ac               = sys_temp.ac;
g                = sys_temp.g(3);
clear('sys_temp');          % 刪掉無用的變數，以釋放記憶體、保持 Workspace 乾淨

%% State variables
Vt      = x(1);
alpha   = x(2);
% theta = x(3);
q       = x(4);
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
dsb     = u(11);   % 減速版
%% pseudo input 虛擬輸入、Measured Values 量測值
% [eBook] 2015 Flight vehicle system identification - a time domain methodology, Second Edition p369：9.16.2節在分析橫向運動，但是state equation卻出現縱向的變數，我們將其視為虛擬輸入，將其視為已知變數，其值為time-history訊號的值
% [eBook] 2006 Aircraft System Identification - Theory And Practice p69：第3.9.2節 Substituting Measured Values
Tx      = u(12);
Ty      = u(13);
Tz      = u(14);
qbar     = u(15);
N       = u(16);
f       = u(17);
beta    = u(18);
phi     = u(19);
% psi   = u(20);        % 沒用到
p       = u(21);
r       = u(22);
mu      = u(23);
chi     = u(24);
gamma   = u(25);
%% Abbreviation
sa     = sin(alpha);
ca     = cos(alpha);
sb     = sin(beta);
cb     = cos(beta);    
tb     = tan(beta);
% st   = sin(theta);      % 沒用到
% ct   = cos(theta);      % 沒用到
% tt   = tan(theta);      % 沒用到
sphi   = sin(phi);
cphi   = cos(phi);
% spsi = sin(psi);      % 沒用到
% cpsi = cos(psi);      % 沒用到
%% Parameters
% Cl                 = param(1);
% dCl_beta           = param(2);
% Cl_delta_ail       = param(3);
% Cl_delta_ail_lef   = param(4);
% Cl_delta_r         = param(5);
% Cl_elevator0       = param(6);
% Cl_lef             = param(7);
% Cl_p               = param(8);
% dCl_p_lef          = param(9);
% Cl_r               = param(10);
% dCl_r_lef          = param(11);
Cm                 = param(12);
dC_m               = param(13);
dCm_ds             = param(14);
Cm_elevator0       = param(15);
Cm_lef             = param(16);
Cm_q               = param(17);
dCm_q_lef          = param(18);
dCm_sb             = param(19);
eta_elevator       = param(20);
m_hat_delta_e      = param(21);              % m_hat_delta_e/2*0.12 = Cm_delta_ra = Cm_delta_la
% Cn                 = param(22);
% dCn_beta           = param(23);
% Cn_delta_ail       = param(24);
% Cn_delta_ail_lef   = param(25);
% Cn_delta_r         = param(26);
% Cn_elevator0       = param(27);
% Cn_lef             = param(28);
% Cn_p               = param(29);
% dCn_p_lef          = param(30);
% Cn_r               = param(31);
% dCn_r_lef          = param(32);
CX                 = param(33);
CX_elevator0       = param(34);
CX_lef             = param(35);
CX_q               = param(36);
CX_q_lef           = param(37);
dCX_sb             = param(38);
X_hat_delta_e      = param(39);              % X_hat_delta_e/2*0.4 = CX_delta_ra = CX_delta_la
CY                 = param(40);
CY_delta_ail       = param(41);
CY_delta_ail_lef   = param(42);
CY_delta_r         = param(43);
CY_lef             = param(44);
CY_p               = param(45);
dCY_p_lef          = param(46);
CY_r               = param(47);
dCY_r_lef          = param(48);
CZ                 = param(49);
CZ_elevator0       = param(50);
CZ_lef             = param(51);
CZ_q               = param(52);
dCZ_q_lef          = param(53);
dCZ_sb             = param(54);
Z_hat_delta_e      = param(55);              % Z_hat_delta_e/2*0.4 = CZ_delta_ra = CZ_delta_la
%% Geometry data
b        = ac.b;        % span, ft
cbar     = ac.cbar;     % mean aero chord, ft
Heng     = ac.Heng;     % turbine momentum along roll axis slug*ft^2，turbine momentum along roll axis  (文獻記載：假設是固定值 160 slug*ft^2)
Ix       = ac.Ix;       % slug-ft^2
Ixz      = ac.Ixz;      % slug-ft^2
Iy       = ac.Iy;       % slug-ft^2
Iz       = ac.Iz;       %slug-ft^2
lt       = ac.lt;
m        = ac.m;        %mass, slugs
S        = ac.S;        %planform area, ft^2
x_cg     = ac.x_cg;     %center of gravity as a fraction of cbar
x_cg_ref = ac.x_cg_ref; %reference center of gravity as a fraction of cbar
%% Intermediate variables
CXT       = CX + q*cbar/(2*Vt)*(CX_q+CX_q_lef*(1-dlef/25)) + (CX_lef-CX_elevator0)*(1-dlef/25) + dCX_sb*(dsb/60) + X_hat_delta_e/2*0.4*(dra+dla);
CYT       = CY + (CY_lef-CY)*(1-dlef/25) + (CY_delta_r-CY)*(dr/30) + p*b/(2*Vt)*(CY_p+dCY_p_lef*(1-dlef/25)) + r*b/(2*Vt)*(CY_r+dCY_r_lef*(1-dlef/25)) + ((CY_delta_ail-CY)+(CY_delta_ail_lef-CY_lef-CY_delta_ail+CY)*(1-dlef/25))/2*(dra/20-dla/20) + (CY_delta_ail-CY)/2*0.68*((dre/25)-(dle/25));
CZT       = CZ + q*cbar/(2*Vt)*(CZ_q+dCZ_q_lef*(1-dlef/25)) + (CZ_lef-CZ_elevator0)*(1-dlef/25) + dCZ_sb*(dsb/60) + Z_hat_delta_e/2*0.4*(dra+dla);
X         = qbar*S*CXT;
Y         = qbar*S*CYT;
Z         = qbar*S*CZT;
D         = -X*ca*cb - Y*sb - Z*sa*cb;
Y_bar     = -X*ca*sb + Y*cb - Z*sa*sb;
L         = X*sa - Z*ca;
CMT       = Cm*eta_elevator + (Cm_lef-Cm_elevator0)*(1-dlef/25) + CZT*(x_cg_ref-x_cg) + q*cbar/(2*Vt)*(Cm_q + dCm_q_lef*(1-dlef/25)) + dC_m + dCm_ds + dCm_sb*(dsb/60) + m_hat_delta_e/2*0.12*(dra+dla);
M_tot     = CMT*qbar*S*cbar;
T         = sqrt(Tx^2 + Ty^2 + Tz^2);
Tr        = T/2;
Tl        = T/2;
My_T      = Tl*(-lt*cos(dlz)*sin(dly)) - Tr*(lt*cos(drz)*sin(dry));
My        = M_tot+My_T;
%% State equation (來自勁豪論文程式，要再檢查f,N的正負號、跟庭宇的論文程式對照)
%--------------------------- Vt,aplha_dot----------------------------------
Vt_dot    = (-D + Y_bar*sb -m*g*sin(gamma) + Tx*cb*ca + Ty*sb + Tz*cb*sa - N*sin(gamma) + f*cos(chi)*cos(gamma) ) / (m);
alpha_dot = q-tb*(p*ca+r*sa)+ ( ( -L+m*g*cos(gamma)*cos(mu) )+ ( -Tx*sa+Tz*ca ) + ( N*cos(gamma)*cos(mu) ) + ( f*(sin(chi)*sin(mu)+cos(chi)*cos(mu)*sin(gamma)) )) /(m*Vt*cb);
%---------------------------theta_dot--------------------------------------
theta_dot = q*cphi - r*sphi;
%-----------------------------q_dot----------------------------------------     
q_dot     = (My + (Iz-Ix)*p*r - Ixz*(p*p-r*r) - r*Heng)/Iy;                                               
%% State derivatives
xdot(1)  = Vt_dot;
xdot(2)  = alpha_dot;
xdot(3)  = theta_dot;
xdot(4)  = q_dot;
%% xdot must be a column vector
xdot = xdot';
return
% end of function







