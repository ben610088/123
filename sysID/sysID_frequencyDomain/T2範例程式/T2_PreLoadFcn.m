% T2 轉移函數
%參考資料：2020 讚！Jared A. Grauer - Real-Time Estimation of Bare-Airframe Frequency Responses from Closed-Loop Data and Multisine Inputs
clc, clear, close all
test_case = 'MultipleLoop';                                                % 可以選擇 'OpenLoop','SingleLoop','MultipleLoop'


load('D:\NDI\sysID\sysID_frequencyDomain\T2範例程式\T2.mat')
numerator = {[-18.1 -36] [-18.1 -36]; [-0.38 -0.4 146] [-0.38 -0.4 146]}; 
denominator = [1 5.13 35.1];
sys = tf(numerator, denominator);

wrap_case = 'unwrap';                                                      % 可選'wrap','unwrap'。unwrap 是相位圖中，若兩相鄰的相位角跳變180度或-180度，改為連續變化
true_case = 'true';                                                        % 可選'true','untrue'
run('Orthogonal_Multisine.m');
sysID_DAQ.sampleTime = 1/fs;                                               % 資料擷取系統的取樣時間(秒)
simTime = t(end);                                                          % simulink 時間


switch test_case
    case 'OpenLoop'
        C11 = 0;                                                           % 迴授的 gain 值
        C21 = 0;
        mdl = 'T2_simulation_2020a';                                       % 指定要載入的 simulink model 的檔名
        sim(mdl, [0 simTime]);
        run('T2_CZT.m')
        run('T2_open_loop.m')
    case 'SingleLoop'
        C11 = 0;                                                           % 迴授的 gain 值
        C21 = -0.2;

        mdl = 'T2_simulation_2020a';                                       % 指定要載入的 simulink model 的檔名
                sim(mdl, [0 simTime]);
        run('T2_CZT.m')
        run('T2_single_loop_closure.m');
    case 'MultipleLoop'
        C11 = -0.1;                                                        % 迴授的 gain 值
        C21 = -0.1;
        mdl = 'T2_simulation_2020a';                                       % 指定要載入的 simulink model 的檔名
        sim(mdl, [0 simTime]);
        run('T2_CZT.m')
        run('T2_multiple_loop_closures.m');
end
run('T_2_time_frequency_domain.m')




