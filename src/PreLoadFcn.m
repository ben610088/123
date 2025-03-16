% clc, clear
% 初始化參數請全部放在此 PreLoadFcn.m 檔
% 當開啟Simulink模型時，本檔案會被Simulink模型的PreLoadFcn載入，進行初始化

num_nozzles        = 2;             % 向量噴嘴的個數。可選：0, 1, 2 
numControlSurfaces = 9;             % 控制面的個數。可選：5, 7, 9
fcs.Ts             = 0.01;          % 飛控系統的取樣時間(秒) Sample time


Mode_deflection_aileron  = 1;       % 偏轉模式： 0=傳統左右副翼差動；        1=左右副翼獨立偏轉；     其它=左右副翼獨立偏轉
Mode_deflection_elevator = 1;       % 偏轉模式： 0=傳統左右升降舵同動；      1=左右升降舵獨立偏轉；    其它=左右升降舵獨立偏轉
Mode_deflection_rudder   = 1;       % 偏轉模式： 0=傳統左右方向舵差動；      1=左右方向舵獨立偏轉；       2=左右方向舵差動(產生減速效果)；   其它=左右方向舵獨立偏轉
Mode_deflection_TVC_z    = 1;       % 偏轉模式： 0=傳統左右向量噴嘴固定不動； 1=左右向量噴嘴左右獨立偏轉； 2=左右向量噴嘴左右同動；           其它=左右向量噴嘴左右獨立偏轉
Mode_deflection_TVC_y    = 1;       % 偏轉模式： 0=傳統左右向量噴嘴固定不動； 1=左右向量噴嘴上下獨立偏轉； 2=左右向量噴嘴上下同動；             3=左右向量噴嘴上下差動(產生滾轉)；   其它=左右向量噴嘴上下獨立偏轉



%   1    = 最大升力
%   2    = 最小雷達反射
%   3    = 最小向量推力
% other  = 最小阻力

ControlAllocation = 1;             % 控制配置(分配律) 的模式選擇
%   1       = Weighted Pseudo Inverse 加權偽逆法
%   2       = DAISY_CHIAN             串接鏈配置法
%   3       = CGI                     多級偽逆法
%   4       = DA                      直接幾何法
%   5       = controlmanagement2      管理方案二：基於期望力矩 (家維 論文第5.2節)
%   6       = controlmanagement3      管理方案三：廣義逆類配置法 (家維 論文第5.3節)
%   7       = LP_BasicSolutoion       線性規劃法基礎解 (家維 論文4.1節)
%   8       = LP_lift                 最大升力
%   9       = LP_thrustt              最小向量推力
%   10      = LP_def                  最小控制面偏轉量
%   11      = LP_sig                  最小雷達散射截面積
%   12      = 108、109年度學合案、2019張舜淵論文配置法
% otherwise = CGI                     多級偽逆法
% get_param('NDI_controller_f16_mu_alpha_beta_TVC_SB_mutics1_2/F-16 Vehicle Systems Model/pqr NDI Controller/TVC ON/Control Allocation/uu')


% FlightPhase = 'TVC2_h10000V617alpha2';                                      % 飛行模式，可選：'TakeOff'、'Landing'、'InAir'、'FallingLeaf'

fprintf('FlightPhase = ''%s''\n\n',FlightPhase);

hground = 0;                                % 預設值 0 ft, 地面的高度

%--------------------------------------------------------------------------
% 載入外部數據、程式碼
%--------------------------------------------------------------------------
run('F16_Aerodynamic_Coefficients.m')       % 氣動力係數表格
run('F16_Engine_Table.m')                   % 發動機推力表格

%  ToDo: 自動載入配平點(trim) 和 配平程式碼


%--------------------------------------------------------------------------
% 初始值 (t=0 時的配平點)    【若有修改的話，需要重新配平(trim)】
%--------------------------------------------------------------------------
% 若要在不同高度或是速度下飛行，需重新配平，以配平條件設定初始值  
switch FlightPhase 
    % 起飛
    case 'TakeOff'
        IC.npos  = 0;
        IC.epos  = 0;
        IC.alt   = -7;                        % 單位：ft
        IC.q0    = 1;
        IC.q1    = 0;
        IC.q2    = 0;
        IC.q3    = 0;
        IC.p     = 0;
        IC.q     = 0;
        IC.r     = 0;
        IC.alpha = deg2rad(0);                % 單位：rad
        IC.beta  = 0;
        IC.mu    = 0;
        IC.Vt    = 10;                        % 單位：ft/s ，初始值不能設成0，否則會產生除以0的計算問題。可用 IC.Vt = 10 ft/s 近似
        IC.chi   = 0;
        IC.gamma = 0;
        
        IC.thrust_lbf         = 15000;        % 單位：lbf
        IC.TVC_ry_deg         = 0;            % 單位：度
        IC.TVC_rz_deg         = 0;            % 單位：度
        IC.TVC_ly_deg         = 0;            % 單位：度
        IC.TVC_lz_deg         = 0;            % 單位：度
        IC.right_aileron_deg  = 0;            % 單位：度
        IC.left_aileron_deg   = 0;            % 單位：度
        IC.right_elevator_deg = 0;            % 單位：度
        IC.left_elevator_deg  = 0;            % 單位：度
        IC.rudder_deg         = 0;            % 單位：度
        IC.LEF_deg            = 0;            % 單位：度

    % 降落
    case 'Landing'
        IC.npos  = 0;
        IC.epos  = 0;
        IC.alt   = -1000;                     % 單位：ft
        IC.q0    = 0.9963;
        IC.q1    = 0;
        IC.q2    = 0.08597;
        IC.q3    = 0;
        IC.p     = 0;
        IC.q     = 0;
        IC.r     = 0;
        IC.alpha = deg2rad(9.8641);           % 單位：rad
        IC.beta  = 0;
        IC.mu    = 0;
        IC.Vt    = 287;                       % 單位：ft/s ，初始值不能設成0，否則會產生除以0的計算問題。可用 IC.Vt = 1 ft/s 近似
        IC.chi   = 0;
        IC.gamma = 0;

        IC.thrust_lbf         = 3000;         % 單位：lbf
        IC.TVC_ry_deg         = -2.4437;      % 單位：度。右向量噴嘴上下偏轉。注意，等同於 舜淵/宥瑋/庭宇論文和2020-12-31結案報告的 TVC_Z 
        IC.TVC_rz_deg         = -2.7203;      % 單位：度。右向量噴嘴左右偏轉。注意，等同於 舜淵/宥瑋/庭宇論文和2020-12-31結案報告的 TVC_Y 
        IC.TVC_ly_deg         = -2.4437;      % 單位：度。左向量噴嘴上下偏轉。注意，等同於 舜淵/宥瑋/庭宇論文和2020-12-31結案報告的 TVC_Z 
        IC.TVC_lz_deg         = -2.7203;      % 單位：度。左向量噴嘴左右偏轉。注意，等同於 舜淵/宥瑋/庭宇論文和2020-12-31結案報告的 TVC_Y 
        IC.right_aileron_deg  = -4.909;       % 單位：度
        IC.left_aileron_deg   = -4.909;       % 單位：度
        IC.right_elevator_deg = -9.0278;      % 單位：度
        IC.left_elevator_deg  = -9.0278;      % 單位：度
        IC.rudder_deg         = -2.5846;      % 單位：度
        IC.LEF_deg            = 25;           % 單位：度

    case 'FallingLeaf'
        IC.npos  = 0;
        IC.epos  = 0;
        IC.alt   = -15000;                    % 單位：ft
        IC.q0    = 1;
        IC.q1    = 0;
        IC.q2    = 0;
        IC.q3    = 0;
        IC.p     = 0;
        IC.q     = 0;
        IC.r     = 0;
        IC.alpha = deg2rad(7);                % 單位：rad
        IC.beta  = 0;
        IC.mu    = 0;
        IC.Vt    = 450;                       % 單位：ft/s ，初始值不能設成0，否則會產生除以0的計算問題。可用 IC.Vt = 1 ft/s 近似
        IC.chi   = 0;
        IC.gamma = 0;

        IC.thrust_lbf         = 5000;         % 單位：lbf
        IC.TVC_ry_deg         = 0;            % 單位：度
        IC.TVC_rz_deg         = 0;            % 單位：度
        IC.TVC_ly_deg         = 0;            % 單位：度
        IC.TVC_lz_deg         = 0;            % 單位：度
        IC.right_aileron_deg  = 0;            % 單位：度
        IC.left_aileron_deg   = 0;            % 單位：度
        IC.right_elevator_deg = 0;            % 單位：度
        IC.left_elevator_deg  = 0;            % 單位：度
        IC.rudder_deg         = 0;            % 單位：度
        IC.LEF_deg            = 0;            % 單位：度

    case 'TVC2_h10000V323alpha10_elevator5'
        IC.npos  = 0;
        IC.epos  = 0;
        IC.alt   = -10000;                     % 單位：ft
        IC.q0    = 0.9962;
        IC.q1    = 0;
        IC.q2    = 0.08716;
        IC.q3    = 0;
        IC.p     = 0;
        IC.q     = 0;
        IC.r     = 0;
        IC.alpha = 0.1745;                      % 單位：rad
        IC.beta  = -0.0019911;
        IC.mu    = -0.0028902;
        IC.Vt    = 323;                       % 單位：ft/s ，初始值不能設成0，否則會產生除以0的計算問題。可用 IC.Vt = 1 ft/s 近似
        IC.chi   = 0;
        IC.gamma = 0;

        IC.thrust_lbf         = 3432.615;      % 單位：lbf
        IC.TVC_ry_deg         = 0.9998;        % 單位：度
        IC.TVC_rz_deg         = 0;              % 單位：度
        IC.TVC_ly_deg         = 0.69985;        % 單位：度
        IC.TVC_lz_deg         = 0;              % 單位：度
        IC.right_aileron_deg  = 0;        % 單位：度
        IC.left_aileron_deg   = 0;      % 單位：度
        IC.right_elevator_deg = -1.9573;         % 單位：度
        IC.left_elevator_deg  = -2.4036;        % 單位：度
        IC.rudder_deg         = 0;      % 單位：度
        IC.LEF_deg            = 2.2204e-14;    % 單位：度





        
    case 'TVC2_h10000V323alpha10_elevator25'
        IC.npos  = 0;
        IC.epos  = 0;
        IC.alt   = -10000;                     % 單位：ft
        IC.q0    = 0.9962;
        IC.q1    = 0;
        IC.q2    = 0.08716;
        IC.q3    = 0;
        IC.p     = 0;
        IC.q     = 0;
        IC.r     = 0;
        IC.alpha = 0.1745;                      % 單位：rad
        IC.beta  = 0.0076458;
        IC.mu    = 0.015439;
        IC.Vt    = 323;                       % 單位：ft/s ，初始值不能設成0，否則會產生除以0的計算問題。可用 IC.Vt = 1 ft/s 近似
        IC.chi   = 0;
        IC.gamma = 0;

        IC.thrust_lbf         = 3464.9163;      % 單位：lbf
        IC.TVC_ry_deg         = 0.93863;        % 單位：度
        IC.TVC_rz_deg         = 0;              % 單位：度
        IC.TVC_ly_deg         = 0.93955;        % 單位：度
        IC.TVC_lz_deg         = 0;              % 單位：度
        IC.right_aileron_deg  = 0;        % 單位：度
        IC.left_aileron_deg   = 0;      % 單位：度
        IC.right_elevator_deg = -1.2132;         % 單位：度
        IC.left_elevator_deg  = 0.71472;        % 單位：度
        IC.rudder_deg         = 0;      % 單位：度
        IC.LEF_deg            = 2.2204e-14;    % 單位：度



        case 'TVC2_h10000V617alpha2'
        IC.npos  = 0;
        IC.epos  = 0;
        IC.alt   = -10000;                      % 單位：ft
        IC.q0    = 0.99982;
        IC.q1    = -2.0896e-14;
        IC.q2    = 0.016245;
        IC.q3    = -2.8348e-13;
        IC.p     = 0;
        IC.q     = 0;
        IC.r     = 0;
        IC.alpha = 0.032243;                     % 單位：rad
        IC.beta  = 0;
        IC.mu    = -0.0010871;
        IC.Vt    = 617;                         % 單位：ft/s ，初始值不能設成0，否則會產生除以0的計算問題。可用 IC.Vt = 1 ft/s 近似
        IC.chi   = 0;
        IC.gamma = 0;

        IC.thrust_lbf         = 2625;           % 單位：lbf
        IC.TVC_ry_deg         = -2.495e-05;     % 單位：度
        IC.TVC_rz_deg         = 0;              % 單位：度
        IC.TVC_ly_deg         = -2.495e-05;     % 單位：度
        IC.TVC_lz_deg         = 0;              % 單位：度
        IC.right_aileron_deg  = 0;              % 單位：度
        IC.left_aileron_deg   = 0;              % 單位：度
        IC.right_elevator_deg = -0.0042493;         % 單位：度
        IC.left_elevator_deg  = -0.0042493;         % 單位：度
        IC.rudder_deg         = 0;              % 單位：度
        IC.LEF_deg            = 0.00010411;     % 單位：度

        case 'TVC2_h10000V450alpha5'
        IC.npos  = 0;
        IC.epos  = 0;
        IC.alt   = -10000;                      % 單位：ft
        IC.q0    = 0.9991;
        IC.q1    = -0.00011688;
        IC.q2    = 0.043621;
        IC.q3    = -2.9915e-06;
        IC.p     = 0;
        IC.q     = 0;
        IC.r     = 0;
        IC.alpha = deg2rad(5);                  % 單位：rad
        IC.beta  = 0;
        IC.mu    = 0;
        IC.Vt    = 450;                         % 單位：ft/s ，初始值不能設成0，否則會產生除以0的計算問題。可用 IC.Vt = 1 ft/s 近似
        IC.chi   = 0;
        IC.gamma = 0;

        IC.thrust_lbf         = 2431;           % 單位：lbf
        IC.TVC_ry_deg         = 0;              % 單位：度
        IC.TVC_rz_deg         = 0;              % 單位：度
        IC.TVC_ly_deg         = 0;              % 單位：度
        IC.TVC_lz_deg         = 0;              % 單位：度
        IC.right_aileron_deg  = 0.34391;              % 單位：度
        IC.left_aileron_deg   = -0.34391;              % 單位：度
        IC.right_elevator_deg = -4.51;         % 單位：度
        IC.left_elevator_deg  = -4.51;         % 單位：度
        IC.rudder_deg         = 0.58353;              % 單位：度
        IC.LEF_deg            = 0;     % 單位：度


    % 其他 
    otherwise
        IC.npos  = 0;
        IC.epos  = 0;
        IC.alt   = -10000;                      % 單位：ft
        IC.q0    = 0.99992;
        IC.q1    = 3.5034e-10;
        IC.q2    = -0.013033;
        IC.q3    = 6.1521e-10;
        IC.p     = 0;
        IC.q     = 0;
        IC.r     = 0;
        IC.alpha = -0.026064;                  % 單位：rad
        IC.beta  = 0;
        IC.mu    = -0.0011499;
        IC.Vt    = 617;                         % 單位：ft/s ，初始值不能設成0，否則會產生除以0的計算問題。可用 IC.Vt = 1 ft/s 近似
        IC.chi   = 4.0062e-06;
        IC.gamma = 0;

        IC.thrust_lbf         = 2625;           % 單位：lbf
        IC.TVC_ry_deg         = -0.00085289;              % 單位：度
        IC.TVC_rz_deg         = 0;              % 單位：度
        IC.TVC_ly_deg         = -0.00085289;              % 單位：度
        IC.TVC_lz_deg         = 0;              % 單位：度
        IC.right_aileron_deg  = -0.020775;              % 單位：度
        IC.left_aileron_deg   = 0.020775;              % 單位：度
        IC.right_elevator_deg = -0.049079;         % 單位：度
        IC.left_elevator_deg  = -0.049079;         % 單位：度
        IC.rudder_deg         = 0;              % 單位：度
        IC.LEF_deg            = 0.00028147;     % 單位：度
        
end


disp('初始值 (t=0 時的配平點)：')
disp(IC)

% state0 用於設定 /Vehicle/6DOF (Quaternion)/Integrator 模塊
state0 = [IC.npos IC.epos IC.alt IC.q0 IC.q1 IC.q2 IC.q3  IC.p IC.q IC.r IC.alpha IC.beta IC.mu IC.Vt IC.chi IC.gamma];


%--------------------------------------------------------------------------
% 飛機參數   【若有修改的話，需要重新配平(trim)】
%--------------------------------------------------------------------------
% ac 是 aircraft 的縮寫
ac.name     = 'F-16 A/B';       % 飛機名稱
ac.S        = 300;              % 預設值 300 ft^2, 主翼面積 planform area
ac.b        = 30;               % 預設值 30 ft, 主翼翼展 span
ac.cbar     = 11.32;            % 預設值 11.32 ft, 平均弦長 mean aero chord
ac.x_cg_ref = 0.35;             % 預設值 0.35, reference center of gravity as a fraction of cbar
ac.x_cg     = 0.30;             % 預設值 0.30, center of gravity as a fraction of cbar.
% ac.x_cg_ref = 0.35 * ac.cbar; % 預設值 0.35*ac.cbar, reference center of gravity as a fraction of cbar
% ac.x_cg     = 0.30 * ac.cbar; % 預設值 0.30*ac.cbar, center of gravity as a fraction of cbar
ac.lt       = 15.552;           % 預設值 15.552 ft, 右向量噴嘴旋轉中心點(推力中心點)與飛機重心的x軸方向距離 Engine nozzle after of c.g.
ac.lt1      = 15.552;           % 預設值 15.552 ft, 左向量噴嘴旋轉中心點(推力中心點)與飛機重心的x軸方向距離 Engine nozzle after of c.g.
ac.mt       = 1.72;             % 預設值 15.552 ft, 右(左)向量噴嘴旋轉中心點(推力中心點)與飛機重心的y軸方向距離 Engine nozzle after of c.g.
ac.num_nozzles = num_nozzles; 

switch FlightPhase
    case 'TakeOff'
        ac.m        =   587.5;         % 空載   587.5 slugs  , mass
        ac.Ix       =  8759.1;         % 空載  8759.1 slug*ft^2
        ac.Iy       = 51483.0;         % 空載 51483 slug*ft^2
        ac.Iz       = 58203.0;         % 空載 58203 slug*ft^2
        ac.Ixy      =     0;           % 空載     0 slug*ft^2
        ac.Ixz      =   905.8;         % 空載   905.8 slug*ft^2
        ac.Iyz      =     0;           % 空載     0 slug*ft^2
        ac.Heng     =     0;           % 空載     0 slug*ft^2，turbine momentum along roll axis  (文獻記載：假設是固定值 160 slug*ft^2)
               
%         ac.m        =   951.1;         % 半載   951.1 slugs  , mass
%         ac.Ix       =   14180;         % 半載   14180 slug*ft^2
%         ac.Iy       =   83346;         % 半載   83346 slug*ft^2
%         ac.Iz       =   94225;         % 半載   94225 slug*ft^2
%         ac.Ixy      =       0;         % 半載       0 slug*ft^2
%         ac.Ixz      =  1466.4;         % 半載  1466.4 slug*ft^2
%         ac.Iyz      =       0;         % 半載       0 slug*ft^2
%         ac.Heng     =       0;         % 半載       0 slug*ft^2，turbine momentum along roll axis  (文獻記載：假設是固定值 160 slug*ft^2)
         
%         ac.m        =  1314.7;         % 滿載  1314.7 slugs  , mass
%         ac.Ix       =   19601;         % 滿載   19601 slug*ft^2
%         ac.Iy       =  115210;         % 滿載  115210 slug*ft^2
%         ac.Iz       =  130250;         % 滿載  130250 slug*ft^2
%         ac.Ixy      =       0;         % 滿載       0 slug*ft^2
%         ac.Ixz      =    2027;         % 滿載    2027 slug*ft^2
%         ac.Iyz      =       0;         % 滿載       0 slug*ft^2
%         ac.Heng     =       0;         % 滿載       0 slug*ft^2，turbine momentum along roll axis  (文獻記載：假設是固定值 160 slug*ft^2)
        
%         ac.m        =   823.6;         % 正常起飛重量   823.6 slugs  , mass
%         ac.Ix       =   12279;         % 正常起飛重量   12279 slug*ft^2
%         ac.Iy       =   72174;         % 正常起飛重量   72174 slug*ft^2
%         ac.Iz       =   81595;         % 正常起飛重量   81595 slug*ft^2
%         ac.Ixy      =       0;         % 正常起飛重量       0 slug*ft^2
%         ac.Ixz      =  1269.8;         % 正常起飛重量  1269.8 slug*ft^2
%         ac.Iyz      =       0;         % 正常起飛重量       0 slug*ft^2
%         ac.Heng     =       0;         % 正常起飛重量       0 slug*ft^2，turbine momentum along roll axis  (文獻記載：假設是固定值 160 slug*ft^2)

    case 'Landing'
        ac.m        =   636.94;        % 預設值   636.94 slugs  , mass
        ac.Ix       =  9496;           % 預設值  9496 slug*ft^2
        ac.Iy       = 55814.0;         % 預設值 55814 slug*ft^2
        ac.Iz       = 63100.0;         % 預設值 63100 slug*ft^2
        ac.Ixy      =     0;           % 預設值     0 slug*ft^2
        ac.Ixz      =   982;           % 預設值   982 slug*ft^2
        ac.Iyz      =     0;           % 預設值     0 slug*ft^2
        ac.Heng     =     0;           % 預設值     0 slug*ft^2，turbine momentum along roll axis  (文獻記載：假設是固定值 160 slug*ft^2)
        
%         ac.m        =   587.5;         % 空載   587.5 slugs  , mass
%         ac.Ix       =  8759.1;         % 空載  8759.1 slug*ft^2
%         ac.Iy       =   51483;         % 空載   51483 slug*ft^2
%         ac.Iz       =   58203;         % 空載   58203 slug*ft^2
%         ac.Ixy      =       0;         % 空載       0 slug*ft^2
%         ac.Ixz      =   905.8;         % 空載   905.8 slug*ft^2
%         ac.Iyz      =       0;         % 空載       0 slug*ft^2
%         ac.Heng     =       0;         % 空載       0 slug*ft^2，turbine momentum along roll axis  (文獻記載：假設是固定值 160 slug*ft^2)

    otherwise
        ac.m        =   636.94;        % 預設值   636.94 slugs  , mass
        ac.Ix       =  9496;           % 預設值  9496 slug*ft^2
        ac.Iy       = 55814.0;         % 預設值 55814 slug*ft^2
        ac.Iz       = 63100.0;         % 預設值 63100 slug*ft^2
        ac.Ixy      =     0;           % 預設值     0 slug*ft^2
        ac.Ixz      =   982;           % 預設值   982 slug*ft^2
        ac.Iyz      =     0;           % 預設值     0 slug*ft^2
        ac.Heng     =     0;           % 預設值     0 slug*ft^2，turbine momentum along roll axis  (文獻記載：假設是固定值 160 slug*ft^2)
end
ac.f_mu     =   0.5;                   % 摩擦係數

%--------------------------------------------------------------------------
g           = [ 0  0  32.17 ];         % 預設值 [ 0  0  32.17 ] ft/s^2, 重力加速度 gravity

%--------------------------------------------------------------------------
% 致動器
%--------------------------------------------------------------------------
Aactuator.right_aileron.AngleLimitUpper    =  21.5;            % 預設值  21.5度
Aactuator.right_aileron.AngleLimitLower    = -21.5;            % 預設值 -21.5度
Aactuator.right_aileron.RateLimitUpper     =  80;              % 預設值  80度/秒
Aactuator.right_aileron.RateLimitLower     = -80;              % 預設值 -80度/秒
Aactuator.right_aileron.IntegratorInitial  = IC.right_aileron_deg;

Aactuator.left_aileron.AngleLimitUpper    =  21.5;            % 預設值  21.5度
Aactuator.left_aileron.AngleLimitLower    = -21.5;            % 預設值 -21.5度
Aactuator.left_aileron.RateLimitUpper     =  80;              % 預設值  80度/秒
Aactuator.left_aileron.RateLimitLower     = -80;              % 預設值 -80度/秒
Aactuator.left_aileron.IntegratorInitial  = IC.left_aileron_deg;

Aactuator.right_elevator.AngleLimitUpper   =  25;              % 預設值  25度
Aactuator.right_elevator.AngleLimitLower   = -25;              % 預設值 -25度
Aactuator.right_elevator.RateLimitUpper    =  60;              % 預設值  60度/秒
Aactuator.right_elevator.RateLimitLower    = -60;              % 預設值 -60度/秒
Aactuator.right_elevator.IntegratorInitial = IC.right_elevator_deg;

Aactuator.left_elevator.AngleLimitUpper   =  25;              % 預設值  25度
Aactuator.left_elevator.AngleLimitLower   = -25;              % 預設值 -25度
Aactuator.left_elevator.RateLimitUpper    =  60;              % 預設值  60度/秒
Aactuator.left_elevator.RateLimitLower    = -60;              % 預設值 -60度/秒
Aactuator.left_elevator.IntegratorInitial = IC.left_elevator_deg;

Aactuator.rudder.AngleLimitUpper     =  30;              % 預設值  30度
Aactuator.rudder.AngleLimitLower     = -30;              % 預設值 -30度
Aactuator.rudder.RateLimitUpper      =  120;             % 預設值 120度/秒
Aactuator.rudder.RateLimitLower      = -120;             % 預設值-120度/秒
Aactuator.rudder.IntegratorInitial   = IC.rudder_deg;

% /Vehicle/Aerodynamics/Leading Edge Flap模塊
% /Aerodynamic1模塊裡
% /Aerodynamic2模塊裡
Aactuator.LEF.AngleLimitUpper        =  25;              % 預設值  25度
Aactuator.LEF.AngleLimitLower        =  0;               % 預設值   0度
Aactuator.LEF.RateLimitUpper         =  25;              % 預設值  25度/秒
Aactuator.LEF.RateLimitLower         = -25;              % 預設值 -25度/秒
Aactuator.LEF.IntegratorInitial      = IC.LEF_deg;

% /Vehicle/Aerodynamics/Leading Edge Flap模塊
% /Aerodynamic1模塊裡
% /Aerodynamic2模塊裡
% Aactuator.left_LEF.AngleLimitUpper        =  25;              % 預設值  25度
% Aactuator.left_LEF.AngleLimitLower        =  0;               % 預設值   0度
% Aactuator.left_LEF.RateLimitUpper         =  25;              % 預設值  25度/秒
% Aactuator.left_LEF.RateLimitLower         = -25;              % 預設值 -25度/秒
% Aactuator.left_LEF.IntegratorInitial      = IC.left_LEF_deg;

Aactuator.TVC_rz.AngleLimitUpper      =  15;              % 預設值  15度
Aactuator.TVC_rz.AngleLimitLower      = -15;              % 預設值 -15度
Aactuator.TVC_rz.RateLimitUpper       =  60;              % 預設值  60度/秒
Aactuator.TVC_rz.RateLimitLower       = -60;              % 預設值 -60度/秒
Aactuator.TVC_rz.IntegratorInitial    = IC.TVC_rz_deg;

Aactuator.TVC_ry.AngleLimitUpper      =  15;              % 預設值  15度
Aactuator.TVC_ry.AngleLimitLower      = -15;              % 預設值 -15度
Aactuator.TVC_ry.RateLimitUpper       =  60;              % 預設值  60度/秒
Aactuator.TVC_ry.RateLimitLower       = -60;              % 預設值 -60度/秒
Aactuator.TVC_ry.IntegratorInitial    = IC.TVC_ry_deg;

Aactuator.TVC_lz.AngleLimitUpper      =  15;              % 預設值  15度
Aactuator.TVC_lz.AngleLimitLower      = -15;              % 預設值 -15度
Aactuator.TVC_lz.RateLimitUpper       =  60;              % 預設值  60度/秒
Aactuator.TVC_lz.RateLimitLower       = -60;              % 預設值 -60度/秒
Aactuator.TVC_lz.IntegratorInitial    = IC.TVC_lz_deg;

Aactuator.TVC_ly.AngleLimitUpper      =  15;              % 預設值  15度
Aactuator.TVC_ly.AngleLimitLower      = -15;              % 預設值 -15度
Aactuator.TVC_ly.RateLimitUpper       =  60;              % 預設值  60度/秒
Aactuator.TVC_ly.RateLimitLower       = -60;              % 預設值 -60度/秒
Aactuator.TVC_ly.IntegratorInitial    = IC.TVC_ly_deg;




%--------------舊的，即將刪除-----------------------------------------------
Aactuator.elevator.AngleLimitUpper   =  25;              % 預設值  25度
Aactuator.elevator.AngleLimitLower   = -25;              % 預設值 -25度
Aactuator.elevator.RateLimitUpper    =  60;              % 預設值  60度/秒
Aactuator.elevator.RateLimitLower    = -60;              % 預設值 -60度/秒
Aactuator.elevator.IntegratorInitial = IC.right_elevator_deg;

Aactuator.aileron.AngleLimitUpper    =  21.5;            % 預設值  21.5度
Aactuator.aileron.AngleLimitLower    = -21.5;            % 預設值 -21.5度
Aactuator.aileron.RateLimitUpper     =  80;              % 預設值  80度/秒
Aactuator.aileron.RateLimitLower     = -80;              % 預設值 -80度/秒
Aactuator.aileron.IntegratorInitial  = IC.right_aileron_deg;

Aactuator.rudder.AngleLimitUpper     =  30;              % 預設值  30度
Aactuator.rudder.AngleLimitLower     = -30;              % 預設值 -30度
Aactuator.rudder.RateLimitUpper      =  120;             % 預設值 120度/秒
Aactuator.rudder.RateLimitLower      = -120;             % 預設值-120度/秒
Aactuator.rudder.IntegratorInitial   = IC.rudder_deg;

% /Vehicle/Aerodynamics/Leading Edge Flap模塊
% /Aerodynamic1模塊裡
% /Aerodynamic2模塊裡
Aactuator.LEF.AngleLimitUpper        =  25;              % 預設值  25度
Aactuator.LEF.AngleLimitLower        =  0;               % 預設值   0度
Aactuator.LEF.RateLimitUpper         =  25;              % 預設值  25度/秒
Aactuator.LEF.RateLimitLower         = -25;              % 預設值 -25度/秒
Aactuator.LEF.IntegratorInitial      = IC.LEF_deg;

Aactuator.TVC_Z.AngleLimitUpper      =  15;              % 預設值  15度
Aactuator.TVC_Z.AngleLimitLower      = -15;              % 預設值 -15度
Aactuator.TVC_Z.RateLimitUpper       =  60;              % 預設值  60度/秒
Aactuator.TVC_Z.RateLimitLower       = -60;              % 預設值 -60度/秒
Aactuator.TVC_Z.IntegratorInitial    = IC.TVC_rz_deg;

Aactuator.TVC_Y.AngleLimitUpper      =  15;              % 預設值  15度
Aactuator.TVC_Y.AngleLimitLower      = -15;              % 預設值 -15度
Aactuator.TVC_Y.RateLimitUpper       =  60;              % 預設值  60度/秒
Aactuator.TVC_Y.RateLimitLower       = -60;              % 預設值 -60度/秒
Aactuator.TVC_Y.IntegratorInitial    = IC.TVC_ry_deg;
%--------------------------------------------------------------------------
% 起落架
%--------------------------------------------------------------------------
LandingGear.LM.CmprsRangeLimitUpper  = 2;                % 預設值  2ft
LandingGear.LM.CmprsRangeLimitLower  = 0;                % 預設值  0ft
LandingGear.LM.SpringConstant        = 1e4;              % 預設值  1e4 N/m
LandingGear.LM.DampingConstant       = 1e6;              % 預設值  1e6 N/m/sec
LandingGear.LM.FrictionCoefficient   = 0.1;              % 預設值  0.5

LandingGear.RM.CmprsRangeLimitUpper  = 2;                % 預設值  2ft
LandingGear.RM.CmprsRangeLimitLower  = 0;                % 預設值  0ft
LandingGear.RM.SpringConstant        = 1e4;              % 預設值  1e4 N/m
LandingGear.RM.DampingConstant       = 1e6;              % 預設值  1e6 N/m/sec
LandingGear.RM.FrictionCoefficient   = 0.1;              % 預設值  0.5

LandingGear.Nose.CmprsRangeLimitUpper  = 2;              % 預設值  2ft
LandingGear.Nose.CmprsRangeLimitLower  = 0;              % 預設值  0ft
LandingGear.Nose.SpringConstant        = 1e4;            % 預設值  1e4 N/m
LandingGear.Nose.DampingConstant       = 1e6;            % 預設值  1e6 N/m/sec
LandingGear.Nose.FrictionCoefficient   = 0.1;            % 預設值  0.5
    
%--------------------------------------------------------------------------
% PI控制器
%--------------------------------------------------------------------------
switch FlightPhase
    case 'TakeOff'
        PIController.y.P    = 0.5;       % 起飛建議值 0.5
        PIController.y.I    = 0.1;       % 起飛建議值 0.1
    case 'Landing'
        PIController.y.P    = 0.25;      % 降落建議值 0.25
        PIController.y.I    = 0.05;      % 降落建議值 0.05
    otherwise
        PIController.y.P    = 0.25;      % 建議值 0.25
        PIController.y.I    = 0.05;      % 建議值 0.05

end

PIController.z.P    = 0.5;               % 建議值 0.5
PIController.z.I    = 0.1;               % 建議值 0.1

PIController.Vt.P    = 1;                % 建議值 1
PIController.Vt.I    = 0.2;              % 建議值 0.2

switch FlightPhase
    case 'TakeOff'
        PIController.chi.P   = 0.5;      % 起飛建議值 0.5   
        PIController.chi.I   = 0.1;      % 起飛建議值 0.1 
    case 'Landing'
        PIController.chi.P   = 0.5;      % 降落建議值 0.5   
        PIController.chi.I   = 0.1;      % 降落建議值 0.1 
    otherwise
        PIController.chi.P   = 1;        % 建議值 1   
        PIController.chi.I   = 0.2;      % 建議值 0.2 
end

PIController.gamma.P = 1;                % 建議值 1
PIController.gamma.I = 0.2;              % 建議值 0.2

PIController.mu.P    = 2;                % 建議值 2
PIController.mu.I    = 1;                % 建議值 1

PIController.alpha.P = 2;                % 建議值 2
PIController.alpha.I = 1;                % 建議值 1

PIController.beta.P  = 2;                % 建議值 2
PIController.beta.I  = 1;                % 建議值 1

PIController.p.P     = 10;               % 建議值 10
PIController.p.I     = 4;                % 建議值 4

PIController.q.P     = 10;               % 建議值 10
PIController.q.I     = 4;                % 建議值 4

PIController.r.P     = 10;               % 建議值 10
PIController.r.I     = 4;                % 建議值 4

%--------------------------------------------------------------------------
% NDI控制器之控制配置(control allocation)的權重矩陣N
%--------------------------------------------------------------------------
%  /pqr NDI Controller/TVC ON/weighting matrix N 模塊

% 前提：向量噴嘴控制ON 才有作用。 也就是 /pqr NDI Controller模塊 要設定成 "TVC ON"

%---------------------
% 菊鍊式(mix) (2019舜淵論文、2019~2020學合案)
%---------------------
% 
%      滾轉p  俯仰q  偏航r
%       ↓     ↓     ↓
% N = [ 1      0     0.25;    ← 副翼
%       0      1     0   ;    ← 升降舵
%       0.25   0     1   ;    ← 方向舵
%       0.25   0     0.5 ;    ← 向量噴嘴左右偏轉(yaw)   TVC_Y
%       0      0.5   0    ];  ← 向量噴嘴上下偏轉(pitch) TVC_Z

%---------------------
% 聯動式  (2019舜淵論文、2019~2020學合案)
%---------------------
% 降落且減速板開40度時的建議值：
% 
%      滾轉p  俯仰q  偏航r
%       ↓     ↓     ↓
% N = [ 1      0     0.25;    ← 副翼
%       0      1     0   ;    ← 升降舵
%       0.25   0     1   ;    ← 方向舵
%       0.25   0     0.5 ;    ← 向量噴嘴左右偏轉(yaw)   TVC_Y
%       0      5.5   0    ];  ← 向量噴嘴上下偏轉(pitch) TVC_Z
% 起飛
switch FlightPhase
    case 'TakeOff'
        N = [ 1      0     0.25;
              0      1     0;
              0.25   0     1;
              0.25   0     0.5;
              0      4     0    ];
% 降落
    case 'Landing'
%         N = [ 1      0     0.25;
%               0      1     0;
%               0.25   0     1;
%               0.25   0     0.5;
%               0      5.5   0    ];
%       ControlAllocation = 10 舜淵論文配置法專用
%           滾轉p  俯仰q  偏航r
%            ↓     ↓     ↓
        N = [ 1      0     0.25;        % ← 右副翼   
              1      0     0.25;        % ← 左副翼 
              0      1     0;           % ← 右升降舵
              0      1     0;           % ← 左升降舵
              0.25   0     1;           % ← 方向舵
              0      5.5   0;           % ← 右向量噴嘴上下偏轉(pitch) TVC_rY ，注意：跟舜淵/宥瑋/庭宇論文和2020-12-31結案報告的 TVC_Y 與 TVC_Z 定義相反，所以順序要顛倒
              0.25   0     0.5;     	% ← 右向量噴嘴左右偏轉(yaw)   TVC_rZ
              0      5.5   0;           % ← 左向量噴嘴上下偏轉(pitch) TVC_lY
              0.25   0     0.5     ];   % ← 左向量噴嘴左右偏轉(yaw)   TVC_lZ

%              右副翼       左副翼      右升降舵  左升降舵    方向舵    TVC_rY      TVC_rZ     TVC_lY      TVC_lZ
%                ↓            ↓          ↓         ↓         ↓         ↓           ↓          ↓           ↓
% Ninv = inv([    1/21.5      0          0         0     0.125/30      0      0.125/15        0      0.125/15 ;     % ← 右副翼
%                 0           1/21.5     0         0     0.125/30      0      0.125/15        0      0.125/15 ;     % ← 左副翼 
%                 0           0          1/25      0         0       2.75/15       0      2.75/15         0   ;     % ← 右升降舵
%                 0           0          0      1/25         0       2.75/15       0      2.75/15         0   ;     % ← 左升降舵
%              0.25/21.5   0.25/21.5     0         0         1/30      0        0.5/15        0        0.5/15 ;     % ← 方向舵
%                 0           0          0         0         0         1/15        0          0           0   ;     % ← 右向量噴嘴上下偏轉(pitch) TVC_rY
%                 0           0          0         0         0         0          1/15        0           0   ;     % ← 右向量噴嘴左右偏轉(yaw)   TVC_rZ
%                 0           0          0         0         0         0           0         1/15         0   ;     % ← 左向量噴嘴上下偏轉(pitch) TVC_lY
%                 0           0          0         0         0         0           0          0          1/15 ]);   % ← 左向量噴嘴左右偏轉(yaw)   TVC_lZ
          
%              右副翼   左副翼  右升降舵  左升降舵  方向舵  TVC_rY  TVC_rZ  TVC_lY  TVC_lZ
%                ↓      ↓       ↓        ↓       ↓      ↓      ↓      ↓     ↓
% Ninv = inv([ 1/21.5    0        0         0        0       0       0       0      0;      ← 右副翼
%                0     1/21.5     0         0        0       0       0       0      0;      ← 左副翼 
%                0       0       1/25       0        0       0       0       0      0;      ← 右升降舵
%                0       0        0        1/25      0       0       0       0      0;      ← 左升降舵
%                0       0        0         0       1/30     0       0       0      0;      ← 方向舵
%                0       0        0         0        0      1/15     0       0      0;      ← 右向量噴嘴上下偏轉(pitch)   TVC_rY
%                0       0        0         0        0       0      1/15     0      0;      ← 右向量噴嘴左右偏轉(yaw)     TVC_rZ
%                0       0        0         0        0       0       0      1/15    0;      ← 左向量噴嘴上下偏轉(pitch)   TVC_lY
%                0       0        0         0        0       0       0       0    1/15]);   ← 左向量噴嘴左右偏轉(yaw)     TVC_lZ
          
          
%         N1 = [ 1      0     0.25;
%                0      1     0;
%                0.25   0     1;
%                0.25   0     0.5;
%                0      0.6   0    ];
%           
%         N2 = [ 1      0     0.25;
%                0      1     0;
%                0.25   0     1;
%                0.25   0     0.5;
%                0      4     0    ];


                 
% 其他
    otherwise
%       ControlAllocation = 10 舜淵論文配置法專用
%           滾轉p  俯仰q  偏航r
%            ↓     ↓     ↓
        N = [ 1      0     0.25;        % ← 右副翼   
              1      0     0.25;        % ← 左副翼 
              0      1     0;           % ← 右升降舵
              0      1     0;           % ← 左升降舵
              0.25   0     1;           % ← 方向舵
              0      5.5   0;           % ← 右向量噴嘴上下偏轉(pitch) TVC_rY ，注意：勁豪跟庭宇的 TVC_Y 與 TVC_Z 定義相反，所以順序要顛倒
              0.25   0     0.5;     	% ← 右向量噴嘴左右偏轉(yaw)   TVC_rZ
              0      5.5   0;           % ← 左向量噴嘴上下偏轉(pitch) TVC_lY
              0.25   0     0.5     ];   % ← 左向量噴嘴左右偏轉(yaw)   TVC_lZ
end


switch numControlSurfaces
    case 5
        Ninv = inv(diag([ 1/21.5  1/25  1/30  1/15  1/15 ]));
    case 7
        Ninv = inv(diag(([ 1/21.5  1/21.5  1/25  1/25  1/30  1/15  1/15 ])));
    case 9
        Ninv_2nozzle   = inv(diag([  1/21.5  1/21.5  1/25  1/25  1/30  1/15  1/15  1/15  1/15 ]));
        Ninv_no_nozzle =     diag([    21.5    21.5    25    25    30    0     0     0     0  ]);
    otherwise
        disp('錯誤：PreLoadFcn.m 的 numControlSurfaces 設定錯誤，控制面的個數。可選：5, 7, 9')
end

%--------------------------------------------------------------------------
% 控制配置所需的控制面偏轉限制   單位(度)
%--------------------------------------------------------------------------
Umax2 = [Aactuator.aileron.AngleLimitUpper  Aactuator.elevator.AngleLimitUpper  Aactuator.rudder.AngleLimitUpper...
         Aactuator.TVC_Y.AngleLimitUpper    Aactuator.TVC_Z.AngleLimitUpper];
Umin2 = [Aactuator.aileron.AngleLimitLower  Aactuator.elevator.AngleLimitLower  Aactuator.rudder.AngleLimitLower...
         Aactuator.TVC_Y.AngleLimitLower    Aactuator.TVC_Z.AngleLimitLower];
Umax1 = [Aactuator.right_aileron.AngleLimitUpper  Aactuator.left_aileron.AngleLimitUpper  Aactuator.right_elevator.AngleLimitUpper Aactuator.left_elevator.AngleLimitUpper  Aactuator.rudder.AngleLimitUpper...
         Aactuator.TVC_Y.AngleLimitUpper    Aactuator.TVC_Z.AngleLimitUpper];
Umin1 = [Aactuator.right_aileron.AngleLimitLower  Aactuator.left_aileron.AngleLimitLower  Aactuator.right_elevator.AngleLimitLower Aactuator.left_elevator.AngleLimitLower  Aactuator.rudder.AngleLimitLower...
         Aactuator.TVC_Y.AngleLimitLower    Aactuator.TVC_Z.AngleLimitLower];
Umax_2nozzle  = [Aactuator.right_aileron.AngleLimitUpper  Aactuator.left_aileron.AngleLimitUpper  Aactuator.right_elevator.AngleLimitUpper Aactuator.left_elevator.AngleLimitUpper  Aactuator.rudder.AngleLimitUpper...
                 Aactuator.TVC_ry.AngleLimitUpper    Aactuator.TVC_rz.AngleLimitUpper  Aactuator.TVC_ly.AngleLimitUpper    Aactuator.TVC_lz.AngleLimitUpper];
Umin_2nozzle  = [Aactuator.aileron.AngleLimitLower  Aactuator.aileron.AngleLimitLower  Aactuator.elevator.AngleLimitLower Aactuator.elevator.AngleLimitLower  Aactuator.rudder.AngleLimitLower...
                 Aactuator.TVC_ry.AngleLimitLower    Aactuator.TVC_rz.AngleLimitLower Aactuator.TVC_ly.AngleLimitLower    Aactuator.TVC_lz.AngleLimitLower];
Umax_no_nozzle  = [Aactuator.right_aileron.AngleLimitUpper  Aactuator.left_aileron.AngleLimitUpper  Aactuator.right_elevator.AngleLimitUpper Aactuator.left_elevator.AngleLimitUpper  Aactuator.rudder.AngleLimitUpper...
                   0 0 0 0];
Umin_no_nozzle =  [Aactuator.right_aileron.AngleLimitLower  Aactuator.left_aileron.AngleLimitLower  Aactuator.right_elevator.AngleLimitLower Aactuator.left_elevator.AngleLimitLower  Aactuator.rudder.AngleLimitLower...
                   0 0 0 0];
%--------------------------------------------------------------------------
% 控制配置所需的控制面偏轉速率限制   單位(度/秒)
%--------------------------------------------------------------------------

DUmax2 = [Aactuator.aileron.RateLimitUpper Aactuator.elevator.RateLimitUpper  Aactuator.rudder.RateLimitUpper...
          Aactuator.TVC_Y.RateLimitUpper    Aactuator.TVC_Z.RateLimitUpper];
DUmin2 = [Aactuator.aileron.RateLimitLower  Aactuator.elevator.RateLimitLower  Aactuator.rudder.RateLimitLower...
          Aactuator.TVC_Y.RateLimitLower    Aactuator.TVC_Z.RateLimitLower];
DUmax1 = [Aactuator.right_aileron.RateLimitUpper Aactuator.left_aileron.RateLimitUpper  Aactuator.right_elevator.RateLimitUpper Aactuator.left_elevator.RateLimitUpper  Aactuator.rudder.RateLimitUpper...
          Aactuator.TVC_Y.RateLimitUpper    Aactuator.TVC_Z.RateLimitUpper];
DUmin1 = [Aactuator.right_aileron.RateLimitLower Aactuator.left_aileron.RateLimitLower  Aactuator.right_elevator.RateLimitLower Aactuator.left_elevator.RateLimitLower  Aactuator.rudder.RateLimitLower...
          Aactuator.TVC_Y.RateLimitLower    Aactuator.TVC_Z.RateLimitLower];
DUmax =  [Aactuator.right_aileron.RateLimitUpper Aactuator.left_aileron.RateLimitUpper  Aactuator.right_elevator.RateLimitUpper Aactuator.left_elevator.RateLimitUpper  Aactuator.rudder.RateLimitUpper...
          Aactuator.TVC_ry.RateLimitUpper   Aactuator.TVC_rz.RateLimitUpper  Aactuator.TVC_ly.RateLimitUpper    Aactuator.TVC_rz.RateLimitUpper];
DUmin =  [Aactuator.right_aileron.RateLimitLower Aactuator.left_aileron.RateLimitLower  Aactuator.right_elevator.RateLimitLower Aactuator.left_elevator.RateLimitLower  Aactuator.rudder.RateLimitLower...
          Aactuator.TVC_ry.RateLimitLower   Aactuator.TVC_rz.RateLimitLower  Aactuator.TVC_ly.RateLimitLower    Aactuator.TVC_rz.RateLimitLower];
 
      
%% 系統識別 (System Identification)
% 系統識別用的資料擷取系統 (sysID_DAQ)
sysID_DAQ.sampleTime                        = 0.1;         % 預設值 0.1 秒，資料擷取系統

% 系統識別用的機載激勵訊號系統 (sysID_Onboard_Excitation_System, sysID_OBES)
sysID_OBES.Ts                               = 0.01;         % sysID_OBES 的取樣時間(秒)

sysID_OBES.waveName                         = 'Orthogonal_Multisine';    % 激勵訊號的波形名稱，可選：'doublet'、'Orthogonal_Multisine'、...

sysID_OBES.start_time                       = 20;           % 預設值 第 40 秒觸發 sysID_Onboard_Excitation_System 
sysID_OBES.isEnable                         = 1;            % 預設值 1， 總開關，是否要進行系統識別實驗。1 = 開啟，0 = 關閉
sysID_OBES.TVC_ry.isTurnOn                  = 1;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.TVC_rz.isTurnOn                  = 1;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.TVC_ly.isTurnOn                  = 1;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.TVC_lz.isTurnOn                  = 1;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.right_aileron.isTurnOn           = 1;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.left_aileron.isTurnOn            = 1;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.right_elevator.isTurnOn          = 1;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.left_elevator.isTurnOn           = 1;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.rudder.isTurnOn                  = 1;            % 預設值 1。 子通道開關，1 = 開啟，0 = 關閉

% doublet input (按照 sysID_OBES.Ts公式 去設定波形大小)
% sysID_OBES.Ts = sysID_OBES.period / sysID_OBES.size;          % sysID_OBES.Ts公式:用於設定波形大小
% sysID_OBES.period                         = 2;                % 預設值 2秒，激勵訊號的週期時間
doublet(1,1)       =  0;
doublet(2:100,1)   =  1;
doublet(101:199,1) = -1;
doublet(200,1)     =  0;

switch sysID_OBES.waveName
    case 'doublet'
        wavePeriod                          = 2;            % 預設值2秒，激勵訊號doublet的週期時間(秒)
        sysID_OBES.TVC_ry.wave              = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.TVC_rz.wave              = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.TVC_ly.wave              = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.TVC_lz.wave              = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.right_aileron.wave       = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.left_aileron.wave        = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.right_elevator.wave      = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.left_elevator.wave       = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.rudder.wave              = doublet;      % 子通道激勵訊號的波形

        sysID_OBES.initial_delay            = 3;            % 預設值  3秒，系統識別實驗開始之後的延緩時間，目的是為了記錄下初始平衡點位置，使飛機穩態飛行
        sysID_OBES.final_delay              = 20;           % 預設值 20秒，系統識別實驗結束之前的不動作時間，目地是為了要讓飛機回到平衡點位置，時間長度的設定是隨著不同的機動動作而改變
        sysID_OBES.TVC_ry.delay             = 0;            % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.TVC_rz.delay             = 5;            % 預設值  5秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.TVC_ly.delay             = 10;           % 預設值 10秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.TVC_lz.delay             = 15;           % 預設值 15秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.right_aileron.delay      = 20;           % 預設值 20秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.left_aileron.delay       = 25;           % 預設值 25秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.right_elevator.delay     = 30;           % 預設值 30秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.left_elevator.delay      = 35;           % 預設值 35秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.rudder.delay             = 40;           % 預設值 40秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        
        sysID_OBES.TVC_ry.amplitude         = 1;            % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.TVC_rz.amplitude         = 1;            % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.TVC_ly.amplitude         = 1;            % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.TVC_lz.amplitude         = 1;            % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.right_aileron.amplitude  = 8;            % 預設值 8，子通道激勵訊號的振幅
        sysID_OBES.left_aileron.amplitude   = 8;            % 預設值 8，子通道激勵訊號的振幅
        sysID_OBES.right_elevator.amplitude = 1;            % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.left_elevator.amplitude  = 1;            % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.rudder.amplitude         = 4;            % 預設值 4，子通道激勵訊號的振幅

    case 'Orthogonal_Multisine'
        % Orthogonal_Multisine input
        run('create_Orthogonal_Multisine.m')
        Orthogonal_Multisine = inputSignal(:,2:3);

        wavePeriod                          = 20;                        % 預設值20秒，激勵訊號Orthogonal_Multisine的週期時間(秒)
        sysID_OBES.TVC_ry.wave              = Orthogonal_Multisine(:,1); % 子通道激勵訊號的波形
        sysID_OBES.TVC_rz.wave              = 0;                         % 子通道激勵訊號的波形
        sysID_OBES.TVC_ly.wave              = Orthogonal_Multisine(:,1); % 子通道激勵訊號的波形
        sysID_OBES.TVC_lz.wave              = 0;                         % 子通道激勵訊號的波形
        sysID_OBES.right_aileron.wave       = 0;                         % 子通道激勵訊號的波形
        sysID_OBES.left_aileron.wave        = 0;                         % 子通道激勵訊號的波形
        sysID_OBES.right_elevator.wave      = Orthogonal_Multisine(:,2); % 子通道激勵訊號的波形
        sysID_OBES.left_elevator.wave       = Orthogonal_Multisine(:,2); % 子通道激勵訊號的波形
        sysID_OBES.rudder.wave              = 0;                         % 子通道激勵訊號的波形

        sysID_OBES.initial_delay            = 3;                         % 預設值  3秒，系統識別實驗開始之後的延緩時間，目的是為了記錄下初始平衡點位置，使飛機穩態飛行
        sysID_OBES.final_delay              = 20;                        % 預設值 20秒，系統識別實驗結束之前的不動作時間，目地是為了要讓飛機回到平衡點位置，時間長度的設定是隨著不同的機動動作而改變
        sysID_OBES.TVC_ry.delay             = 0;                         % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.TVC_rz.delay             = 0;                         % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.TVC_ly.delay             = 0;                         % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.TVC_lz.delay             = 0;                         % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.right_aileron.delay      = 0;                         % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.left_aileron.delay       = 0;                         % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.right_elevator.delay     = 0;                         % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.left_elevator.delay      = 0;                         % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.rudder.delay             = 0;                         % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        
        sysID_OBES.TVC_ry.amplitude         = 1;                         % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.TVC_rz.amplitude         = 1;                         % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.TVC_ly.amplitude         = 1;                         % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.TVC_lz.amplitude         = 1;                         % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.right_aileron.amplitude  = 1;                         % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.left_aileron.amplitude   = 1;                         % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.right_elevator.amplitude = 1;                         % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.left_elevator.amplitude  = 1;                         % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.rudder.amplitude         = 1;                         % 預設值 1，子通道激勵訊號的振幅

    otherwise
        wavePeriod                          = 2;            % 預設值2秒，激勵訊號doublet的週期時間(秒)
        sysID_OBES.TVC_ry.wave              = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.TVC_rz.wave              = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.TVC_ly.wave              = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.TVC_lz.wave              = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.right_aileron.wave       = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.left_aileron.wave        = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.right_elevator.wave      = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.left_elevator.wave       = doublet;      % 子通道激勵訊號的波形
        sysID_OBES.rudder.wave              = doublet;      % 子通道激勵訊號的波形

        sysID_OBES.initial_delay            = 3;            % 預設值  3秒，系統識別實驗開始之後的延緩時間，目的是為了記錄下初始平衡點位置，使飛機穩態飛行
        sysID_OBES.final_delay              = 20;           % 預設值 20秒，系統識別實驗結束之前的不動作時間，目地是為了要讓飛機回到平衡點位置，時間長度的設定是隨著不同的機動動作而改變
        sysID_OBES.TVC_ry.delay             = 0;            % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.TVC_rz.delay             = 5;            % 預設值  5秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.TVC_ly.delay             = 10;           % 預設值 10秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.TVC_lz.delay             = 15;           % 預設值 15秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.right_aileron.delay      = 20;           % 預設值 20秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.left_aileron.delay       = 25;           % 預設值 25秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.right_elevator.delay     = 30;           % 預設值 30秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.left_elevator.delay      = 35;           % 預設值 35秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        sysID_OBES.rudder.delay             = 40;           % 預設值 40秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
        
        sysID_OBES.TVC_ry.amplitude         = 1;            % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.TVC_rz.amplitude         = 1;            % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.TVC_ly.amplitude         = 1;            % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.TVC_lz.amplitude         = 1;            % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.right_aileron.amplitude  = 8;            % 預設值 8，子通道激勵訊號的振幅
        sysID_OBES.left_aileron.amplitude   = 8;            % 預設值 8，子通道激勵訊號的振幅
        sysID_OBES.right_elevator.amplitude = 1;            % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.left_elevator.amplitude  = 1;            % 預設值 1，子通道激勵訊號的振幅
        sysID_OBES.rudder.amplitude         = 4;            % 預設值 4，子通道激勵訊號的振幅
end
sysID_OBES.TVC_ry.size          = length( sysID_OBES.TVC_ry.wave );          % 用於設定 sysID_OBES 內的 Pause Counter 模塊
sysID_OBES.TVC_rz.size          = length( sysID_OBES.TVC_rz.wave );          % 用於設定 sysID_OBES 內的 Pause Counter 模塊
sysID_OBES.TVC_ly.size          = length( sysID_OBES.TVC_ly.wave );          % 用於設定 sysID_OBES 內的 Pause Counter 模塊
sysID_OBES.TVC_lz.size          = length( sysID_OBES.TVC_lz.wave );          % 用於設定 sysID_OBES 內的 Pause Counter 模塊
sysID_OBES.right_aileron.size   = length( sysID_OBES.right_aileron.wave );   % 用於設定 sysID_OBES 內的 Pause Counter 模塊
sysID_OBES.left_aileron.size    = length( sysID_OBES.left_aileron.wave );    % 用於設定 sysID_OBES 內的 Pause Counter 模塊
sysID_OBES.right_elevator.size  = length( sysID_OBES.right_elevator.wave );  % 用於設定 sysID_OBES 內的 Pause Counter 模塊
sysID_OBES.left_elevator.size   = length( sysID_OBES.left_elevator.wave );   % 用於設定 sysID_OBES 內的 Pause Counter 模塊
sysID_OBES.rudder.size          = length( sysID_OBES.rudder.wave );          % 用於設定 sysID_OBES 內的 Pause Counter 模塊

sysID_OBES.TVC_ry.period         = wavePeriod;      % 子通道激勵訊號的週期(秒)
sysID_OBES.TVC_rz.period         = wavePeriod;      % 子通道激勵訊號的週期(秒)
sysID_OBES.TVC_ly.period         = wavePeriod;      % 子通道激勵訊號的週期(秒)
sysID_OBES.TVC_lz.period         = wavePeriod;      % 子通道激勵訊號的週期(秒)
sysID_OBES.right_aileron.period  = wavePeriod;      % 子通道激勵訊號的週期(秒)
sysID_OBES.left_aileron.period   = wavePeriod;      % 子通道激勵訊號的週期(秒)
sysID_OBES.right_elevator.period = wavePeriod;      % 子通道激勵訊號的週期(秒)
sysID_OBES.left_elevator.period  = wavePeriod;      % 子通道激勵訊號的週期(秒)
sysID_OBES.rudder.period         = wavePeriod;      % 子通道激勵訊號的週期(秒)

% FEM法設定
% 加速度計
Sensor.accelerometer.positionx = 0;  % 加速度計安裝位置的座標x(相對於飛機cg)
Sensor.accelerometer.positiony = 0;  % 加速度計安裝位置的座標y(相對於飛機cg)
Sensor.accelerometer.positionz = 0;  % 加速度計安裝位置的座標z(相對於飛機cg)
Sensor.accelerometer.biasx     = 0;  % 加速度計在x軸上的偏差量
Sensor.accelerometer.biasy     = 0;  % 加速度計在y軸上的偏差量
Sensor.accelerometer.biasz     = 0;  % 加速度計在z軸上的偏差量

% 陀螺儀
Sensor.gyro.positionx = 0;           % 陀螺儀安裝位置的座標x(相對於飛機cg)
Sensor.gyro.positiony = 0;           % 陀螺儀安裝位置的座標y(相對於飛機cg)
Sensor.gyro.positionz = 0;           % 陀螺儀安裝位置的座標z(相對於飛機cg)
Sensor.gyro.biasp     = 0;           % 陀螺儀在x軸上的偏差量
Sensor.gyro.biasq     = 0;           % 陀螺儀在y軸上的偏差量
Sensor.gyro.biasr     = 0;           % 陀螺儀在z軸上的偏差量
Sensor.gyro.biaspdot  = 0;           % 陀螺儀在x軸上的偏差量
Sensor.gyro.biasqdot  = 0;           % 陀螺儀在y軸上的偏差量
Sensor.gyro.biasrdot  = 0;           % 陀螺儀在z軸上的偏差量

% 機頭空速管/鼻桿(noseboom) (...校正攻角感測器和側滑角感測器!?)
Sensor.noseboom.positionx = 0;       % 鼻桿安裝位置的座標x(相對於飛機cg)
Sensor.noseboom.positiony = 0;       % 鼻桿安裝位置的座標y(相對於飛機cg)
Sensor.noseboom.positionz = 0;       % 鼻桿安裝位置的座標z(相對於飛機cg)
Sensor.noseboom.biasalpha = 0;       % 鼻桿測到alpha的偏差量
Sensor.noseboom.biasbeta  = 0;       % 鼻桿測到beta的偏差量
Sensor.K_alpha            = 1;       % 攻角的scale fctor
Sensor.K_beta             = 1;       % 側滑角的scale factor

% bias
Sensor.biasphi   = 0;                % phi角的偏差量
Sensor.biastheta = 0;                % theta角的偏差量
Sensor.biaspsi   = 0;                % psi角的偏差量
Sensor.biasmu    = 0;                % mu角的偏差量
Sensor.biaschi   = 0;                % chi角的偏差量
Sensor.biasgamma = 0;                % gamma角的偏差量
