% 裁剪timeseries，截取所需要的精彩片段。 
% 會將片段的時間重設成0。
% 方便FlightGear動畫模擬時，直接從精彩片段開始模擬
% 注意：本程式會破壞/覆蓋原始的模擬資料。因此，若你要用原資料畫圖，應先畫圖，再來執行本程式。

clipStartTime = 50;                                      % 選取你想要截取片段的起點時間
clipTimeStep  = fcs.Ts;                                  % 原timeseries的每個時間步長 (秒)
% -------------------------------------------------------------------------
clipEndTime = f16_control_inertia_axis.Time(end);        % 選取你想要截取片段的終點時間
fprintf("裁剪前，原始結束時間 = %f 秒\n",clipEndTime)

% 截取 timeseries 數據的子集
f16_control_inertia_axis = getsampleusingtime(f16_control_inertia_axis, clipStartTime, clipEndTime);
f16_control_Euler        = getsampleusingtime(f16_control_Euler       , clipStartTime, clipEndTime);
f16_control_energy       = getsampleusingtime(f16_control_energy      , clipStartTime, clipEndTime);
f16_control_LEF          = getsampleusingtime(f16_control_LEF         , clipStartTime, clipEndTime);
f16_control_velocity     = getsampleusingtime(f16_control_velocity    , clipStartTime, clipEndTime);
f16_control_alpha_beta   = getsampleusingtime(f16_control_alpha_beta  , clipStartTime, clipEndTime);
sysID_OutputData         = getsampleusingtime(sysID_OutputData        , clipStartTime, clipEndTime);
sysID_InputData          = getsampleusingtime(sysID_InputData         , clipStartTime, clipEndTime);

% 修改成均勻的 timeseries 時間向量
f16_control_inertia_axis = setuniformtime(f16_control_inertia_axis,'StartTime',0,'Interval',clipTimeStep);
f16_control_Euler        = setuniformtime(f16_control_Euler       ,'StartTime',0,'Interval',clipTimeStep);
f16_control_energy       = setuniformtime(f16_control_energy      ,'StartTime',0,'Interval',clipTimeStep);
f16_control_LEF          = setuniformtime(f16_control_LEF         ,'StartTime',0,'Interval',clipTimeStep);
f16_control_velocity     = setuniformtime(f16_control_velocity    ,'StartTime',0,'Interval',clipTimeStep);
f16_control_alpha_beta   = setuniformtime(f16_control_alpha_beta  ,'StartTime',0,'Interval',clipTimeStep);
sysID_OutputData         = setuniformtime(sysID_OutputData        ,'StartTime',0,'Interval',sysID_DAQ.sampleTime);
sysID_InputData          = setuniformtime(sysID_InputData         ,'StartTime',0,'Interval',sysID_DAQ.sampleTime);

simFgEndTime = f16_control_inertia_axis.Time(end);
fprintf("裁剪後，結束時間\n simFgEndTime = %f 秒\n",simFgEndTime)
