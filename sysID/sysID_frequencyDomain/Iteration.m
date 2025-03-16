N = 5;  % 迭代次數





u1w1 = input_chy(index(:,1),1);
u1w2 = input_chy(index(:,2),1);
u2w1 = input_chy(index(:,1),2);
u2w2 = input_chy(index(:,2),2);

% AM/PM 插補
for i=1:N

    H12w2_Am = abs(H12w2(:,i));                                                                  % H12w2 空心橘框
    H12w2_Phase = angle(H12w2(:,i));

    H12w1_Am  = interp1(w2,H12w2_Am,w1,'linear','extrap');                                  % H12w2 空心橘框 Am/Pm 線性插補出 H12w1 空心藍圓
    H12w1_Phase = interp1(w2,H12w2_Phase,w1,'linear','extrap');
    H12w1_com = H12w1_Am.*cos(H12w1_Phase)+H12w1_Am.*sin(H12w1_Phase)*1i;
    H11w1(:,i+1) = y1w1./u1w1-H12w1_com.*u2w1./u1w1;                                          % H11w1 實心藍圓  /////

    H11w1_new_Am = abs(H11w1(:,i+1));
    H11w1_new_Phase = angle(H11w1(:,i+1));
    H11w2_new_Am = interp1(w1,H11w1_new_Am,w2,'linear','extrap');                          % H11w1 實心藍圓  Am/Pm 線性插補出 H11w2 實心橘框
    H11w2_new_Phase = interp1(w1,H11w1_new_Phase,w2,'linear','extrap');
    H11w2(:,i+1) = H11w2_new_Am.*cos(H11w2_new_Phase)+H11w2_new_Am.*sin(H11w2_new_Phase)*1i;   % H11w2 實心橘框   //

    %------------------------------------

    H11w1_Am = abs(H11w1(:,i));                                                                  % H11w1 空心藍圓
    H11w1_Phase = angle(H11w1(:,i));

    H11w2_Am  = interp1(w1,H11w1_Am,w2,'linear','extrap');                                  % H11w1 空心藍圓 Am/Pm 線性插補出 H11w2 空心橘框
    H11w2_Phase = interp1(w1,H11w1_Phase,w2,'linear','extrap');
    H11w2_com = H11w2_Am.*cos(H11w2_Phase)+H11w2_Am.*sin(H11w2_Phase)*1i;
    H12w2(:,i+1) = y1w2./u2w2-H11w2_com.*u1w2./u2w2;                                           % H12w2 實心橘框  /////

    H12w2_new_Am = abs(H12w2(:,i+1));
    H12w2_new_Phase = angle(H12w2(:,i+1));
    H12w1_new_Am = interp1(w2,H12w2_new_Am,w1,'linear','extrap');                           % H12w2 實心橘框  Am/Pm 線性插補出 H12w1 實心藍圓
    H12w1_new_Phase = interp1(w2,H12w2_new_Phase,w1,'linear','extrap');
    H12w1(:,i+1) = H12w1_new_Am.*cos(H12w1_new_Phase)+H12w1_new_Am.*sin(H12w1_new_Phase)*1i;   % H12w1 實心藍圓  //

    %------------------------------------

    H22w2_Am = abs(H22w2(:,i));                                                                  % H22w2 空心橘框
    H22w2_Phase = angle(H22w2(:,i));

    H22w1_Am  = interp1(w2,H22w2_Am,w1,'linear','extrap');                                  % H22w2 空心橘框 Am/Pm 線性插補出 H22w1 空心藍圓
    H22w1_Phase = interp1(w2,H22w2_Phase,w1,'linear','extrap');

    H22w1_com = H22w1_Am.*cos(H22w1_Phase)+H22w1_Am.*sin(H22w1_Phase)*1i;
    H21w1(:,i+1) = y2w1./u1w1-H22w1_com.*u2w1./u1w1;                                          % H11w1 實心藍圓  /////

    H21w1_new_Am = abs(H21w1(:,i+1));
    H21w1_new_Phase = angle(H21w1(:,i+1));
    H21w2_new_Am = interp1(w1,H21w1_new_Am,w2,'linear','extrap');                          % H11w1 實心藍圓  Am/Pm 線性插補出 H11w2 實心橘框
    H21w2_new_Phase = interp1(w1,H21w1_new_Phase,w2,'linear','extrap');

    H21w2(:,i+1) = H21w2_new_Am.*cos(H21w2_new_Phase)+H21w2_new_Am.*sin(H21w2_new_Phase)*1i;   % H11w2 實心橘框   //

    %------------------------------------

    H21w1_Am = abs(H21w1(:,i));                                                                  % H11w1 空心藍圓
    H21w1_Phase = angle(H21w1(:,i));

    H21w2_Am  = interp1(w1,H21w1_Am,w2,'linear','extrap');                                  % H11w1 空心藍圓 Am/Pm 線性插補出 H11w2 空心橘框
    H21w2_Phase = interp1(w1,H21w1_Phase,w2,'linear','extrap');
    H21w2_com = H21w2_Am.*cos(H21w2_Phase)+H21w2_Am.*sin(H21w2_Phase)*1i;
    H22w2(:,i+1) = y2w2./u2w2-H21w2_com.*u1w2./u2w2;                                           % H12w2 實心橘框  /////

    H22w2_new_Am = abs(H22w2(:,i+1));
    H22w2_new_Phase = angle(H22w2(:,i+1));
    H22w1_new_Am = interp1(w2,H22w2_new_Am,w1,'linear','extrap');                           % H12w2 實心橘框  Am/Pm 線性插補出 H12w1 實心藍圓
    H22w1_new_Phase = interp1(w2,H22w2_new_Phase,w1,'linear','extrap');
    H22w1(:,i+1) = H22w1_new_Am.*cos(H22w1_new_Phase)+H22w1_new_Am.*sin(H22w1_new_Phase)*1i;   % H12w1 實心藍圓  //
end





h1 = figure('Name','Bode plot','NumberTitle','off','WindowState','maximized');
w1rad = w1*2*pi;
w2rad = w2*2*pi;
% -------------
% u1 --> y1
% -------------
subplot(4,2,1) % 振幅(dB)
semilogx(w1rad,mag2db(abs(H11w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,mag2db(abs(H11w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
ylabel('Mag. (dB)','FontSize',FontSize)
title('u1','FontWeight','bold','FontSize',FontSize)
xlim([1 10])
subplot(4,2,3) % 相位角(deg)
semilogx(w1rad,rad2deg(angle(H11w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,rad2deg(angle(H11w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
ylabel('Phase (deg)','FontSize',FontSize)
xlim([1 10])
% -------------
% u2 --> y1
% -------------
subplot(4,2,2) % 振幅(dB)
semilogx(w1rad,mag2db(abs(H12w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,mag2db(abs(H12w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
ylabel('Mag. (dB)','FontSize',FontSize)
title('u2','FontWeight','bold','FontSize',FontSize)
xlim([1 10])

subplot(4,2,4) % 相位角(deg)
semilogx(w1rad,rad2deg(angle(H12w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,rad2deg(angle(H12w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
% xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([1 10])
% -------------
% u1 --> y2
% -------------
subplot(4,2,5) % 振幅(dB)
semilogx(w1rad,mag2db(abs(H21w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,mag2db(abs(H21w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
ylabel('Mag. (dB)','FontSize',FontSize)
% title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
xlim([1 10])

subplot(4,2,7) % 相位角(deg)
semilogx(w1rad,rad2deg(angle(H21w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,rad2deg(angle(H21w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([1 10])
% -------------
% u2 --> y2
% -------------
subplot(4,2,6) % 振幅(dB)
semilogx(w1rad,mag2db(abs(H22w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,mag2db(abs(H22w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
ylabel('Mag. (dB)','FontSize',FontSize)
% title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
xlim([1 10])

subplot(4,2,8) % 相位角(deg)
semilogx(w1rad,rad2deg(angle(H22w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,rad2deg(angle(H22w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
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

%%
% load('D:\NDI\sysID\sysID_frequencyDomain\NDI_True_TVC2_h10000V617alpha2.mat')
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
semilogx(wout,mag2db(squeeze(mag(1,1,:))),'k')
hold on
semilogx(w1rad,mag2db(abs(H11w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
semilogx(w2rad,mag2db(abs(H11w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
ylabel('Mag. (dB)','FontSize',FontSize)
title('u1','FontWeight','bold','FontSize',FontSize)
xlim([1 10])

subplot(4,2,3) % 相位角(deg)
semilogx(wout,squeeze(phase(1,1,:)),'k')
hold on
semilogx(w1rad,rad2deg(angle(H11w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
semilogx(w2rad,rad2deg(angle(H11w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
% xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([1 10])
% -------------
% u2 --> y1
% -------------
subplot(4,2,2) % 振幅(dB)
semilogx(wout,mag2db(squeeze(mag(1,2,:))),'k')
hold on
semilogx(w1rad,mag2db(abs(H12w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
semilogx(w2rad,mag2db(abs(H12w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
ylabel('Mag. (dB)','FontSize',FontSize)
title('u2','FontWeight','bold','FontSize',FontSize)
xlim([1 10])

subplot(4,2,4) % 相位角(deg)
semilogx(wout,squeeze(phase(1,2,:)),'k')
hold on
semilogx(w1rad,rad2deg(angle(H12w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
semilogx(w2rad,rad2deg(angle(H12w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
% xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([1 10])
% -------------
% u1 --> y2
% -------------
subplot(4,2,5) % 振幅(dB)
semilogx(wout,mag2db(squeeze(mag(2,1,:))),'k')
hold on
semilogx(w1rad,mag2db(abs(H21w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
semilogx(w2rad,mag2db(abs(H21w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
ylabel('Mag. (dB)','FontSize',FontSize)
% title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
xlim([1 10])

subplot(4,2,7) % 相位角(deg)
semilogx(wout,squeeze(phase(2,1,:)),'k')
hold on
semilogx(w1rad,rad2deg(angle(H21w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
semilogx(w2rad,rad2deg(angle(H21w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([1 10])
% -------------
% u2 --> y2
% -------------
subplot(4,2,6) % 振幅(dB)
semilogx(wout,mag2db(squeeze(mag(2,2,:))),'k')
hold on
semilogx(w1rad,mag2db(abs(H22w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
semilogx(w2rad,mag2db(abs(H22w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
ylabel('Mag. (dB)','FontSize',FontSize)
% title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
xlim([1 10])

subplot(4,2,8) % 相位角(deg)
semilogx(wout,squeeze(phase(2,2,:)),'k')
hold on
semilogx(w1rad,rad2deg(angle(H22w1(:,N+1))),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
semilogx(w2rad,rad2deg(angle(H22w2(:,N+1))),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
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