% T2 轉移函數
%參考資料：2020 讚！Jared A. Grauer - Real-Time Estimation of Bare-Airframe Frequency Responses from Closed-Loop Data and Multisine Inputs

numerator = {[-18.1 -36] [-18.1 -36]; [-0.38 -0.4 146] [-0.38 -0.4 146]}; 
denominator = [1 5.13 35.1];
sys = tf(numerator, denominator);

C21 = -0.2;                                                              % 回授的 gain 值
C11 = 0;