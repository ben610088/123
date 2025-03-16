% T2 轉移函數
%參考資料：2020 讚！Jared A. Grauer - Real-Time Estimation of Bare-Airframe Frequency Responses from Closed-Loop Data and Multisine Inputs
clc, clear, close all

numerator = {[-18.1 -36 ] [-18.1 -36 ]; [-0.38 -0.4 146] [-0.38 -0.4 146]}; 
denominator = [1 5.13 35.1];
sys = tf(numerator, denominator)

state_space = ss(sys)
A = state_space.A;
B = state_space.B;
C = state_space.C;
D = state_space.D;
% I_C = eye(4);
% I_D = zeros(4,2) ;

% C11 = -0.1;                                                                   % 迴授的 gain 值
% C21 = -0.1;                                                               
% C11 = 1;                                                                   % 迴授的 gain 值
% C21 = 1;             

run('Orthogonal_Multisine.m');
sysID_DAQ.sampleTime = 1/fs;                                               % 資料擷取系統的取樣時間(秒)
simTime = t(end);                                                          % simulink 時間
mdl = 'T2_LDI';                                               % 指定要載入的 simulink model 的檔名
sim(mdl, [0 simTime]);
run('T2_plot_TimeHistory.m');
run('T2_CZT.m')
% % run('T2_single_loop_closure.m');
run('multiple_loop_closures.m');