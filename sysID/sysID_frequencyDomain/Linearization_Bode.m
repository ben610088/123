%% Computing operating points at simulation snapshots for the Simulink model - Linearization_20220419.
%
% This MATLAB script is the command line equivalent of the operating
% point snapshots tab in linear analysis tool with current snapshot times.
% It produces the exact same operating points as hitting the Take Snapshots button.

% 線性化過程可直接使用 "Model Linearizer" APP 操作

% Specify the model name
% model = 'Linearization_20220419';

% Run simulation to extract snapshots
% op = findop(model,1);

% Linearize the model
% sys = linearize(model,io,op);

% Plot the resulting linearization
% step(sys)



%% Plot the resulting linearization
FontSize = 11;
linsys = linsys1;

% 注意：
% 對於 MIMO 系統，bode()指令輸出的 mag 和 phase(deg) 是 3-D array，其維度(dimensions)為（輸出個數）×（輸入個數）×（頻率點個數）。注意：第一個維度是「輸出」。
% 例如：phase(i,j,k) 是指從第 j 個輸入到第 i 個輸出，在第 k 個頻率點上的相位角。
[mag,phase,wout] = bode(linsys);             % mag = 2x2x70                        , phase = 2x2x70                         , wout = 70x1
                                          % mag = 輸出個數 × 輸入個數 × 頻率點個數, phase = 輸出個數 × 輸入個數 × 頻率點個數, wout = 頻率點個數x1

% 註：可以自行指定頻率點個數、頻率範圍
% w = logspace(0,1,20);  
% [mag,phase,wout] = bode(H,w);


mag_new{1,1}   = squeeze(mag(1,1,:));
mag_new{1,2}   = squeeze(mag(1,2,:));
mag_new{2,1}   = squeeze(mag(2,1,:));
mag_new{2,2}   = squeeze(mag(2,2,:));
phase_new{1,1} = squeeze(phase(1,1,:));
phase_new{1,2} = squeeze(phase(1,2,:));
phase_new{2,1} = squeeze(phase(2,1,:));
phase_new{2,2} = squeeze(phase(2,2,:));

disp('---------------------')
disp('     u1 --> y1')
disp('---------------------')
[Gm,Pm,Wcg,Wcp] = margin(mag_new{1,1},phase_new{1,1},wout);
fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
disp('---------------------')
disp('     u2 --> y1')
disp('---------------------')
[Gm,Pm,Wcg,Wcp] = margin(mag_new{1,2},phase_new{1,2},wout);
fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
disp('---------------------')
disp('     u1 --> y2')
disp('---------------------')
[Gm,Pm,Wcg,Wcp] = margin(mag_new{2,1},phase_new{2,1},wout);
fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
disp('---------------------')
disp('     u2 --> y2')
disp('---------------------')
[Gm,Pm,Wcg,Wcp] = margin(mag_new{2,2},phase_new{2,2},wout);
fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)





h1 = figure('Name','Bode plot','NumberTitle','off','WindowState','maximized');
% -------------
% u1 --> y1
% -------------
subplot(4,2,1) % 振幅(dB)
semilogx(wout,mag2db(squeeze(mag(1,1,:))),'b')
ylabel('Mag. (dB)','FontSize',FontSize)
title('u1','FontWeight','bold','FontSize',FontSize)
xlim([1 10])

subplot(4,2,3) % 相位角(deg)
semilogx(wout,squeeze(phase(1,1,:)),'b')
% xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([1 10])
% -------------
% u2 --> y1
% -------------
subplot(4,2,2) % 振幅(dB)
semilogx(wout,mag2db(squeeze(mag(1,2,:))),'b')
ylabel('Mag. (dB)','FontSize',FontSize)
title('u2','FontWeight','bold','FontSize',FontSize)
xlim([1 10])

subplot(4,2,4) % 相位角(deg)
semilogx(wout,squeeze(phase(1,2,:)),'b')
% xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([1 10])
% -------------
% u1 --> y2
% -------------
subplot(4,2,5) % 振幅(dB)
semilogx(wout,mag2db(squeeze(mag(2,1,:))),'b')
ylabel('Mag. (dB)','FontSize',FontSize)
% title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
xlim([1 10])

subplot(4,2,7) % 相位角(deg)
semilogx(wout,squeeze(phase(2,1,:)),'b')
xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([1 10])
% -------------
% u2 --> y2
% -------------
subplot(4,2,6) % 振幅(dB)
semilogx(wout,mag2db(squeeze(mag(2,2,:))),'b')
ylabel('Mag. (dB)','FontSize',FontSize)
% title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
xlim([1 10])

subplot(4,2,8) % 相位角(deg)
semilogx(wout,squeeze(phase(2,2,:)),'b')
xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([1 10])
% -------------
% Create textbox
annotation(h1,'textbox',...
    [0.06303125 0.297225186766276 0.0262916666666666 0.0453133099557879],...
    'String','y2',...
    'FontWeight','bold',...
    'FitBoxToText','off',...
    'EdgeColor','none');

% Create textbox
annotation(h1,'textbox',...
    [0.06303125 0.71718249733191 0.0262916666666667 0.045313309955788],...
    'String','y1',...
    'FontWeight','bold',...
    'FitBoxToText','off',...
    'EdgeColor','none');
