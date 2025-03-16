function RPF = objectiveFcn(phi,fs,T,t,k)
% phi 為目標函數的變數，也就是 RPF(phi)
uj = zeros(length(t),1);
for i=1:length(k)
    temp = sin( 2*pi*k(i)*t/T + phi(i));
    uj(:,1) = temp + uj(:,1);
end

RPF = (max(uj)-min(uj))/(2*sqrt(2)*rms(uj));
