% 初始化參數請全部放在此 PreLoadFcn.m 檔
% 當開啟Simulink模型時，本檔案會被Simulink模型的PreLoadFcn載入，進行初始化

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
IC.npos  = 0;
IC.epos  = 0;
IC.alt   = -1000;                                   % 單位：ft
IC.q0    = 0.9945;
IC.q1    = 0;
IC.q2    = 0.1045;
IC.q3    = 0;
IC.p     = 0;
IC.q     = 0;
IC.r     = 0;
IC.alpha = 0.20944;                                 % 單位：rad
IC.beta  = 0.012146;
IC.mu    = 0.0086093;
IC.Vt    = 287;                                     % 單位：ft/s ，初始值不能設成0，否則會產生除以0的計算問題。可用 IC.Vt = 1 ft/s 近似
IC.chi   = 0;
IC.gamma = 0;

IC.thrust_lbf   = 6361.9023;                        % 單位：lbf
IC.elevator_deg = -5.4631;                          % 單位：度
IC.aileron_deg  = -0.82556;                         % 單位：度
IC.rudder_deg   = -0.79402;                         % 單位：度
IC.TVC_Z_deg    = -4.6841e-14;                      % 單位：度
IC.TVC_Y_deg    = 0.7455;                           % 單位：度

IC.elevator_Integrator = IC.elevator_deg;           % 單位：度
IC.aileron_Integrator  = IC.aileron_deg;            % 單位：度
IC.rudder_Integrator   = IC.rudder_deg;             % 單位：度
IC.LEF_Integrator      = 2.2204e-14;                % 單位：度
IC.TVC_Z_Integrator    =  IC.TVC_Z_deg;             % 單位：度
IC.TVC_Y_Integrator    =  IC.TVC_Y_deg;             % 單位：度


disp('初始值 (t=0 時的配平點)：')
disp(IC)

% /Vehicle/6DOF (Quaternion)/Integrator模塊
state0 = [IC.npos IC.epos IC.alt IC.q0 IC.q1 IC.q2 IC.q3  IC.p IC.q IC.r IC.alpha IC.beta IC.mu IC.Vt IC.chi IC.gamma];


%--------------------------------------------------------------------------
% 飛機參數   【若有修改的話，需要重新配平(trim)】
%--------------------------------------------------------------------------
% ac 是 aircraft 的縮寫
ac.name     = 'F-16 A/B';       % 飛機名稱
ac.S        = 300;              % 預設值 300 ft^2, 主翼面積 planform area
ac.b        = 30;               % 預設值 30 ft, 主翼翼展 span
ac.cbar     = 11.32;            % 預設值 11.32 ft, 平均弦長 mean aero chord
ac.x_cg_ref = 0.35;             % 預設值 0.35, 這是錯誤的數值，僅測試用 reference center of gravity as a fraction of cbar
ac.x_cg     = 0.30;             % 預設值 0.30, 這是錯誤的數值，僅測試用 center of gravity as a fraction of cbar.
% ac.x_cg_ref = 0.35 * ac.cbar; % 預設值 0.35 * ac.cbar, reference center of gravity as a fraction of cbar
% ac.x_cg     = 0.30 * ac.cbar; % 預設值 0.30 * ac.cbar, center of gravity as a fraction of cbar
ac.lt       = 15.552;           % 預設值 15.552 ft, 向量噴嘴旋轉中心點至重心的距離 Engine nozzle after of c.g.

ac.m        =   636.94;         % 預設值   636.94 slugs  , mass
ac.Ix       =  9496;            % 預設值  9496 slug*ft^2
ac.Iy       = 55814;            % 預設值 55814 slug*ft^2
ac.Iz       = 63100;            % 預設值 63100 slug*ft^2
ac.Ixy      =     0;            % 預設值     0 slug*ft^2
ac.Ixz      =   982;            % 預設值   982 slug*ft^2
ac.Iyz      =     0;            % 預設值     0 slug*ft^2
ac.Heng     =     0;            % 預設值     0 slug*ft^2，turbine momentum along roll axis  (文獻記載：假設是固定值 160 slug*ft^2)

%--------------------------------------------------------------------------
g           = 32.17;            % 預設值 32.17 ft/s^2, gravity

%--------------------------------------------------------------------------
% 致動器
%--------------------------------------------------------------------------
Aactuator.elevator.AngleLimitUpper   =  25;              % 預設值  25度
Aactuator.elevator.AngleLimitLower   = -25;              % 預設值 -25度
Aactuator.elevator.RateLimitUpper    =  60;              % 預設值  60度/秒
Aactuator.elevator.RateLimitLower    = -60;              % 預設值 -60度/秒
Aactuator.elevator.IntegratorInitial = IC.elevator_Integrator;

Aactuator.aileron.AngleLimitUpper    =  21.5;            % 預設值  21.5度
Aactuator.aileron.AngleLimitLower    = -21.5;            % 預設值 -21.5度
Aactuator.aileron.RateLimitUpper     =  80;              % 預設值  80度/秒
Aactuator.aileron.RateLimitLower     = -80;              % 預設值 -80度/秒
Aactuator.aileron.IntegratorInitial  = IC.aileron_Integrator;

Aactuator.rudder.AngleLimitUpper     =  30;              % 預設值  30度
Aactuator.rudder.AngleLimitLower     = -30;              % 預設值 -30度
Aactuator.rudder.RateLimitUpper      =  120;             % 預設值 120度/秒
Aactuator.rudder.RateLimitLower      = -120;             % 預設值-120度/秒
Aactuator.rudder.IntegratorInitial   = IC.rudder_Integrator;

% /Vehicle/Aerodynamics/Leading Edge Flap模塊
% /Aerodynamic1模塊裡
% /Aerodynamic2模塊裡
Aactuator.LEF.AngleLimitUpper        =  25;              % 預設值  25度
Aactuator.LEF.AngleLimitLower        =  0;               % 預設值   0度
Aactuator.LEF.RateLimitUpper         =  25;              % 預設值  25度/秒
Aactuator.LEF.RateLimitLower         = -25;              % 預設值 -25度/秒
Aactuator.LEF.IntegratorInitial      = IC.LEF_Integrator;

Aactuator.TVC_Z.AngleLimitUpper      =  15;              % 預設值  15度
Aactuator.TVC_Z.AngleLimitLower      = -15;              % 預設值 -15度
Aactuator.TVC_Z.RateLimitUpper       =  60;              % 預設值  60度/秒
Aactuator.TVC_Z.RateLimitLower       = -60;              % 預設值 -60度/秒
Aactuator.TVC_Z.IntegratorInitial    = IC.TVC_Z_Integrator;

Aactuator.TVC_Y.AngleLimitUpper      =  15;              % 預設值  15度
Aactuator.TVC_Y.AngleLimitLower      = -15;              % 預設值 -15度
Aactuator.TVC_Y.RateLimitUpper       =  60;              % 預設值  60度/秒
Aactuator.TVC_Y.RateLimitLower       = -60;              % 預設值 -60度/秒
Aactuator.TVC_Y.IntegratorInitial    = IC.TVC_Y_Integrator;

%--------------------------------------------------------------------------
% PI控制器
%--------------------------------------------------------------------------
PIController.y.P    = 0.25;       % 建議值 0.25
PIController.y.I    = 0.05;       % 建議值 0.05

PIController.z.P    = 0.5;        % 建議值 0.5
PIController.z.I    = 0.1;        % 建議值 0.1

PIController.Vt.P    = 1;         % 建議值 1
PIController.Vt.I    = 0.2;       % 建議值 0.2

PIController.chi.P   = 0.5;       % 建議值 1   ； 降落時，設為 0.5
PIController.chi.I   = 0.1;       % 建議值 0.2 ； 降落時，設為 0.1

PIController.gamma.P = 1;         % 建議值 1
PIController.gamma.I = 0.2;       % 建議值 0.2

PIController.mu.P    = 2;         % 建議值 2
PIController.mu.I    = 1;         % 建議值 1

PIController.alpha.P = 2;         % 建議值 2
PIController.alpha.I = 1;         % 建議值 1

PIController.beta.P  = 2;         % 建議值 2
PIController.beta.I  = 1;         % 建議值 1

PIController.p.P     = 10;        % 建議值 10
PIController.p.I     = 4;         % 建議值 4

PIController.q.P     = 10;        % 建議值 10
PIController.q.I     = 4;         % 建議值 4

PIController.r.P     = 10;        % 建議值 10
PIController.r.I     = 4;         % 建議值 4

%--------------------------------------------------------------------------
% NDI控制器之控制配置(control allocation)的權重矩陣N
%--------------------------------------------------------------------------
%  /pqr NDI Controller/TVC ON/weighting matrix N 模塊

% 前提：向量噴嘴控制ON 才有作用。 也就是 /pqr NDI Controller模塊 要設定成 "TVC ON"

%---------------------
% 菊鍊式(mix)
%---------------------
%     N = [ 1      0     0.25;
%           0      1     0; 
%           0.25   0     1;
%           0.25   0     0.5;
%           0      0.5   0     ];

%---------------------
% 聯動式(控制配置)   
%---------------------
% 降落且減速板開40度時的建議值：
% N = [ 1      0     0.25;
%       0      1     0;
%       0.25   0     1;
%       0.25   0     0.5;
%       0      5.5   0    ];
                     
N = [ 1      0     0.25;
      0      1     0;
      0.25   0     1;
      0.25   0     0.5;
      0      5.5   0    ];






