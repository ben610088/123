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
% FlightPhase = 'Landing';
FlightPhase = 'InAir';
% FlightPhase = 'TVC2_h10000V617alpha2';
% FlightPhase = 'ggg';

run('PreLoadFcn.m')                                                % 載入初始參數設定

Mode_deflection_aileron  = 1;       % 偏轉模式： 0=傳統左右副翼差動；        1=左右副翼獨立偏轉
Mode_deflection_elevator = 1;       % 偏轉模式： 0=傳統左右升降舵同動；      1=左右升降舵獨立偏轉
Mode_deflection_rudder   = 1;       % 偏轉模式： 0=傳統左右方向舵差動；      1=左右方向舵獨立偏轉
Mode_deflection_TVC_z    = 1;       % 偏轉模式： 0=傳統左右向量噴嘴固定不動； 1=左右向量噴嘴左右獨立偏轉； 2=左右向量噴嘴左右同動
Mode_deflection_TVC_y    = 1;       % 偏轉模式： 0=傳統左右向量噴嘴固定不動； 1=左右向量噴嘴上下獨立偏轉； 2=左右向量噴嘴上下同動

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


% 系統識別用的資料擷取系統 (sysID_DAQ)
sysID_DAQ.sampleTime                        = 0.01;                        % 預設值 0.1 秒，資料擷取系統
% 系統識別用的機載激勵訊號系統 (sysID_Onboard_Excitation_System, sysID_OBES)
sysID_OBES.Ts                               = 0.01;         % sysID_OBES 的取樣時間(秒)

test_case                                   = 'no_sysID';                  % 可選：'no_sysID', 'sysID_all', 'sysID_longitudinal', 'sysID_lateral', ...
sysID_OBES.waveName                         = 'Orthogonal_Multisine';      % 激勵訊號的波形名稱，可選：'doublet'、'Orthogonal_Multisine'、...

switch test_case
    case 'no_sysID'
        sysID_OBES.start_time                       = 50;   % 預設值 第 50 秒觸發 sysID_Onboard_Excitation_System
        sysID_OBES.isEnable                         = 0;    % 預設值 1， 總開關，是否要進行系統識別實驗。1 = 開啟，0 = 關閉
        sysID_OBES.TVC_ry.isTurnOn                  = 0;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.TVC_rz.isTurnOn                  = 0;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.TVC_ly.isTurnOn                  = 0;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.TVC_lz.isTurnOn                  = 0;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.right_aileron.isTurnOn           = 0;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.left_aileron.isTurnOn            = 0;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.right_elevator.isTurnOn          = 0;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.left_elevator.isTurnOn           = 0;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.rudder.isTurnOn                  = 0;    % 預設值 1。 子通道開關，1 = 開啟，0 = 關閉
    case 'sysID_all'
        sysID_OBES.start_time                       = 50;   % 預設值 第 50 秒觸發 sysID_Onboard_Excitation_System
        sysID_OBES.isEnable                         = 1;    % 預設值 1， 總開關，是否要進行系統識別實驗。1 = 開啟，0 = 關閉
        sysID_OBES.TVC_ry.isTurnOn                  = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.TVC_rz.isTurnOn                  = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.TVC_ly.isTurnOn                  = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.TVC_lz.isTurnOn                  = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.right_aileron.isTurnOn           = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.left_aileron.isTurnOn            = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.right_elevator.isTurnOn          = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.left_elevator.isTurnOn           = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.rudder.isTurnOn                  = 1;    % 預設值 1。 子通道開關，1 = 開啟，0 = 關閉
    case 'sysID_longitudinal'
        sysID_OBES.start_time                       = 50;   % 預設值 第 50 秒觸發 sysID_Onboard_Excitation_System
        sysID_OBES.isEnable                         = 1;    % 預設值 1， 總開關，是否要進行系統識別實驗。1 = 開啟，0 = 關閉
        sysID_OBES.TVC_ry.isTurnOn                  = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.TVC_rz.isTurnOn                  = 0;    % 預設值 0， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.TVC_ly.isTurnOn                  = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.TVC_lz.isTurnOn                  = 0;    % 預設值 0， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.right_aileron.isTurnOn           = 0;    % 預設值 0， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.left_aileron.isTurnOn            = 0;    % 預設值 0， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.right_elevator.isTurnOn          = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.left_elevator.isTurnOn           = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.rudder.isTurnOn                  = 0;    % 預設值 0。 子通道開關，1 = 開啟，0 = 關閉
    case 'sysID_lateral'
        sysID_OBES.start_time                       = 50;   % 預設值 第 50 秒觸發 sysID_Onboard_Excitation_System
        sysID_OBES.isEnable                         = 1;    % 預設值 1， 總開關，是否要進行系統識別實驗。1 = 開啟，0 = 關閉
        sysID_OBES.TVC_ry.isTurnOn                  = 0;    % 預設值 0， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.TVC_rz.isTurnOn                  = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.TVC_ly.isTurnOn                  = 0;    % 預設值 0， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.TVC_lz.isTurnOn                  = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.right_aileron.isTurnOn           = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.left_aileron.isTurnOn            = 1;    % 預設值 1， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.right_elevator.isTurnOn          = 0;    % 預設值 0， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.left_elevator.isTurnOn           = 0;    % 預設值 0， 子通道開關，1 = 開啟，0 = 關閉
        sysID_OBES.rudder.isTurnOn                  = 1;    % 預設值 1。 子通道開關，1 = 開啟，0 = 關閉
    otherwise
        disp('錯誤：  test_case 沒有這個選項，請檢查拼字是否正確')
end

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
        switch test_case
            case 'no_sysID'
                % 全開
                sysID_OBES.initial_delay            = 0;    % 預設值  3秒，系統識別實驗開始之後的延緩時間，目的是為了記錄下初始平衡點位置，使飛機穩態飛行
                sysID_OBES.final_delay              = 0;    % 預設值 20秒，系統識別實驗結束之前的不動作時間，目地是為了要讓飛機回到平衡點位置，時間長度的設定是隨著不同的機動動作而改變
                sysID_OBES.TVC_ry.delay             = 0;    % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.TVC_rz.delay             = 0;    % 預設值  5秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.TVC_ly.delay             = 0;    % 預設值 10秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.TVC_lz.delay             = 0;    % 預設值 15秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.right_aileron.delay      = 0;    % 預設值 20秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.left_aileron.delay       = 0;    % 預設值 25秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.right_elevator.delay     = 0;    % 預設值 30秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.left_elevator.delay      = 0;    % 預設值 35秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.rudder.delay             = 0;    % 預設值 40秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
            case 'sysID_all'
                % 全開
                sysID_OBES.initial_delay            = 3;    % 預設值  3秒，系統識別實驗開始之後的延緩時間，目的是為了記錄下初始平衡點位置，使飛機穩態飛行
                sysID_OBES.final_delay              = 20;   % 預設值 20秒，系統識別實驗結束之前的不動作時間，目地是為了要讓飛機回到平衡點位置，時間長度的設定是隨著不同的機動動作而改變
                sysID_OBES.TVC_ry.delay             = 0;    % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.TVC_rz.delay             = 5;    % 預設值  5秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.TVC_ly.delay             = 10;   % 預設值 10秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.TVC_lz.delay             = 15;   % 預設值 15秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.right_aileron.delay      = 20;   % 預設值 20秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.left_aileron.delay       = 25;   % 預設值 25秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.right_elevator.delay     = 30;   % 預設值 30秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.left_elevator.delay      = 35;   % 預設值 35秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.rudder.delay             = 40;   % 預設值 40秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
            case 'sysID_longitudinal'
                % 縱向
                sysID_OBES.initial_delay            = 3;    % 預設值  3秒，系統識別實驗開始之後的延緩時間，目的是為了記錄下初始平衡點位置，使飛機穩態飛行
                sysID_OBES.final_delay              = 20;   % 預設值 20秒，系統識別實驗結束之前的不動作時間，目地是為了要讓飛機回到平衡點位置，時間長度的設定是隨著不同的機動動作而改變
                sysID_OBES.TVC_ry.delay             = 0;    % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.TVC_rz.delay             = 0;    % 預設值 XX秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.TVC_ly.delay             = 5;    % 預設值  5秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.TVC_lz.delay             = 0;    % 預設值 XX秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.right_aileron.delay      = 0;    % 預設值 XX秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.left_aileron.delay       = 0;    % 預設值 XX秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.right_elevator.delay     = 10;   % 預設值 10秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.left_elevator.delay      = 15;   % 預設值 15秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.rudder.delay             = 0;    % 預設值 XX秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
            case 'sysID_lateral'
                sysID_OBES.initial_delay            = 3;    % 預設值  3秒，系統識別實驗開始之後的延緩時間，目的是為了記錄下初始平衡點位置，使飛機穩態飛行
                sysID_OBES.final_delay              = 20;   % 預設值 20秒，系統識別實驗結束之前的不動作時間，目地是為了要讓飛機回到平衡點位置，時間長度的設定是隨著不同的機動動作而改變
                sysID_OBES.TVC_ry.delay             = 0;    % 預設值 XX秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.TVC_rz.delay             = 0;    % 預設值  0秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.TVC_ly.delay             = 0;    % 預設值 XX秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.TVC_lz.delay             = 5;    % 預設值  5秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.right_aileron.delay      = 10;   % 預設值 10秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.left_aileron.delay       = 15;   % 預設值 15秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.right_elevator.delay     = 0;    % 預設值 XX秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.left_elevator.delay      = 0;    % 預設值 XX秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
                sysID_OBES.rudder.delay             = 20;   % 預設值 20秒 (與下個激勵訊號相差5秒)。子通道的延遲啟動時間
            otherwise
                disp('錯誤：  test_case 沒有這個選項，請檢查拼字是否正確')
        end
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
        switch test_case
            case 'no_sysID'
            case 'sysID_longitudinal'
                wavePeriod                          = 20;                        % 預設值20秒，激勵訊號Orthogonal_Multisine的週期時間(秒)
                sysID_OBES.TVC_ry.wave              = Orthogonal_Multisine(:,2); % 子通道激勵訊號的波形
                sysID_OBES.TVC_rz.wave              = 0;                         % 子通道激勵訊號的波形
                sysID_OBES.TVC_ly.wave              = Orthogonal_Multisine(:,2); % 子通道激勵訊號的波形
                sysID_OBES.TVC_lz.wave              = 0;                         % 子通道激勵訊號的波形
                sysID_OBES.right_aileron.wave       = 0;                         % 子通道激勵訊號的波形
                sysID_OBES.left_aileron.wave        = 0;                         % 子通道激勵訊號的波形
                sysID_OBES.right_elevator.wave      = Orthogonal_Multisine(:,1); % 子通道激勵訊號的波形
                sysID_OBES.left_elevator.wave       = Orthogonal_Multisine(:,1); % 子通道激勵訊號的波形
                sysID_OBES.rudder.wave              = 0;                         % 子通道激勵訊號的波形
%             case 'sysID_lateral'                                         
%                 Orthogonal_Multisine = inputSignal(:,2:4);
%                 wavePeriod                          = 20;                        % 預設值20秒，激勵訊號Orthogonal_Multisine的週期時間(秒)
%                 sysID_OBES.TVC_ry.wave              = 0;                         % 子通道激勵訊號的波形
%                 sysID_OBES.TVC_rz.wave              = Orthogonal_Multisine(:,2); % 子通道激勵訊號的波形
%                 sysID_OBES.TVC_ly.wave              = 0;                         % 子通道激勵訊號的波形
%                 sysID_OBES.TVC_lz.wave              = Orthogonal_Multisine(:,2); % 子通道激勵訊號的波形
%                 sysID_OBES.right_aileron.wave       = Orthogonal_Multisine(:,1); % 子通道激勵訊號的波形
%                 sysID_OBES.left_aileron.wave        = Orthogonal_Multisine(:,1); % 子通道激勵訊號的波形
%                 sysID_OBES.right_elevator.wave      = 0;                         % 子通道激勵訊號的波形
%                 sysID_OBES.left_elevator.wave       = 0;                         % 子通道激勵訊號的波形
%                 sysID_OBES.rudder.wave              = Orthogonal_Multisine(:,3); % 子通道激勵訊號的波形
            otherwise
                disp('錯誤：  test_case 沒有這個選項，請檢查拼字是否正確')
                
        end
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


sysID_OBES.TVC_ry.period         = wavePeriod;              % 子通道激勵訊號的週期(秒)
sysID_OBES.TVC_rz.period         = wavePeriod;              % 子通道激勵訊號的週期(秒)
sysID_OBES.TVC_ly.period         = wavePeriod;              % 子通道激勵訊號的週期(秒)
sysID_OBES.TVC_lz.period         = wavePeriod;              % 子通道激勵訊號的週期(秒)
sysID_OBES.right_aileron.period  = wavePeriod;              % 子通道激勵訊號的週期(秒)
sysID_OBES.left_aileron.period   = wavePeriod;              % 子通道激勵訊號的週期(秒)
sysID_OBES.right_elevator.period = wavePeriod;              % 子通道激勵訊號的週期(秒)
sysID_OBES.left_elevator.period  = wavePeriod;              % 子通道激勵訊號的週期(秒)
sysID_OBES.rudder.period         = wavePeriod;              % 子通道激勵訊號的週期(秒)

%--------------------------------------------------------------------------
% 計算 Simulink 所需要的總模擬時間simTime(秒)
%--------------------------------------------------------------------------
% temp表格 = [ 通道的delay時間  訊號波形的週期時間 ]
temp = [0 0];
if (sysID_OBES.TVC_ry.isTurnOn == 1)
    temp = [ temp; sysID_OBES.TVC_ry.delay sysID_OBES.TVC_ry.period ];
end
if (sysID_OBES.TVC_rz.isTurnOn == 1)
    temp = [ temp; sysID_OBES.TVC_rz.delay sysID_OBES.TVC_rz.period ];
end
if (sysID_OBES.TVC_ly.isTurnOn == 1)
    temp = [ temp; sysID_OBES.TVC_ly.delay sysID_OBES.TVC_ly.period ];
end
if (sysID_OBES.TVC_lz.isTurnOn == 1)
    temp = [ temp; sysID_OBES.TVC_lz.delay sysID_OBES.TVC_lz.period ];
end
if (sysID_OBES.right_aileron.isTurnOn == 1)
    temp = [ temp; sysID_OBES.right_aileron.delay sysID_OBES.right_aileron.period ];
end
if (sysID_OBES.left_aileron.isTurnOn == 1)
    temp = [ temp; sysID_OBES.left_aileron.delay sysID_OBES.left_aileron.period ];
end
if (sysID_OBES.right_elevator.isTurnOn == 1)
    temp = [ temp; sysID_OBES.right_elevator.delay sysID_OBES.right_elevator.period ];
end
if (sysID_OBES.left_elevator.isTurnOn == 1)
    temp = [ temp; sysID_OBES.left_elevator.delay sysID_OBES.left_elevator.period ];
end
if (sysID_OBES.rudder.isTurnOn == 1)
    temp = [ temp; sysID_OBES.rudder.delay sysID_OBES.rudder.period ];
end
% 計算 Simulink 所需要的總模擬時間simTime(秒)
simTime = sysID_OBES.start_time + ...           
          sysID_OBES.initial_delay + ...
          max(sum(temp,2)) + ...                   % (觸發通道的delay時間 + 訊號波形的週期時間)之最大值
          sysID_OBES.final_delay;           
%--------------------------------------------------------------------------



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
        sim(mdl, [0 20])           % by 勁豪 & 家維
%         sim(mdl, [0 simTime])             % test
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