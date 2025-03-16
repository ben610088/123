clc ,clear, close all;
A = [-1.9311E-02    8.8157   -3.217E+01   -5.7499E-01;
     -2.5389E-04   -1.0189        0        9.0506E-01;
         0             0          0            1     ;
     2.9465E-12   8.2225E-01      0        -1.0774  ];
B = [ 1.737E-01   0.1;
     -2.1499E-03  0.1;
         0        0.1;
     -1.7555E-01  0.1];
I_C = eye(4);
C = [0   1  0   0    ;
     0   0  0   1];
D = zeros(4,2);
load('D:\NDI\sysID\sysID_frequencyDomain\steven範例程式\Steven.mat')

run('Orthogonal_Multisine.m');
sysID_DAQ.sampleTime = 1/fs;                                               % 資料擷取系統的取樣時間(秒)
simTime = t(end);                                                          % simulink 時間
mdl = 'Steven';                                               % 指定要載入的 simulink model 的檔名
sim(mdl, [0 simTime]);
run('T2_plot_TimeHistory.m');
run('T2_CZT.m')
run('multiple_loop_closures.m');



