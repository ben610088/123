function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata, ...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase08_longitudinal_same_origin(test_case)
% Inputs
%    test_case    test case number
%
% Outputs
%    state_eq     function to code right hand sides of state equations       
%    obser_eq     function to code right hand sides of observation equations
%    Nx           number of states 
%    Ny           number of observation variables
%    Nu           number of input (control) variables
%    NparSys      number of system parameters
%    Nparam       total number of system and bias parameters
%    NparID       total number of parameters to be estimated (free parameters)
%    dt           sampling time
%    Ndata        total number of data points for Nzi time segments
%    t            time vector
%    Z            observation variables: Data array of measured outputs (Ndata,Ny)
%    Uinp         input variables: Data array of measured input (Ndata,Nu)
%    param        initial starting values for unknown parameters (aerodynamic derivatives) 
%    parFlag      flags for free and fixed parameters
%    x0           initial conditions on state variables
%    iSD          Flag to specify optionally initial R (default; 0) 
%    SDyError     standard-deviations of output errors to compute initial covariance
%                 matrix R (required only for iSD ~= 0)

%% Model definition
state_eq   = 'xdot_TC08_F16_longitudinal_same_origin';% Function for state equations       
obser_eq   = 'obs_TC08_F16_longitudinal_same_origin'; % Function for observation equations
Nx         = 4;                                     % Number of states 
Ny         = 7;                                     % Number of observation variables
Nu         = 25;                                    % Number of input (control) variables
NCl        = 11;                                    % Number of Cl prameters
NCm        = 15;                                    % Number of Cm prameters
NCn        = 11;                                    % Number of Cn prameters
NCX        = 8;                                     % Number of CX prameters
NCY        = 9;                                     % Number of CY prameters
NCZ        = 8;                                     % Number of CZ prameters
NparSys    = NCl + NCm + NCn + NCX + NCY + NCZ;     % Number of total system parameters
Nparam     = NparSys + Nx;                          % Total number of parameters to be estimated
iSD        = 0;                                     % Initial R option (default; 0) 

% 記得要改正確路徑
proj             = currentProject;                                                                  % 返回一個專案物件proj 代表當前打開的Project專案       
fileNameGeometry = fullfile(proj.RootFolder,'\sysID\sysID_timeDomain\sysID_GeometryData_A1.mat');   % 飛機 Geometry data 的存檔位置
load(fileNameGeometry,'ac','Sensor');                 
dt         = 0.1;                                   % 資料擷取系統的取樣時間 sec


disp(['Test Case = ', num2str(test_case)]);
disp('Flight motion, nonlinear model -- F-16A/B -- longitudinal : Nx=4, Ny=7, Nu=25')

%% Load flight data for Nzi time segments to be analyzed and concatenate 
% 記得要改正確路徑
fileNameOutputData = fullfile(proj.RootFolder,'\sysID\sysID_timeDomain\sysID_OutputData.mat'); % 飛機 Geometry data 的存檔位置
load(fileNameOutputData);
fileNameInputData = fullfile(proj.RootFolder,'\sysID\sysID_timeDomain\sysID_InputData.mat');   % 飛機 Geometry data 的存檔位置
load(fileNameInputData);






data1 = sysID_OutputData.Data(1:10,:);                      % Simulink 戰鬥機輸出的狀態
data2 = sysID_InputData.Data(1:10,:);                       % Simulink 戰鬥機輸入的舵面







Ndata = size(data1,1);                              % 資料個數 Number of data points
t     = transpose( 0 : dt : ((Ndata-1)*dt) );       % 產生時間向量

%% Observation variables V, alpha, theta, q, qdot, ax, az
Z = [data1(:,1) data1(:,2) data1(:,5) data1(:,8) data1(:,11) data1(:,13) data1(:,15)];
% Z(:,1)  = data1(:,1);          % V  
% Z(:,2)  = data1(:,2);          % alpha
% Z(:,3)  = data1(:,5);          % theta
% Z(:,4)  = data1(:,8);          % q
% Z(:,5) = data1(:,11);          % qdot
% Z(:,6) = data1(:,13);          % ax
% Z(:,7) = data1(:,15);          % az

%% Input variables dre, dle, dra, dla, dr, dry, drz, dly, dlz, dlef, dsb, Tx, Ty, Tz, qbar, N, f, beta, phi, psi, p, r, mu, chi, gamma
Uinp = [data2(:,1) data2(:,2) data2(:,3) data2(:,4) data2(:,5) ...
        deg2rad(data2(:,6)) deg2rad(data2(:,7)) deg2rad(data2(:,8)) deg2rad(data2(:,9)) data2(:,10) ...
        data2(:,11) data2(:,12) data2(:,13) data2(:,14) data2(:,15) ...
        data2(:,16) data2(:,17) data1(:,3) data1(:,4) data1(:,6) ...
        data1(:,7) data1(:,9) data1(:,16) data1(:,17) data1(:,18)];
% Uinp(:,1)  = data2(:,1);                % dre
% Uinp(:,2)  = data2(:,2);                % dle
% Uinp(:,3)  = data2(:,3);                % dra
% Uinp(:,4)  = data2(:,4);                % dla
% Uinp(:,5)  = data2(:,5);                % dr
% Uinp(:,6)  = deg2rad(data2(:,6));       % dry，單位：deg->rad
% Uinp(:,7)  = deg2rad(data2(:,7));       % drz，單位：deg->rad
% Uinp(:,8)  = deg2rad(data2(:,8));       % dly，單位：deg->rad
% Uinp(:,9)  = deg2rad(data2(:,9));       % dlz，單位：deg->rad
% Uinp(:,10) = data2(:,10);               % dlef
% Uinp(:,11) = data2(:,11);               % dsb
% Uinp(:,12) = data2(:,12);               % Tx
% Uinp(:,13) = data2(:,13);               % Ty
% Uinp(:,14) = data2(:,14);               % Tz
% Uinp(:,15) = data2(:,15);               % qbar
% Uinp(:,16) = data2(:,16);               % N
% Uinp(:,17) = data2(:,17);               % f
% Uinp(:,18) = data1(:,3);                % beta
% Uinp(:,19) = data1(:,4);                % phi
% Uinp(:,20) = data1(:,6);                % psi
% Uinp(:,21) = data1(:,7);                % p
% Uinp(:,22) = data1(:,9);                % r
% Uinp(:,23) = data1(:,16);               % mu
% Uinp(:,24) = data1(:,17);               % chi
% Uinp(:,25) = data1(:,18);               % gamma

%% Initial starting values for unknown parameters (aerodynamic derivatives)
% Cl, dCl_beta, Cl_delta_ail, 
% Cl_delta_ail_lef, Cl_delta_r, Cl_elevator0, 
% Cl_lef, Cl_p, dCl_p_lef,
% Cl_r, dCl_r_lef
% Cm, dC_m, dCm_ds, 
% dCm_ds_elevatorPdeci, dCm_ds_elevatorNdeci, Cm_elevator0,
% Cm_elevatorPdeci, Cm_elevatorNdeci, Cm_lef, 
% Cm_q, dCm_q_lef, dCm_sb, 
% eta_elevator, eta_elevatorPdeci, eta_elevatorNdeci
% Cn, dCn_beta, Cn_delta_ail,
% Cn_delta_ail_lef, Cn_delta_r, Cn_elevator0, 
% Cn_lef, Cn_p, dCn_p_lef, 
% Cn_r, dCn_r_lef
% CX, CX_elevatorPdeci, CX_elevatorNdeci, 
% CX_elevator0, CX_lef, CX_q, 
% CX_q_lef, dCX_sb
% CY, CY_delta_ail, CY_delta_ail_lef, 
% CY_delta_r, CY_lef, CY_p, 
% dCY_p_lef, CY_r, dCY_r_lef
% CZ, CZ_elevator0, CZ_elevatorPdeci, 
% CZ_elevatorNdeci, CZ_lef, CZ_q, 
% dCZ_q_lef, dCZ_sb
% f11, f22, f33, f44                      % 因為狀態有4個，所以要有4個!?
% 注意：param亂給的話會導致FEM法無法收斂。
% 建議：使用風洞測試數據或者跑CFD模擬先去估測param的大小，再用FEM法去驗證這些氣動力參數是否正確。
% Case：最接近配平點的值
param = [ % 11個 Cl
          -1.5388e-10; 2.1868e-5; -0.0499;
          -0.0444; 0.0137; -1.5388e-10;
          -1.217e-10; -0.6072; 0.0589;
          0.2055; 0.0088;
          % 15個 Cm (12個 Cm + 3個 eta_elevator)
          -0.025; 0.0206; 0; 
          0; 0; -0.0436; 
          -0.026; -0.024; -5.4096e-4; 
          -6.0412; -0.1922; 0.0212; 
          1; 1; 1.;
          % 11個 Cn
          1.4594e-10; 0; -0.0089; 
          -0.0055; -0.0441; 1.4751e-10; 
          1.4919e-10; -0.032; 0.0441; 
          -0.3756; 0.0072;
          % 08個 CX 
          0.0491; 0.0492; 0.491; 
          0.0508; 0.0103; 2.9319;
          -1.9772; -0.0804;
          % 09個 CY
          -8.9678e-10; 0.0282; 0.0236; 
          0.085; -8.8434e-10; 0.3076; 
          -0.1188; 0.9984; -0.3076;
          % 08個 CZ
          -0.7424; -0.7613; -0.7343; 
          -0.7414; -0.7854; -31.2625;
          0.1719; -0.3059;
          % 04個狀態
          2e-2; 2e-2; 2e-2; 2e-2];
          % 隨機產生的62個數字 + 4個狀態      
% Case：接近配平點的值
% param = [ % 11個 Cl
%           -0.000000000124; 0.0000337; -0.0412;
%           -0.0538; 0.0211; -0.000000000229;
%           -0.000000000166; -0.6072; 0.0343;
%           0.1654; 0.0289;
%           % 15個 Cm (12個 Cm + 3個 eta_elevator)
%           -0.01499; 0.0229; 0.000000001; 
%           0.00000001; 0.00000001; -0.0000000000558; 
%           -6.2996; -0.2105; -0.00443; 
%           -7.0107; -0.1102; 0.0192; 
%           1.00051; 0.00941; 1.00222;
%           % 11個 Cn
%           0.000000000262; 0.00000000012; -0.00775; 
%           -0.00417; -0.0369; 0.000000000184; 
%           0.000000000088; -0.0260; 0.0600; 
%           -0.431; 0.00911;
%           % 08個 CX 
%           0.0346; 0.0536; 0.0469; 
%           0.0580; 0.0058; 3.0145;
%           -2.0853; -0.0622;
%           % 09個 CY
%           0.000000000951; 0.0413; 0.0402; 
%           0.0756; -0.000000000240; 0.3123; 
%           -0.1484; 0.8240; -0.1217;
%           % 08個 CZ
%           -0.689; -0.7338; -0.70100; 
%           -0.7691; -0.6911; -32.0780;
%           0.1531; -0.410;
%           % 04個狀態
%           2e-2; 2e-2; 2e-2; 2e-2];
%           % 隨機產生的62個數字 + 4個狀態      

% Case：隨便給值
% param       = [ % 11個 Cl
%               0.0012; 0.0337; 0.0162; 0.0794; 0.0311;
%               0.0529; 0.0166; 0.0602; 0.0263; 0.0654;
%               0.0689;
%               % 15個 Cm ( 17個 Cm + 4個 eta_elevator )
%               0.0084; 0.0229; 0.0913; 0.0152; 0.0826;
%               0.0538; 0.0996; 0.0078; 0.0443; 0.0107;
%               0.0112; 0.0102; 0.0851; 0.0941; 0.0222;
%               % 11個 Cn
%               0.0962; 0.0005; 0.0775; 0.0817; 0.0869;
%               0.0084; 0.0400; 0.0260; 0.0800; 0.0431;
%               0.0911;
%               % 08個 CX
%               0.0146; 0.0136; 0.0869; 0.0580; 0.0550;
%               0.0145; 0.0853; 0.0622;
%               % 09個 CY
%               0.0351; 0.0513; 0.0402; 0.0076; 0.0240;
%               0.0123; 0.0184; 0.0240; 0.0417;
%               % 08個 CZ
%               0.0489; 0.0338; 0.0900; 0.0369; 0.0111;
%               0.0780; 0.0531; 0.0510;
%               % 04個狀態
%               2e-2; 2e-2; 2e-2; 2e-2];

%% Flags for free and fixed parameters = 1: free parameters (to be estimated) = 0: fixed parameters (not to be estimated)
parFlag = [zeros(NCl,1); ones(NCm,1); zeros(NCn,1); ones(NCX,1); zeros(NCY,1); ones(NCZ,1); ones(4,1)];
       
%% Total number of free parameters
NparID = size(find(parFlag~=0),1); 

%% Initial conditions on state variables V, alpha, theta, q
% 將 x0 設定成在 配平點/平衡點/初始飛行條件 的附近
% 注意：初始值X0若偏離正確值太多會使FEM法無法收斂。
% 建議：使用飛機上的感測器量測值
% Case：最接近配平點的值
x0 = [323; deg2rad(10); deg2rad(10); 4.442e-8];
% Case：隨便給值(1)
% x0 = [323; deg2rad(10); deg2rad(10); -0.0000003];
% Case：隨便給值(2)
% x0 = [323; deg2rad(10); deg2rad(10); 1e-3];
%% Initial R: Default (iSD=0) or specified as standard-deviations of output errors 
SDyError = [];
% SDyError = zeros(Ny,1);
% iSD = 1;
% SDyError = [.....]';     % if iSD=1, specify SD for Ny outputs
