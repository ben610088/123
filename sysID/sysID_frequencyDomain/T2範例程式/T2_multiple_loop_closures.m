% 本程式適用於MATLAB R2019b之後的版本，因使用繪圖指令： tiledlayout (Create tiled chart layout)
FontSize = 20;

N=2;    % 線性插補切N等份
i=1;    % 內插第i個點
j=1;    % 外插第j個點
u1w1 = diag(input_chy(index(:,1),1));
u1w2 = diag(input_chy(index(:,2),1));
u2w1 = diag(input_chy(index(:,1),2));
u2w2 = diag(input_chy(index(:,2),2));
y1w1=output_chy(index(:,1),1);
y1w2=output_chy(index(:,2),1);
y2w1=output_chy(index(:,1),2);
y2w2=output_chy(index(:,2),2);

n = size(u1w1,1);
e = ones(n,1);
A_1 = spdiags([0*e -1*e 0*e],-1:1,n,n);                 % -1 對角矩陣
B2to1= spdiags([(1-j/N)*e (j/N)*e 0*e],-1:1,n,n);       % w2 線性插補 w1
B2to1(1) = 2-j/N;
B2to1(1,2) =-(1-j/N);

B1to2 = spdiags([0*e (1-j/N)*e j/N*e],-1:1,n,n);        % w1 線性插補 w2
B1to2(end) = 1+j/N;
B1to2(end,end-1)=-j/N;
zero=zeros(size(u1w1,1));
A11 = [u1w1 zero u2w1 zero;zero u1w1 zero u2w1];
A22 = [u1w2 zero u2w2 zero;zero u1w2 zero u2w2];
A31 = [B1to2 zero zero zero;zero zero A_1 zero];
A32 = [A_1 zero zero zero;zero zero B2to1 zero];
A41 = [zero B1to2 zero zero;zero zero zero A_1];
A42 = [zero A_1 zero zero;zero zero zero B2to1];

zero1 = zeros(size(A11,1),size(A11,2));
InterpMatrix = [A11 zero1;zero1 A22;A31 A32;A41 A42];
% full(InterpMatrix)                                    % 可以列印出完整的矩陣
temppppp = inv(InterpMatrix);                           % 可以使用pinv()指令處理非方正矩陣

b1 = [y1w1; y2w1];
b2 = [y1w2; y2w2];
zero2 = zeros(size(A31,1)+size(A41,1),1);
b = [b1; b2;zero2];

HMatrix = InterpMatrix\b;    % inv(InterpMatrix)*b
hh = size(u1w1,1);
H11w1 = HMatrix(     1:  hh);
H21w1 = HMatrix(  hh+1:2*hh);
H12w1 = HMatrix(2*hh+1:3*hh);
H22w1 = HMatrix(3*hh+1:4*hh);

H11w2 = HMatrix(4*hh+1:5*hh);
H21w2 = HMatrix(5*hh+1:6*hh);
H12w2 = HMatrix(6*hh+1:7*hh);
H22w2 = HMatrix(7*hh+1: end);

% -------------------------------------------------------
% 判斷兩相鄰相位角是否超越180度，若超過則判斷為有跳變點(即有wrap的意思)，故-2*pi使相位角unwrap
% 註：選擇使用下方程式碼if…else…判斷式的原因是因為想做到Real time，想節省運算時間
%     (因為印象中使用內建的 unwrap()指令後，還要記錄轉了N次2pi，再扣掉N次*2pi…好像還要用到除法!?
%     硬體實現除法相較於減法複雜，所以會增加運算時間)：
H11w1_rad =  angle(H11w1);
H11w2_rad =  angle(H11w2);
H12w1_rad =  angle(H12w1);
H12w2_rad =  angle(H12w2);
H21w1_rad =  angle(H21w1);
H21w2_rad =  angle(H21w2);
H22w1_rad =  angle(H22w1);
H22w2_rad =  angle(H22w2);


switch wrap_case
    case'unwrap'
        if H11w2_rad(1)-H11w1_rad(1) >pi
            H11w2_rad(1) = H11w2_rad(1)- 2*pi;
        elseif H11w2_rad(1)-H11w1_rad(1) <(-1*pi)
            H11w2_rad(1) = H11w2_rad(1)+ 2*pi;
        else
        end
        for i = 2 : 14
            if  H11w1_rad(i) - H11w1_rad(i-1) > pi                  % 可以改用diff()指令
                H11w1_rad(i) = H11w1_rad(i) - 2*pi;
            elseif H11w1_rad(i) - H11w1_rad(i-1) < (-1*pi)                  % 可以改用diff()指令
                H11w1_rad(i) = H11w1_rad(i) + 2*pi;
            else
            end
        end
        for i = 2 : 14
            if  H11w2_rad(i) - H11w2_rad(i-1) > pi
                H11w2_rad(i) = H11w2_rad(i) - 2*pi;
            elseif H11w2_rad(i) - H11w2_rad(i-1) < (-1*pi)
                H11w2_rad(i) = H11w2_rad(i) + 2*pi;
            else
            end
        end
        if H12w2_rad(1)-H11w1_rad(1) >pi
            H12w2_rad(1) = H12w2_rad(1)- 2*pi;
        elseif H12w2_rad(1)-H12w1_rad(1) <(-1*pi)
            H12w2_rad(1) = H12w2_rad(1)+ 2*pi;
        else
        end
        for i = 2 : 14
            if  H12w1_rad(i) - H12w1_rad(i-1) > pi
                H12w1_rad(i) = H12w1_rad(i) - 2*pi;
            elseif H12w1_rad(i) - H12w1_rad(i-1) < (-1*pi)
                H12w1_rad(i) = H12w1_rad(i) + 2*pi;
            else
            end
        end
        for i = 2 : 14
            if  H12w2_rad(i) - H12w2_rad(i-1) > pi
                H12w2_rad(i) = H12w2_rad(i) - 2*pi;
            elseif H12w2_rad(i) - H12w2_rad(i-1) < (-1*pi)
                H12w2_rad(i) = H12w2_rad(i) + 2*pi;
            else
            end
        end

        if H21w2_rad(1)-H21w1_rad(1) >pi
            H21w2_rad(1) = H21w2_rad(1)- 2*pi;
        elseif H21w2_rad(1)-H21w1_rad(1) <(-1*pi)
            H21w2_rad(1) = H21w2_rad(1)+ 2*pi;
        else
        end
        for i = 2 : 14
            if  H21w1_rad(i) - H21w1_rad(i-1) > pi
                H21w1_rad(i) = H21w1_rad(i) - 2*pi;
            elseif H21w1_rad(i) - H21w1_rad(i-1) < (-1*pi)
                H21w1_rad(i) = H21w1_rad(i) + 2*pi;
            else
            end
        end
        for i = 2 : 14
            if  H21w2_rad(i) - H21w2_rad(i-1) > pi
                H21w2_rad(i) = H21w2_rad(i) - 2*pi;
            elseif H21w2_rad(i) - H21w2_rad(i-1) < (-1*pi)
                H21w2_rad(i) = H21w2_rad(i) + 2*pi;
            else
            end
        end


        if H22w2_rad(1)-H22w1_rad(1) >pi
            H22w2_rad(1) = H22w2_rad(1)- 2*pi;
        elseif H22w2_rad(1)-H22w1_rad(1) <(-1*pi)
            H22w2_rad(1) = H22w2_rad(1)+ 2*pi;
        else
        end
        for i = 2 : 14
            if  H22w1_rad(i) - H22w1_rad(i-1) > pi
                H22w1_rad(i) = H22w1_rad(i) - 2*pi;
            elseif H22w1_rad(i) - H22w1_rad(i-1) < (-1*pi)
                H22w1_rad(i) = H22w1_rad(i) + 2*pi;
            else
            end
        end
        for i = 2 : 14
            if  H22w2_rad(i) - H22w2_rad(i-1) > pi
                H22w2_rad(i) = H22w2_rad(i) - 2*pi;
            elseif H22w2_rad(i) - H22w2_rad(i-1) < (-1*pi)
                H22w2_rad(i) = H22w2_rad(i) + 2*pi;
            else
            end
        end
    case 'wrap'
        % do nothing
    otherwise
        % do nothing
        opts = struct('WindowStyle','non-modal',... 
                      'Interpreter','tex');
        warndlg('\fontsize{14} 檢查 wrap\_case 是否打錯字','Warning',opts);
        warning('檢查 wrap_case 是否打錯字')
end

% -------------------------------------------------------
figure('units','normalized','outerposition',[0 0 1 1])
% set(gcf,'Position',get(0,'ScreenSize'))

set(gcf,'WindowState','maximized');
% 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
t = tiledlayout(4,2,'TileSpacing','Compact','Padding','Compact');
w1rad = w1*2*pi;
w2rad = w2*2*pi;

ax1 = nexttile;
semilogx(w1rad,mag2db(abs(H11w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,mag2db(abs(H11w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
ylabel('Mag. (dB)','FontSize',FontSize)
title('\delta_e_o ','FontWeight','bold','FontSize',FontSize)
xlim([min(w1rad) max(w2rad)])
set(ax1,'Fontsize',20);

ax2 = nexttile;
semilogx(w1rad,mag2db(abs(H12w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,mag2db(abs(H12w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
title('\delta_e_i ','FontWeight','bold','FontSize',FontSize)
xlim([min(w1rad) max(w2rad)])
set(ax2,'Fontsize',20);

ax3 = nexttile;
semilogx(w1rad,rad2deg(H11w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,rad2deg(H11w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
ylabel('Phase (deg)')
xlim([min(w1rad) max(w2rad)])
set(ax3,'Fontsize',20);

ax4 = nexttile;
semilogx(w1rad,rad2deg(H12w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,rad2deg(H12w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
xlim([min(w1rad) max(w2rad)])
set(ax4,'Fontsize',20);

ax5 = nexttile;
semilogx(w1rad,mag2db(abs(H21w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,mag2db(abs(H21w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
ylabel('Mag. (dB)','FontSize',FontSize)
% title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
xlim([min(w1rad) max(w2rad)])
set(ax5,'Fontsize',20);

ax6 = nexttile;
semilogx(w1rad,mag2db(abs(H22w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,mag2db(abs(H22w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
xlim([min(w1rad) max(w2rad)])
set(ax6,'Fontsize',20);

ax7 = nexttile;
semilogx(w1rad,rad2deg(H21w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,rad2deg(H21w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([min(w1rad) max(w2rad)])
set(ax7,'Fontsize',20);

ax8 = nexttile;
semilogx(w1rad,rad2deg(H22w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
grid on
hold on
semilogx(w2rad,rad2deg(H22w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
xlim([min(w1rad) max(w2rad)])
set(ax8,'Fontsize',20);

xticklabels(ax1,{})
xticklabels(ax2,{})
xticklabels(ax3,{})
xticklabels(ax4,{})
xticklabels(ax5,{})
xticklabels(ax6,{})
t.YLabel.String = '\ita_z                                                      \itq';
t.YLabel.FontSize = 20;
t.YLabel.FontWeight = 'bold';

switch true_case
    case 'true'

        %Plot the resulting linearization 修正後頻率響應圖與 true(黑線) 的比較
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

        % 為了繪圖好看，統一修正True(黑線)，Phase若大於0度則減360度，進行相位下移。此舉不會影響GM、PM判斷
        if all(phase_new{1,1}>0)
            phase_new{1,1}=phase_new{1,1}-360;
        end
        if all(phase_new{1,2}>0)
            phase_new{1,2}=phase_new{1,2}-360;
        end
        if all(phase_new{2,1}>0)
            phase_new{2,1}=phase_new{2,1}-360;
        end
        if all(phase_new{2,2}>0)
            phase_new{2,2}=phase_new{2,2}-360;
        end

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


        figure('units','normalized','outerposition',[0 0 1 1])
        % set(gcf,'Position',get(0,'ScreenSize'))

        set(gcf,'WindowState','maximized');
        % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
        t = tiledlayout(4,2,'TileSpacing','Compact','Padding','Compact');
        w1rad = w1*2*pi;
        w2rad = w2*2*pi;

        ax1 = nexttile;
        semilogx(wout,mag2db(squeeze(mag(1,1,:))),'k')
        hold on
        semilogx(w1rad,mag2db(abs(H11w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H11w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('\delta_e_o ','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax1,'Fontsize',20);

        ax2 = nexttile;
        semilogx(wout,mag2db(squeeze(mag(1,2,:))),'k')
        hold on
        semilogx(w1rad,mag2db(abs(H12w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H12w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        title('\delta_e_i ','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax2,'Fontsize',20);

        ax3 = nexttile;
        semilogx(wout,phase_new{1,1},'k')
        hold on
        semilogx(w1rad,rad2deg(H11w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H11w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Phase (deg)')
        xlim([min(w1rad) max(w2rad)])
        set(ax3,'Fontsize',20);

        ax4 = nexttile;
        semilogx(wout,phase_new{1,2},'k')
        hold on
        semilogx(w1rad,rad2deg(H12w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H12w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        xlim([min(w1rad) max(w2rad)])
        set(ax4,'Fontsize',20);

        ax5 = nexttile;
        semilogx(wout,mag2db(squeeze(mag(2,1,:))),'k')
        hold on
        semilogx(w1rad,mag2db(abs(H21w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H21w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        % title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax5,'Fontsize',20);

        ax6 = nexttile;
        semilogx(wout,mag2db(squeeze(mag(2,2,:))),'k')
        hold on
        semilogx(w1rad,mag2db(abs(H22w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H22w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        xlim([min(w1rad) max(w2rad)])
        set(ax6,'Fontsize',20);

        ax7 = nexttile;
        semilogx(wout,phase_new{2,1},'k')
        hold on
        semilogx(w1rad,rad2deg(H21w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H21w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax7,'Fontsize',20);

        ax8 = nexttile;
        semilogx(wout,phase_new{2,2},'k')
        hold on
        semilogx(w1rad,rad2deg(H22w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H22w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax8,'Fontsize',20);

        xticklabels(ax1,{})
        xticklabels(ax2,{})
        xticklabels(ax3,{})
        xticklabels(ax4,{})
        xticklabels(ax5,{})
        xticklabels(ax6,{})
        t.YLabel.String = '\ita_z                                                      \itq';
        t.YLabel.FontSize = 20;
        t.YLabel.FontWeight = 'bold';

    case 'untrue'
end