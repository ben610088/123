function xdot = xdot_TC02_F16_all_different_origin(ts, x, u, param)
% 記得改路徑
proj             = currentProject;                                                                  % 返回一個專案物件proj 代表當前打開的Project專案       
fileNameGeometry = fullfile(proj.RootFolder,'\sysID\sysID_timeDomain\sysID_GeometryData_A1.mat');   % 飛機 Geometry data 的存檔位置
sys_temp         = load(fileNameGeometry,'ac','g');
ac               = sys_temp.ac;
g                = sys_temp.g(3);
clear('sys_temp');          % 刪掉無用的變數，以釋放記憶體、保持 Workspace 乾淨

%% State variables
Vt    = x(1);
alpha = x(2);
beta  = x(3);
phi   = x(4);
theta = x(5);
% psi   = x(6);           % 沒用到
p     = x(7);
q     = x(8);
r     = x(9);
mu    = x(10);
chi   = x(11);
gamma = x(12);
%% Input variables
dre  = u(1);    % 右升降舵 
dle  = u(2);    % 左升降舵
dra  = u(3);    % 右副翼 
dla  = u(4);    % 左副翼
dr   = u(5);    % 方向舵
dry  = u(6);    % 右向量噴嘴上下偏轉(pitch)
drz  = u(7);    % 右向量噴嘴左右偏轉(yaw)
dly  = u(8);    % 左向量噴嘴上下偏轉(pitch)
dlz  = u(9);    % 左向量噴嘴左右偏轉(yaw)
dlef = u(10);   % 翼前緣leading edge
dsb  = u(11);   % 減速版
%% pseudo input 虛擬輸入、Measured Values 量測值
% [eBook] 2015 Flight vehicle system identification - a time domain methodology, Second Edition p369：9.16.2節在分析橫向運動，但是state equation卻出現縱向的變數，我們將其視為虛擬輸入，將其視為已知變數，其值為time-history訊號的值
% [eBook] 2006 Aircraft System Identification - Theory And Practice p69：第3.9.2節 Substituting Measured Values
Tx  = u(12);
Ty  = u(13);
Tz  = u(14);
qbar = u(15);
N   = u(16);
f   = u(17);
%% Abbreviation
sa = sin(alpha);
ca = cos(alpha);
sb = sin(beta);
cb = cos(beta);    
tb = tan(beta);
% st = sin(theta);      % 沒用到
ct = cos(theta);
tt = tan(theta);
sphi = sin(phi);
cphi = cos(phi);
% spsi = sin(psi);      % 沒用到
% cpsi = cos(psi);      % 沒用到
%% Parameters
Cl                    = param(1);
dCl_beta              = param(2);
Cl_delta_ail          = param(3);
Cl_delta_ail_lef      = param(4);
Cl_delta_r            = param(5);
Cl_elevator0          = param(6);
Cl_lef                = param(7);
Cl_p                  = param(8);
dCl_p_lef             = param(9);
Cl_r                  = param(10);
dCl_r_lef             = param(11);
Cm                    = param(12);
dC_m                  = param(13);
dCm_ds                = param(14);
dCm_ds_relevatorPdeci = param(15);        % relevatorPdeci = 右邊elevator +0.1(deg)
dCm_ds_lelevatorPdeci = param(16);        % lelevatorPdeci = 左邊elevator +0.1(deg)
dCm_ds_relevatorNdeci = param(17);        % relevatorNdeci = 右邊elevator -0.1(deg)
dCm_ds_lelevatorNdeci = param(18);        % lelevatorNdeci = 左邊elevator -0.1(deg)
Cm_elevator0          = param(19);
Cm_relevatorPdeci     = param(20);        % relevatorPdeci = 右邊elevator +0.1(deg)
Cm_lelevatorPdeci     = param(21);        % lelevatorPdeci = 左邊elevator +0.1(deg)
Cm_relevatorNdeci     = param(22);        % relevatorNdeci = 右邊elevator -0.1(deg)
Cm_lelevatorNdeci     = param(23);        % lelevatorNdeci = 左邊elevator -0.1(deg)
Cm_lef                = param(24);
Cm_q                  = param(25);
dCm_q_lef             = param(26);
dCm_sb                = param(27);
eta_elevator          = param(28);
eta_relevatorPdeci    = param(29);        % relevatorPdeci = 右邊elevator +0.1(deg)
eta_lelevatorPdeci    = param(30);        % lelevatorPdeci = 左邊elevator +0.1(deg)
eta_relevatorNdeci    = param(31);        % relevatorNdeci = 右邊elevator -0.1(deg)
eta_lelevatorNdeci    = param(32);        % lelevatorNdeci = 左邊elevator -0.1(deg)
Cn                    = param(33);
dCn_beta              = param(34);
Cn_delta_ail          = param(35);
Cn_delta_ail_lef      = param(36);
Cn_delta_r            = param(37);
Cn_elevator0          = param(38);
Cn_lef                = param(39);
Cn_p                  = param(40);
dCn_p_lef             = param(41);
Cn_r                  = param(42);
dCn_r_lef             = param(43);
CX                    = param(44);
CX_relevatorPdeci     = param(45);        % relevatorPdeci = 右邊elevator +0.1(deg)
CX_lelevatorPdeci     = param(46);        % lelevatorPdeci = 左邊elevator +0.1(deg)
CX_relevatorNdeci     = param(47);        % relevatorNdeci = 右邊elevator -0.1(deg)
CX_lelevatorNdeci     = param(48);        % lelevatorNdeci = 左邊elevator -0.1(deg)
CX_elevator0          = param(49);
CX_lef                = param(50);
CX_q                  = param(51);
CX_q_lef              = param(52);
dCX_sb                = param(53);
CY                    = param(54);
CY_delta_ail          = param(55);
CY_delta_ail_lef      = param(56);
CY_delta_r            = param(57);
CY_lef                = param(58);
CY_p                  = param(59);
dCY_p_lef             = param(60);
CY_r                  = param(61);
dCY_r_lef             = param(62);
CZ                    = param(63);
CZ_elevator0          = param(64);
CZ_relevatorPdeci     = param(65);        % relevatorPdeci = 右邊elevator +0.1(deg)
CZ_lelevatorPdeci     = param(66);        % lelevatorPdeci = 左邊elevator +0.1(deg)
CZ_relevatorNdeci     = param(67);        % relevatorNdeci = 右邊elevator -0.1(deg)
CZ_lelevatorNdeci     = param(68);        % lelevatorNdeci = 左邊elevator -0.1(deg)
CZ_lef                = param(69);
CZ_q                  = param(70);
dCZ_q_lef             = param(71);
dCZ_sb                = param(72);
%% Geometry data
b        = ac.b;        % span, ft
cbar     = ac.cbar;     % mean aero chord, ft
Heng     = ac.Heng;     % turbine momentum along roll axis slug*ft^2，turbine momentum along roll axis  (文獻記載：假設是固定值 160 slug*ft^2)
Ix       = ac.Ix;       % slug-ft^2
% Ixy      = ac.Ixy;    % slug*ft^2       % 沒用到
Ixz      = ac.Ixz;      % slug-ft^2
Iy       = ac.Iy;       % slug-ft^2
% Iyz      = ac.Iyz;    % slug*ft^2       % 沒用到
Iz       = ac.Iz;       %slug-ft^2
lt       = ac.lt;
m        = ac.m;        %mass, slugs
mt       = ac.mt;       % 預設值 15552 ft, 向量噴嘴旋轉中心點至重心的距離 Engine nozzle after of cg
S        = ac.S;        %planform area, ft^2
x_cg     = ac.x_cg;     %center of gravity as a fraction of cbar
x_cg_ref = ac.x_cg_ref; %reference center of gravity as a fraction of cbar
%% Intermediate variables
X_hat_delta_re = (CX_relevatorPdeci-CX_relevatorNdeci)/0.2;
X_hat_delta_le = (CX_lelevatorPdeci-CX_lelevatorNdeci)/0.2;
CXT            = CX + q*cbar/(2*Vt)*(CX_q+CX_q_lef*(1-dlef/25)) + (CX_lef-CX_elevator0)*(1-dlef/25) + dCX_sb*(dsb/60) + (X_hat_delta_re/2*0.4)*dra + (X_hat_delta_le/2*0.4)*dla;
CYT            = CY + (CY_lef-CY)*(1-dlef/25) + (CY_delta_r-CY)*(dr/30) + p*b/(2*Vt)*(CY_p+dCY_p_lef*(1-dlef/25)) + r*b/(2*Vt)*(CY_r+dCY_r_lef*(1-dlef/25)) + ((CY_delta_ail-CY)+(CY_delta_ail_lef-CY_lef-CY_delta_ail+CY)*(1-dlef/25))/2*(dra/20-dla/20) + (CY_delta_ail-CY)/2*0.68*((dre/25)-(dle/25));
Z_hat_delta_re = (CZ_relevatorPdeci-CZ_relevatorNdeci)/0.2;
Z_hat_delta_le = (CZ_lelevatorPdeci-CZ_lelevatorNdeci)/0.2;
CZT            = CZ + q*cbar/(2*Vt)*(CZ_q+dCZ_q_lef*(1-dlef/25)) + (CZ_lef-CZ_elevator0)*(1-dlef/25) + dCZ_sb*(dsb/60) + (Z_hat_delta_re/2*0.4)*dra + (Z_hat_delta_le/2*0.4)*dla;
X              = qbar*S*CXT;
Y              = qbar*S*CYT;
Z              = qbar*S*CZT;
D              = -X*ca*cb - Y*sb - Z*sa*cb;
Y_bar          = -X*ca*sb + Y*cb - Z*sa*sb;
L              = X*sa - Z*ca;
CLT            = Cl + (Cl_lef-Cl_elevator0)*(1-dlef/25) + dCl_beta*beta + (Cl_delta_r-Cl_elevator0)*(dr/30) + p*b/(2*Vt)*(Cl_p+dCl_p_lef*(1-dlef/25)) + r*b/(2*Vt)*(Cl_r+dCl_r_lef*(1-dlef/25)) + ((Cl_delta_ail-Cl_elevator0) + (Cl_delta_ail_lef-Cl_lef-Cl_delta_ail+Cl_elevator0)*(1-dlef/25))/2*(dra/20-dla/20) + (Cl_delta_ail-Cl_elevator0)/2*0.56*(dre/25-dle/25);
m_hat_delta_re = 1/0.2*(Cm_relevatorPdeci*eta_relevatorPdeci + dCm_ds_relevatorPdeci+(x_cg_ref-x_cg)*CZ_relevatorPdeci - Cm_relevatorNdeci*eta_relevatorNdeci - dCm_ds_relevatorNdeci - (x_cg_ref-x_cg)*CZ_relevatorNdeci);
m_hat_delta_le = 1/0.2*(Cm_lelevatorPdeci*eta_lelevatorPdeci + dCm_ds_lelevatorPdeci+(x_cg_ref-x_cg)*CZ_lelevatorPdeci - Cm_lelevatorNdeci*eta_lelevatorNdeci - dCm_ds_lelevatorNdeci - (x_cg_ref-x_cg)*CZ_lelevatorNdeci);
CMT            = Cm*eta_elevator + (Cm_lef-Cm_elevator0)*(1-dlef/25) + CZT*(x_cg_ref-x_cg) + q*cbar/(2*Vt)*(Cm_q + dCm_q_lef*(1-dlef/25)) + dC_m + dCm_ds + dCm_sb*(dsb/60) + m_hat_delta_re/2*0.12*dra + m_hat_delta_le/2*0.12*dla;
CNT            = Cn + (Cn_lef-Cn_elevator0)*(1-dlef/25) - CYT*(x_cg_ref-x_cg)*cbar/b + p*b/(2*Vt)*(Cn_p+dCn_p_lef*(1-dlef/25)) + (Cn_delta_r-Cn_elevator0)*(dr/30) + r*b/(2*Vt)*(Cn_r+dCn_r_lef*(1-dlef/25)) + dCn_beta*beta + ((Cn_delta_ail-Cn_elevator0)+(Cn_delta_ail_lef-Cn_lef-Cn_delta_ail+Cn_elevator0)*(1-dlef/25))/2*((dra/20)-(dla/20)) + (Cn_delta_ail-Cn_elevator0)/2*0.26*((dre/25)-(dle/25));
L_tot          = CLT*qbar*S*b;    %get moments from coefficients
M_tot          = CMT*qbar*S*cbar;
N_tot          = CNT*qbar*S*b;
T              = sqrt(Tx^2 + Ty^2 + Tz^2);
Tr             = T/2;
Tl             = T/2;
Mx_T           = Tl*(mt*cos(dlz)*sin(dly)) - Tr*(mt*cos(drz)*sin(dry));
My_T           = Tl*(-lt*cos(dlz)*sin(dly)) - Tr*(lt*cos(drz)*sin(dry));
Mz_T           = Tl*(-lt*sin(dlz)) - Tr*(lt*sin(drz));       % 這是仿照勁豪論文程式碼，這是錯誤的
% Mz_T         = Tl*(-lt*sin(dlz) + mt*cos(dlz)*cos(dly)) - Tr*(lt*sin(drz) - mt*cos(drz)*cos(dry));   % 這是正確的
Mx             = L_tot+Mx_T;
My             = M_tot+My_T;
Mz             = N_tot+Mz_T;
denom          = Ix*Iz - Ixz*Ixz;
%% State equation (來自勁豪論文程式，要再檢查f,N的正負號、跟庭宇的論文程式對照)
%--------------------------- Vt,aplha,beta_dot-----------------------------
Vt_dot    = (-D + Y_bar*sb -m*g*sin(gamma) + Tx*cb*ca + Ty*sb + Tz*cb*sa - N*sin(gamma) + f*cos(chi)*cos(gamma) ) / (m);
alpha_dot = q-tb*(p*ca+r*sa)+ ( ( -L+m*g*cos(gamma)*cos(mu) )+ ( -Tx*sa+Tz*ca ) + ( N*cos(gamma)*cos(mu) ) + ( f*(sin(chi)*sin(mu)+cos(chi)*cos(mu)*sin(gamma)) )) /(m*Vt*cb);
beta_dot  = -r*ca + p*sa + ( Y_bar*cb+m*g*cos(gamma)*sin(mu) -Tx*sb*ca + Ty*cb - Tz*sb*sa + N*cos(gamma)*sin(mu) - f*(cos(mu)*sin(chi)-cos(chi)*sin(gamma)*sin(mu)) ) / (m*Vt);
%---------------------------phi,theta,psi_dot------------------------------
phi_dot   = p + tt*(q*sphi + r*cphi);
theta_dot = q*cphi - r*sphi;
psi_dot   = (q*sphi + r*cphi)/ct;
%-----------------------------pqr_dot--------------------------------------
p_dot     = (Iz*Mx + Ixz*Mz - (Iz*(Iz-Iy)+Ixz*Ixz)*q*r + Ixz*(Ix-Iy+Iz)*p*q + Ixz*q*Heng)/denom;     
q_dot     = (My + (Iz-Ix)*p*r - Ixz*(p*p-r*r) - r*Heng)/Iy;                                           
r_dot     = (Ix*Mz + Ixz*Mx + (Ix*(Ix-Iy)+Ixz*Ixz)*p*q - Ixz*(Ix-Iy+Iz)*q*r +  Ix*q*Heng)/denom;      
%--------------------------mu,chi,gamma------------------------------------
mu_dot    = ( p*ca+r*sa ) / cb + ( L / ( m*Vt ) )*( tan(gamma)*sin(mu)+tb ) + ( (Y_bar + Ty) / (m*Vt) )*tan(gamma)*cos(mu)*cb+...
    + (-g/Vt)*cos(gamma)*cos(mu)*tb + (Tx*sa - Tz*ca)*( tan(gamma)*sin(mu)+tb ) / (m*Vt) - (Tx*ca + Tz*sa)*( tan(gamma)*cos(mu)*sb ) / (m*Vt)+...
    - N*tb*cos(gamma)*cos(mu) / (m*Vt) - f*( cos(mu)*cos(chi)*sin(gamma)*tb + sin(chi)*tan(gamma) + sin(chi)*tb*sin(mu) ) / (m*Vt);
chi_dot   = ( L*sin(mu) + Y_bar*cos(mu)*cb + Tx*( sin(mu)*sa - cos(mu)*sb*ca) + Ty*(cos(mu)*cb) -Tz*( cos(mu)*sb*sa+sin(mu)*ca ) - f*sin(chi) ) / ( m*Vt*cos(gamma) );
gamma_dot = ( L*cos(mu) - Y_bar*sin(mu)*cb - m*g*cos(gamma) + Tx* ( sin(mu)*sb*ca + cos(mu)*sa ) -Ty*(sin(mu)*cb) + Tz*( sin(mu)*sb*sa-cos(mu)*ca ) - N*cos(gamma) - f*cos(chi)*sin(gamma) ) / (m*Vt);

%% State derivatives
xdot(1)  = Vt_dot;
xdot(2)  = alpha_dot;
xdot(3)  = beta_dot;
xdot(4)  = phi_dot;
xdot(5)  = theta_dot;
xdot(6)  = psi_dot;
xdot(7)  = p_dot;
xdot(8)  = q_dot;
xdot(9)  = r_dot;
xdot(10) = mu_dot;
xdot(11) = chi_dot;
xdot(12) = gamma_dot;
%% xdot must be a column vector
xdot = xdot';
return
% end of function







