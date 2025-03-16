cf1 = 0;                                                             % czt 初始頻率(Hz)
cf2 = 2;                                                             % czt 終止頻率(Hz)
m = 2000;                                                            % 取樣點數 (cf2-cf1)/m 必須整除....忘記為甚麼了
w0 = 1;                                                              % 螺旋曲率
a0 = 1;                                                              % 圓環半徑
FontSize = 11;                                                       % 圖的字體大小


w = w0 * exp(-1i*(2*pi*(cf2-cf1))/(m*fs));                           % 取樣點之間的比率
a = a0 * exp(1i*(2*pi*cf1)/fs);                                      % 取樣起點
frequency_interval = (cf2-cf1)/m;                                    % 頻率間隔
frequency = (cf1:frequency_interval :(cf2-frequency_interval ))';

%% 
index = [tx(:,1)*freqBase*m/(cf2-cf1)+1,tx(:,3)*freqBase*m/(cf2-cf1)+1];       % 取出諧波頻率的index = [ w1_index  w2_index ]
index = uint64(index); 
% ******************************
w1 = tx(:,1).*freqBase;
w2 = tx(:,3).*freqBase;
ww = [w1 w2];
% ******************************
%% CZT Inputs
input_chy = zeros(m , size(tx,2)/2);
for i = 1:size(tx,2)/2
    input_chy(:,i) = czt(sysIDInput.Data(:,i),m,w,a);                  % Chirp-Z Transform  
end

InputDataCZT = zeros(m ,size(tx,2));                                            
for i = 1:size(tx,2)/2                                                 % [ Am_u1   Phi_u1   Am_u2   Phi_u2 ... ]
    InputDataCZT(:,2*i-1) = abs(input_chy(:,i))./(L/2);
    InputDataCZT(:,2*i) = angle(input_chy(:,i));
end

figure(3)
tiledlayout(2,size(tx,2)/2);
for i = 1:size(tx,2)/2
    ax(i) = nexttile;
    plot(frequency,InputDataCZT(:,2*i-1),'b')                                        % CZT Amplitude 頻域圖
    hold on
    plot(frequency(index(:,1)),InputDataCZT(index(:,1),2*i-1),'x')
    ylabel(['|u' num2str(i) '|']);
    title(ax(i),['Chirp-Z Transform u' num2str(i)]);
end
for i = 1:size(tx,2)/2 
    ax(i+size(tx,2)) = nexttile;
    plot(frequency,rad2deg(InputDataCZT(:,2*i)),'b')                                          % CZT Phase 頻域圖
    hold on
    plot(w2,rad2deg(InputDataCZT(index(:,2),2*i)),'rx');
    xlabel('f (Hz)');
    ylabel('phase (deg)'); 
end 
%% CZT Outputs         
output_chy = zeros(m , size(tx,2)/2);
for i = 1:size(tx,2)/2
    output_chy(:,i) = czt(sysIDOutput.Data(:,i),m,w,a);                  % Chirp-Z Transform
end
OutputDataCZT = zeros(m ,size(tx,2));                                            
for i = 1:size(tx,2)/2                                                 % [ Am_y1   Phi_y1   Am_y2   Phi_y2 ... ]
    OutputDataCZT(:,2*i-1) = abs(output_chy(:,i))./(L/2);
    OutputDataCZT(:,2*i) = angle(output_chy(:,i));
end

figure(4)
tiledlayout(2,size(tx,2)/2);
for i = 1:size(tx,2)/2 
    ax(i) = nexttile;
    plot(frequency,OutputDataCZT(:,2*i-1),'b')                                        % CZT Amplitude 頻域圖
     hold on
    plot(frequency(index(:,1)),OutputDataCZT(index(:,1),2*i-1),'x')
    ylabel(['|y' num2str(i) '|']); 
    title(ax(i),['Chirp-Z Transform y' num2str(i)]);
end
for i = 1:size(tx,2)/2 
    ax(i+size(tx,2)) = nexttile;
    plot(frequency,rad2deg(OutputDataCZT(:,2*i)),'b')                                          % CZT Phase 頻域圖
    hold on
    plot(w2,rad2deg(OutputDataCZT(index(:,2),2*i)),'rx');
    xlabel('f (Hz)');
    ylabel('phase (deg)'); 
   
end
%%
% ------------------------
%       u1 --> y1
% ------------------------
h1 = figure('Name','Bode plot','NumberTitle','off','WindowState','maximized');
subplot(4,2,1)
semilogx((frequency(index(:,1)).*2*pi),mag2db(OutputDataCZT(index(:,1),1)./InputDataCZT(index(:,1),1)),'x');
ylabel('Magnitude (dB)','FontSize',FontSize)
title('u1','FontWeight','bold','FontSize',FontSize)
subplot(4,2,3)
semilogx((frequency(index(:,1)).*2*pi),rad2deg(OutputDataCZT(index(:,1),2)-InputDataCZT(index(:,1),2)),'x');
ylabel('Phase (deg)','FontSize',FontSize)
% ------------------------
%       u2 --> y1
% ------------------------
subplot(4,2,2)
semilogx((frequency(index(:,1)).*2*pi),mag2db(OutputDataCZT(index(:,1),3)./InputDataCZT(index(:,1),1)),'x');
ylabel('Magnitude (dB)','FontSize',FontSize)
title('u2','FontWeight','bold','FontSize',FontSize)
subplot(4,2,4)
semilogx((frequency(index(:,1)).*2*pi),rad2deg(OutputDataCZT(index(:,1),4)-InputDataCZT(index(:,1),2)),'x');
ylabel('Phase (deg)','FontSize',FontSize)
% ------------------------
%       u1 --> y2
% ------------------------
subplot(4,2,5)
semilogx((frequency(index(:,1)).*2*pi),mag2db(OutputDataCZT(index(:,1),1)./InputDataCZT(index(:,1),3)),'x');
ylabel('Magnitude (dB)','FontSize',FontSize)
subplot(4,2,7)
semilogx((frequency(index(:,1)).*2*pi),rad2deg(OutputDataCZT(index(:,1),2)-InputDataCZT(index(:,1),4)),'x');
ylabel('Phase (deg)','FontSize',FontSize)
% ------------------------
%       u2 --> y2
% ------------------------
subplot(4,2,6)
semilogx((frequency(index(:,1)).*2*pi),mag2db(OutputDataCZT(index(:,1),3)./InputDataCZT(index(:,1),3)),'x');
ylabel('Magnitude (dB)','FontSize',FontSize)
subplot(4,2,8)
semilogx((frequency(index(:,1)).*2*pi),rad2deg(OutputDataCZT(index(:,1),4)-InputDataCZT(index(:,1),4)),'x');
ylabel('Phase (deg)','FontSize',FontSize)

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

%% 線性化bode圖疊圖
% -------------
% u1 --> y1
% -------------
figure(5)
subplot(4,2,1) % 振幅(dB)
semilogx(wout,mag2db(squeeze(mag(1,1,:))),'b')
ylabel('Mag. (dB)','FontSize',FontSize)
title('u1','FontWeight','bold','FontSize',FontSize)
xlim([1 10])
hold on
semilogx((frequency(index(:,1)).*2*pi),mag2db(OutputDataCZT(index(:,1),1)./InputDataCZT(index(:,1),1)),'x');
ylabel('Magnitude (dB)','FontSize',FontSize)
legend('Linearization','CZT')

subplot(4,2,3) % 相位角(deg)
semilogx(wout,squeeze(phase(1,1,:)),'b')
% xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([1 10])
hold on
semilogx((frequency(index(:,1)).*2*pi),rad2deg(OutputDataCZT(index(:,1),2)-InputDataCZT(index(:,1),2)),'x');
ylabel('Phase (deg)','FontSize',FontSize)
% -------------
% u2 --> y1
% -------------
subplot(4,2,2) % 振幅(dB)
semilogx(wout,mag2db(squeeze(mag(1,2,:))),'b')
ylabel('Mag. (dB)','FontSize',FontSize)
title('u2','FontWeight','bold','FontSize',FontSize)
xlim([1 10])
hold on
semilogx((frequency(index(:,1)).*2*pi),mag2db(OutputDataCZT(index(:,1),3)./InputDataCZT(index(:,1),1)),'x');
ylabel('Magnitude (dB)','FontSize',FontSize)

subplot(4,2,4) % 相位角(deg)
semilogx(wout,squeeze(phase(1,2,:)),'b')
% xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([1 10])
hold on
semilogx((frequency(index(:,1)).*2*pi),rad2deg(OutputDataCZT(index(:,1),4)-InputDataCZT(index(:,1),2)),'x');
ylabel('Phase (deg)','FontSize',FontSize)
% -------------
% u1 --> y2
% -------------
subplot(4,2,5) % 振幅(dB)
semilogx(wout,mag2db(squeeze(mag(2,1,:))),'b')
ylabel('Mag. (dB)','FontSize',FontSize)
% title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
xlim([1 10])
hold on
semilogx((frequency(index(:,1)).*2*pi),mag2db(OutputDataCZT(index(:,1),1)./InputDataCZT(index(:,1),3)),'x');
ylabel('Magnitude (dB)','FontSize',FontSize)

subplot(4,2,7) % 相位角(deg)
semilogx(wout,squeeze(phase(2,1,:)),'b')
xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([1 10])
hold on
semilogx((frequency(index(:,1)).*2*pi),rad2deg(OutputDataCZT(index(:,1),2)-InputDataCZT(index(:,1),4)),'x');
ylabel('Phase (deg)','FontSize',FontSize)
% -------------
% u2 --> y2
% -------------
subplot(4,2,6) % 振幅(dB)
semilogx(wout,mag2db(squeeze(mag(2,2,:))),'b')
ylabel('Mag. (dB)','FontSize',FontSize)
% title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
xlim([1 10])
hold on
semilogx((frequency(index(:,1)).*2*pi),mag2db(OutputDataCZT(index(:,1),3)./InputDataCZT(index(:,1),3)),'x');
ylabel('Magnitude (dB)','FontSize',FontSize)

subplot(4,2,8) % 相位角(deg)
semilogx(wout,squeeze(phase(2,2,:)),'b')
xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([1 10])
hold on
semilogx((frequency(index(:,1)).*2*pi),rad2deg(OutputDataCZT(index(:,1),4)-InputDataCZT(index(:,1),4)),'x');
ylabel('Phase (deg)','FontSize',FontSize)