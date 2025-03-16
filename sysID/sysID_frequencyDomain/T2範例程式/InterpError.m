% interp.Magnitude&Phase
H21_w1_Am = abs(H21_w1);
H21_w1_Phi = angle(H21_w1);
% interp.Real&Imaginary
C_H12_w1  = interp1(w2,H12_w2,w1,'linear','extrap');
C_H11_w1 = output_chy(index(:,1),1)./input_chy(index(:,1),1)-C_H12_w1.*input_chy(index(:,1),2)./input_chy(index(:,1),1);
C_H12_w1_Am = abs(C_H12_w1);
C_H12_w1_Phi = angle(C_H12_w1);
C_H11_w1_Am = abs(C_H11_w1);
C_H11_w1_Phi = angle(C_H11_w1);

C_H22_w1 = interp1(w2,H22_w2,w1,'linear','extrap');
C_H21_w1 = output_chy(index(:,1),2)./input_chy(index(:,1),1)-C_H22_w1.*input_chy(index(:,1),2)./input_chy(index(:,1),1);
C_H22_w1_Am = abs(C_H22_w1);
C_H22_w1_Phi = angle(C_H22_w1);
C_H21_w1_Am = abs(C_H21_w1);
C_H21_w1_Phi = angle(C_H21_w1);

% Relative Error
% [           H11                  H12                   H21                   H22]
% |複數插植 振幅相位插補 誤差 ......                                                 
% |            .
% |            .
% |            .
% 誤差單位(mag/db)不影響結果
RelativeErrorAm = [C_H11_w1_Am H11_w1_Am (C_H11_w1_Am-H11_w1_Am)./H11_w1_Am...
                   C_H12_w1_Am H12_w1_Am (C_H12_w1_Am-H12_w1_Am)./H12_w1_Am...
                   C_H21_w1_Am H21_w1_Am (C_H21_w1_Am-H21_w1_Am)./H21_w1_Am...
                   C_H22_w1_Am H22_w1_Am (C_H22_w1_Am-H22_w1_Am)./H22_w1_Am];
RelativeErrorPhi = [C_H11_w1_Phi H11_w1_Phi (C_H11_w1_Phi-H11_w1_Phi)./H11_w1_Phi...
                   C_H12_w1_Phi H12_w1_Phi (C_H12_w1_Phi-H12_w1_Phi)./H12_w1_Phi...
                   C_H21_w1_Phi H21_w1_Phi (C_H21_w1_Phi-H21_w1_Phi)./H21_w1_Phi...
                   C_H22_w1_Phi H22_w1_Phi (C_H22_w1_Phi-H22_w1_Phi)./H22_w1_Phi];



