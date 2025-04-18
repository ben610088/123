function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata, ...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase04_all_same_origin(test_case)
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
state_eq   = 'xdot_TC04_F16_all_same_origin';       % Function for state equations       
obser_eq   = 'obs_TC04_F16_all_same_origin';        % Function for observation equations
Nx         = 12;                                    % Number of states 
Ny         = 18;                                    % Number of observation variables
Nu         = 17;                                    % Number of input (control) variables
NCl        = 11;                                    % Number of Cl prameters
NCm        = 15;                                    % Number of Cm prameters
NCn        = 11;                                    % Number of Cn prameters
NCX        =  8;                                    % Number of CX prameters
NCY        =  9;                                    % Number of CY prameters
NCZ        =  8;                                    % Number of CZ prameters
NparSys    = NCl + NCm + NCn + NCX + NCY + NCZ;     % Number of total system parameters
Nparam     = NparSys + Nx;                          % Total number of parameters to be estimated
iSD        =  0;                                    % Initial R option (default; 0) 

% 記得要改正確路徑
proj             = currentProject;                                                                  % 返回一個專案物件proj 代表當前打開的Project專案       
fileNameGeometry = fullfile(proj.RootFolder,'\sysID\sysID_timeDomain\sysID_GeometryData_A1.mat');   % 飛機 Geometry data 的存檔位置
load(fileNameGeometry,'ac','Sensor');                       
dt         = 0.1;                                   % 資料擷取系統的取樣時間 sec


disp(['Test Case = ', num2str(test_case)]);
disp('Flight motion, nonlinear model -- F-16A/B: Nx=12, Ny=18, Nu=17')

%% Load flight data for Nzi time segments to be analyzed and concatenate 
% 記得要改正確路徑
fileNameOutputData = fullfile(proj.RootFolder,'\sysID\sysID_timeDomain\sysID_OutputData.mat'); % 飛機 Geometry data 的存檔位置
load(fileNameOutputData);
fileNameInputData = fullfile(proj.RootFolder,'\sysID\sysID_timeDomain\sysID_InputData.mat');   % 飛機 Geometry data 的存檔位置
load(fileNameInputData);
data1 = sysID_OutputData.Data;                      % Simulink 戰鬥機輸出的狀態
data2 = sysID_InputData.Data;                       % Simulink 戰鬥機輸入的舵面

Ndata = size(data1,1);                              % 資料個數 Number of data points
% t     = transpose( 0 : dt : ((Ndata-1)*dt) );       % 產生時間向量
t       = 0 + dt*(0:(Ndata-1))';

%% Observation variables V, alpha, beta, phi, theta, psi, p, q, r, pdot, qdot, rdot, ax, ay, az, mu, chi, gamma
Z = [data1(:,1) data1(:,2) data1(:,3) data1(:,4) data1(:,5) ...
     data1(:,6) data1(:,7) data1(:,8) data1(:,9) data1(:,10) ...
     data1(:,11) data1(:,12) data1(:,13) data1(:,14) data1(:,15) ...
     data1(:,16) data1(:,17) data1(:,18)];
% Z(:,1)  = data1(:,1);          % V  
% Z(:,2)  = data1(:,2);          % alpha
% Z(:,3)  = data1(:,3);          % beta
% Z(:,4)  = data1(:,4);          % phi
% Z(:,5)  = data1(:,5);          % theta
% Z(:,6)  = data1(:,6);          % psi
% Z(:,7)  = data1(:,7);          % p
% Z(:,8)  = data1(:,8);          % q
% Z(:,9)  = data1(:,9);          % r
% Z(:,10) = data1(:,10);         % pdot
% Z(:,11) = data1(:,11);         % qdot
% Z(:,12) = data1(:,12);         % rdot
% Z(:,13) = data1(:,13);         % ax
% Z(:,14) = data1(:,14);         % ay
% Z(:,15) = data1(:,15);         % az
% Z(:,16) = data1(:,16);         % mu
% Z(:,17) = data1(:,17);         % chi
% Z(:,18) = data1(:,18);         % gamma

%% Input variables dre, dle, dra, dla, dr, dry, drz, dly, dlz, dlef, dsb, Tx, Ty, Tz, qbar, N, f
Uinp = [data2(:,1) data2(:,2) data2(:,3) data2(:,4) data2(:,5) ...
        deg2rad(data2(:,6)) deg2rad(data2(:,7)) deg2rad(data2(:,8)) deg2rad(data2(:,9)) data2(:,10) ...
        data2(:,11) data2(:,12) data2(:,13) data2(:,14) data2(:,15) ...
        data2(:,16) data2(:,17)];
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

%% Initial starting values for unknown parameters (aerodynamic derivatives)
% Cl, dCl_beta, Cl_delta_ail, Cl_delta_ail_lef, Cl_delta_r,
% Cl_elevator0, Cl_lef, Cl_p, dCl_p_lef, Cl_r,
% dCl_r_lef 
% Cm, dC_m, dCm_ds, dCm_ds_elevatorPdeci, dCm_ds_elevatorNdeci,
% Cm_elevator0, Cm_elevatorPdeci, Cm_elevatorNdeci, Cm_lef, Cm_q,
% dCm_q_lef, dCm_sb, eta_elevator, eta_elevatorPdeci, eta_elevatorNdeci
% Cn, dCn_beta, Cn_delta_ail, Cn_delta_ail_lef, Cn_delta_r,
% Cn_elevator0, Cn_lef, Cn_p, dCn_p_lef, Cn_r,
% dCn_r_lef
% CX, CX_elevatorPdeci, CX_elevatorNdeci, CX_elevator0, CX_lef,
% CX_q, CX_q_lef, dCX_sb
% CY, dCY_delta_ail, CY_delta_ail_lef, CY_delta_r, CY_lef, 
% CY_p, dCY_p_lef, CY_r, dCY_r_lef
% CZ, CZ_elevator0, CZ_elevatorPdeci, CZ_elevatorNdeci, CZ_lef, 
% CZ_q, dCZ_q_lef, dCZ_sb
% f11, f22, f33, f44, f55, f66, f77, f88, f99, f1010, f1111, f1212                      % 因為狀態有12個，所以要有12個!?
% 注意：param亂給的話會導致FEM法無法收斂。
% 建議：使用風洞測試數據或者跑CFD模擬先去估測param的大小，再用FEM法去驗證這些氣動力參數是否正確。
param = [ % 11個 Cl
          -0.000012; 0.00000337; -0.00412; -0.00422; 0.0211; 
          -0.0000229; -0.0000166; -0.6072; 0.02643; -0.1654;
          0.00689;
          % 15個 Cm (12個 Cm + 3個 eta_elevator)
          -0.01499; 0.0229; 0.00001; 0.00001; 0.00001;
          -0.0538; -0.00996; -0.0178; -0.00443; -7.0107;
          -0.1102; 0.0102; 1.0051; 0.0941; 1.0222;
          % 11個 Cn
          0.0000262; 0.000012; -0.00775; -0.00217; -0.0369;
          0.0000184; 0.0000088; -0.0260; 0.0600; -0.431;
          0.00911;
          % 08個 CX 
          0.0346; 0.0536; 0.0369; 0.0580; 0.0058; 
          3.0145; 0.0853; 0.0622;
          % 09個 CY
          0.0351; 0.0513; 0.0402; 0.0076; 0.0240; 
          0.0123; 0.0484; 0.8240; -0.1517;
          % 08個 CZ
          -0.489; -0.5338; -0.9100; -0.5691; -0.6111; 
          -33.0780; 0.0531; -0.510;
          % 12個狀態
          2e-2; 2e-2; 2e-2; 2e-2; 2e-2; 2e-2; 2e-2; 2e-2; 2e-2; 2e-2; 2e-2; 2e-2];
          % 隨機產生的64個數字 + 12個狀態      
      
 

%% Flags for free and fixed parameters = 1: free parameters (to be estimated) = 0: fixed parameters (not to be estimated)
parFlag = [ones(NCl,1); ones(NCm,1); ones(NCn,1); ones(NCX,1); ones(NCY,1); ones(NCZ,1); ones(12,1)];
       
%% Total number of free parameters
NparID = size(find(parFlag~=0),1); 

%% Initial conditions on state variables V, alpha, beta, phi, theta, psi, p, q, r, mu, chi, gamma
% 將 x0 設定成在 配平點/平衡點/初始飛行條件 的附近
% 注意：初始值X0若偏離正確值太多會使FEM法無法收斂。
% 建議：使用飛機上的感測器量測值
x0 = [ 323; deg2rad(10); 0.00000000001;
       0.00301; deg2rad(10); 0.000538;
       -0.0000003; 0.000000045; 0.000000001;
        0.0000014; 0.002; -0.00000035];

%% Initial R: Default (iSD=0) or specified as standard-deviations of output errors 
SDyError = [];
% SDyError = zeros(Ny,1);
% iSD = 1;
% SDyError = [.....]';     % if iSD=1, specify SD for Ny outputs
