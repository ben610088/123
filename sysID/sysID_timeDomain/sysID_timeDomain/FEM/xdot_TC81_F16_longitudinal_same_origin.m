function xdot = xdot_TC81_F16_longitudinal_same_origin(ts, x, u, param)
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
% dCl_beta                = param(1);
% Cl_delta_ail            = param(2);
% Cl_delta_ail_lef        = param(2);
% Cl_delta_r              = param(4);
% Cl_p                    = param(5);
% dCl_p_lef               = param(6);
% Cl_r                    = param(7);
% dCl_r_lef               = param(8);
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
% dCn_beta                = param(24);
% Cn_delta_ail            = param(25);
% Cn_delta_ail_lef        = param(26);
% Cn_delta_r              = param(27);
% Cn_p                    = param(28);
% dCn_p_lef               = param(29);
% Cn_r                    = param(30);
% dCn_r_lef               = param(31);
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
b        = ac.b;        % span, ft
cbar     = ac.cbar;     % mean aero chord, ft
Heng     = ac.Heng;     % turbine momentum along roll axis slug*ft^2，turbine momentum along roll axis  (文獻記載：假設是固定值 160 slug*ft^2)
Ix       = ac.Ix;       % slug-ft^2
Ixz      = ac.Ixz;      % slug-ft^2
Iy       = ac.Iy;       % slug-ft^2
Iz       = ac.Iz;       % slug-ft^2
lt       = ac.lt;
m        = ac.m;        % mass, slugs
S        = ac.S;        % planform area, ft^2
x_cg     = ac.x_cg;     % center of gravity as a fraction of cbar
x_cg_ref = ac.x_cg_ref; % reference center of gravity as a fraction of cbar
%% Intermediate variables
X_hat_delta_e = (CX_elevatorPdeci-CX_elevatorNdeci)/0.2;
CXT           = CX + q*cbar/(2*Vt)*(CX_q+CX_q_lef*(1-dlef/25)) + (CX_lef-CX_elevator0)*(1-dlef/25) + dCX_sb*(dsb/60) + (X_hat_delta_e/2*0.4)*(dra+dla);
CYT           = (CY_delta_r)*(dr/30) + p*b/(2*Vt)*(CY_p+dCY_p_lef*(1-dlef/25)) + r*b/(2*Vt)*(CY_r+dCY_r_lef*(1-dlef/25)) + ((CY_delta_ail)+(CY_delta_ail_lef-CY_delta_ail)*(1-dlef/25))/2*(dra/20-dla/20) + (CY_delta_ail)/2*0.68*((dre/25)-(dle/25));
Z_hat_delta_e = (CZ_elevatorPdeci-CZ_elevatorNdeci)/0.2;
CZT           = CZ + q*cbar/(2*Vt)*(CZ_q+dCZ_q_lef*(1-dlef/25)) + (CZ_lef-CZ_elevator0)*(1-dlef/25) + dCZ_sb*(dsb/60) + (Z_hat_delta_e/2*0.4)*(dra+dla);
X             = qbar*S*CXT;
Y             = qbar*S*CYT;
Z             = qbar*S*CZT;
D             = -X*ca*cb - Y*sb - Z*sa*cb;
Y_bar         = -X*ca*sb + Y*cb - Z*sa*sb;
L             = X*sa - Z*ca;
m_hat_delta_e = 1/0.2*(Cm_elevatorPdeci*eta_elevatorPdeci + dCm_ds_elevatorPdeci+(x_cg_ref-x_cg)*CZ_elevatorPdeci - Cm_elevatorNdeci*eta_elevatorNdeci - dCm_ds_elevatorNdeci - (x_cg_ref-x_cg)*CZ_elevatorNdeci);
CMT           = Cm*eta_elevator + (Cm_lef-Cm_elevator0)*(1-dlef/25) + CZT*(x_cg_ref-x_cg) + q*cbar/(2*Vt)*(Cm_q + dCm_q_lef*(1-dlef/25)) + dC_m + dCm_ds + dCm_sb*(dsb/60) + m_hat_delta_e/2*0.12*(dra+dla);
M_tot         = CMT*qbar*S*cbar;
T             = sqrt(Tx^2 + Ty^2 + Tz^2);
Tr            = T/2;
Tl            = T/2;
My_T          = Tl*(-lt*cos(dlz)*sin(dly)) - Tr*(lt*cos(drz)*sin(dry));
My            = M_tot+My_T;
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







