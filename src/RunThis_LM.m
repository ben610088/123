clc ,clear, close all;
% 修訂歷史：
% mdl = 'NDI_controller_f16_Vt_YZ_TVC_SB_try_changeToSubsystem'    % 訂正氣動力係數，幾乎是原始程式，但模擬時間只需要42秒
% mdl = 'NDI_controller_f16_Vt_YZ_TVC_SB_20201017'                 % 修改前的對照組
% mdl = 'NDI_controller_f16_Vt_YZ_TVC_SB_20201019'                 % 氣動力係數模塊「coefficient1/2模塊」修改成 「Aerodynamic模塊」 直接輸出氣動力和力矩
% mdl = 'NDI_controller_f16_Vt_YZ_TVC_SB_20201020'                 % 「pqr NDI Controller模塊」改成可手動切換向量噴嘴控制ON/OFF
% mdl = 'NDI_controller_f16_Vt_YZ_TVC_SB_20201026'                 % 主要重新整理 Plant model 內部架構。初始值、控制器PI值、致動器極限值 的設定移到 PreLoadFcn.m。發現取消/繞過IC6模塊，代數迴圈 會從2個 變成1個，計算時間又縮短了! 最快只要26秒~~
% -------- 從這版本起不再支援上述模型，上面模型無法跑---------------  % 因為架構簡化，導致IC3模塊的元素個數與上述版本不同
% mdl = 'NDI_controller_f`16_Vt_YZ_TVC_SB_20201109'                % Plant model的輸出訊號全部集結成 ModelBus 匯流排 (PlantData)，大幅簡化線路，美化版面
% mdl = 'NDI_controller_f16_Vt_YZ_TVC_SB_20201125'                 % 刪除不必要的IC模塊。發動機推力表格 納入 PreLoadFcn.m 檔。發動機推力表格、氣動力係數表格 完全複製自Word檔，以令兩邊數據一致
% mdl = 'NDI_controller_f16_Vt_YZ_TVC_SB_20201127'                 % Aerodynamic1 模塊 訂正 m_hat_de 計算，加入之前漏掉的 dCm_ds 項。μαβ NDI Controller/f2模塊的輸出端指定port dimensions=3。
% mdl = 'NDI_controller_f16_Vt_YZ_TVC_SB_20201202'                 % 改成模擬起飛。模擬時間從75秒改成30秒。加入起落架、跑道作用力 ， 修改之處參閱「合併程式更改處20201202.docx」
% mdl = 'NDI_controller_f16_Vt_YZ_TVC_SB_20201220'                 % control matrix g1 模塊，加入Matrix Concatenate模塊將原先分別輸出三列的列向量合併成輸出g1矩陣。致動器的積分器中加入角度限制。將原本對command的角度限制，移至pqr NDI Controller模塊輸出端。
% mdl = 'NDI_controller_f16_Vt_YZ_TVC_SB_20201224'                 % 暫時先拆分成起飛/降落兩個檔案。新增 前緣襟翼(LEF)的致動器。由 Aerodynamic1模塊 輸出 前緣襟翼(LEF)的致動器之控制命令。Aerodynamic1模塊裡的 LEF 計算 刪掉其 rate limit 模塊


% FlightPhase = 'TakeOff';                                         % 飛行模式，可選：'TakeOff'、'Landing'、'InAir'、'FallingLeaf'
FlightPhase = 'FallingLeaf';
% FlightPhase = 'InAir';
% FlightPhase = 'TVC_h10000V617alpha2';
run('PreLoadFcn.m')                                                % 載入初始參數設定

ControlAllocation = 4;                                             % 控制配置/分配律 的模式選擇
%   1       = Weighted Pseudo Inverse 加權偽逆法
%   2       = DAISY_CHIAN             串接鏈配置法
%   3       = CGI                     多級偽逆法
%   4       = DA                      直接幾何法
%   5       = controlmanagement2      管理方案二 期望力矩與力矩可達集關係(家維 論文第5.2節)
%   6       = controlmanagement3      管理方案三 廣義逆類法(家維 論文第5.3節)
%   7       = LP_BasicSolutoion       線性規劃法基礎解 (家維 論文4.1節)
%   8       = LP_lift                 最大升力
%   9       = LP_thrustt              最小向量推力
%   10      = LP_def                  最小控制面偏轉量
%   11      = LP_sig                  最小雷達散射截面積
%   12      = 2019張舜淵論文配置法
% otherwise = CGI                     多級偽逆法

sysID_OBES.waveName                         = 'Orthogonal_Multisine';    % 激勵訊號的波形名稱，可選：'doublet'、'Orthogonal_Multisine'、...
sysID_OBES.start_time                       = 50;           % 預設值 第 40 秒觸發 sysID_Onboard_Excitation_System 

sysID_OBES.isEnable                         = 0;            % 預設值 1， 總開關，是否要進行系統識別實驗。1 = 開啟，0 = 關閉
% sysID_OBES.isEnable                         = 1;            % 預設值 1， 總開關，是否要進行系統識別實驗。1 = 開啟，0 = 關閉

sysID_OBES.TVC_ry.isTurnOn                  = 0;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.TVC_rz.isTurnOn                  = 0;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.TVC_ly.isTurnOn                  = 0;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.TVC_lz.isTurnOn                  = 0;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.right_aileron.isTurnOn           = 0;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.left_aileron.isTurnOn            = 0;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.right_elevator.isTurnOn          = 0;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.left_elevator.isTurnOn           = 0;            % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
sysID_OBES.rudder.isTurnOn                  = 0;            % 預設值 1。 子通道開關，1 = 開啟，0 = 關閉



N = [ 1      0     0.25;        % ← 右副翼
      1      0     0.25;        % ← 左副翼
      0      1     0;           % ← 右升降舵
      0      1     0;           % ← 左升降舵
      0.25   0     1;           % ← 方向舵
      0      5.5   0;           % ← 右向量噴嘴上下偏轉(pitch) TVC_rY ，注意：勁豪跟庭宇的 TVC_Y 與 TVC_Z 定義相反，所以順序要顛倒
      0.25   0     0.5;     	% ← 右向量噴嘴左右偏轉(yaw)   TVC_rZ
      0      5.5   0;           % ← 左向量噴嘴上下偏轉(pitch) TVC_lY
      0.25   0     0.5     ];   % ← 左向量噴嘴左右偏轉(yaw)   TVC_lZ

switch FlightPhase
    case 'TakeOff'
        mdl = 'NDI';                                          % LM 合併 勁豪+家維 & 庭宇
    case 'Landing'
        mdl = 'NDI';                                          % LM 合併 勁豪+家維 & 庭宇
    case 'InAir'
        mdl = 'NDI';                                          % LM 合併 勁豪+家維 & 庭宇
    otherwise
        mdl = 'NDI';                                          % LM 合併 勁豪+家維 & 庭宇
%       mdl = 'NDI_controller_f16_mu_alpha_beta_TVC_SB_mutics1_3_0223'     % 家維 舊 2022-03-11
%       mdl = 'NDI_controller_f16_mu_alpha_beta_TVC_SB'                    % 賴勁豪論文6.8節
end
disp(['模擬 Simulink 檔         ： ', mdl, '.slx'])
disp(['控制配置/分配律 的模式選擇： ControlAllocation = ', num2str(ControlAllocation)])


switch FlightPhase
    case 'TakeOff'
        tic
        sim(mdl, [0 15.5])     % 有向量噴嘴 ...by 庭宇論文
%         sim(mdl, [0 20])     % 無向量噴嘴 ...by 庭宇論文
        toc
        % 降落
    case 'Landing'
        tic
        sim(mdl, [0 inf])         % 庭宇論文
%         sim(mdl, [0 80])            % test
        toc
        case 'FallingLeaf'
        tic
        sim(mdl, [0 70])
        toc
    otherwise
        tic
%         sim(mdl, [0 20])           % by 勁豪 & 家維
        sim(mdl, [0 100])             % test
        toc
end
% u1 = get_param('NDI_controller_f16_mu_alpha_beta_TVC_SB_mutics1_2/F-16 Vehicle Systems Model/pqr NDI Controller/TVC ON/Control Allocation','RuntimeObject')
total_plot_9_1

% Measurement
% total_plot_5                                                               % 賴勁豪論文6.8節

sysID_fileName = 'sysID_GeometryData_A1.mat';                             % 飛機 Geometry data 的存檔位置
fileName = fullfile(pwd,'sysID','sysID_timeDomain',sysID_fileName);
save(fileName);                                                     % 儲存飛機的 Geometry data 給系統識別用

% 註一：
% get_param('mdl/子系統名稱/模塊名稱', 'DialogParameters')    查看該模塊全部的參數名稱
% get_param('mdl/子系統名稱/模塊名稱', '參數名稱')             獲取該模塊之參數名稱的參數值
% set_param('mdl/子系統名稱/模塊名稱', '參數名稱', '新參數值')  將該模塊之參數名稱修改為新的參數值
% 註二：
% 若有代數迴路(algebraic loop(s))，就無法轉成C程式碼
% 漫談Simulink：真假代數環  https://zhuanlan.zhihu.com/p/21250983
% 識別模型中的代數迴路： https://www.mathworks.com/help/simulink/ug/identify-algebraic-loops-in-your-model.html
% 刪除代數迴路： https://www.mathworks.com/help/simulink/ug/remove-algebraic-loops.html
% 建模時要考慮的代數迴路注意事項：  https://www.mathworks.com/help/simulink/ug/modeling-considerations-with-algebraic-loops.html
%「Algebraic Constraint」模塊  https://www.mathworks.com/help/simulink/slref/algebraicconstraint.html
% Simulink.BlockDiagram.getAlgebraicLoops(mdl)       % 顯示代數迴路(實線)、可刪除的人造的假代數迴路(artificial algebraic loops)(虛線)
% Simulink.BlockDiagram.getAlgebraicLoops(bdroot)    % 也可以用這指令