wrap_case                                   = 'unwrap';                     % 可選'wrap','unwrap'
true_case                                   = 'true';                     % 可選'true','untrue'


switch test_case
    case 'sysID_longitudinal' % 2x2
        N=2;    % 線性插補切N等份
        i=1;    % 內插第i個點
        j=1;    % 外插第j個點
        u1w1 = diag(input_chy(index(:,1),1));
        u1w2 = diag(input_chy(index(:,2),1));
        u2w1 = diag(input_chy(index(:,1),2));
        u2w2 = diag(input_chy(index(:,2),2));
        y1w1 = output_chy(index(:,1),1);
        y1w2 = output_chy(index(:,2),1);
        y2w1 = output_chy(index(:,1),2);
        y2w2 = output_chy(index(:,2),2);
        y3w1 = output_chy(index(:,1),3);
        y3w2 = output_chy(index(:,2),3);
        y4w1 = output_chy(index(:,1),4);
        y4w2 = output_chy(index(:,2),4);

        n = size(u1w1,1);
        e = ones(n,1);
        A_1 = spdiags([0*e -1*e 0*e],-1:1,n,n);                            % -1 對角矩陣
        B2to1= spdiags([(1-j/N)*e (j/N)*e 0*e],-1:1,n,n);                  % w2 線性插補 w1
        B2to1(1) = 2-j/N;
        B2to1(1,2) =-(1-j/N);

        B1to2 = spdiags([0*e (1-j/N)*e j/N*e],-1:1,n,n);                   % w1 線性插補 w2
        B1to2(end) = 1+j/N;
        B1to2(end,end-1)=-j/N;
        zero=zeros(size(u1w1,1));
        A11 = [u1w1 zero zero zero u2w1 zero zero zero;
               zero u1w1 zero zero zero u2w1 zero zero;
               zero zero u1w1 zero zero zero u2w1 zero;
               zero zero zero u1w1 zero zero zero u2w1];
        A22 = [u1w2 zero zero zero u2w2 zero zero zero;
               zero u1w2 zero zero zero u2w2 zero zero;
               zero zero u1w2 zero zero zero u2w2 zero;
               zero zero zero u1w2 zero zero zero u2w2];

        A31 = [B1to2 zero zero zero zero zero zero zero;
               zero  zero zero zero A_1 zero zero zero];
        A32 = [A_1   zero zero zero zero zero zero zero;
               zero  zero zero zero B2to1 zero zero zero];
        A41 = [zero B1to2 zero zero zero zero zero zero;
               zero zero zero zero zero A_1 zero zero];
        A42 = [zero A_1 zero zero zero zero zero zero;
               zero zero zero zero zero B2to1 zero zero];
        A51 = [zero zero B1to2 zero zero zero zero zero;
               zero zero zero zero zero zero A_1 zero];
        A52 = [zero zero A_1 zero zero zero zero zero;
               zero zero zero zero zero zero B2to1 zero];
        A61 = [zero zero zero B1to2 zero zero zero zero;
            zero zero zero zero zero zero zero A_1];
        A62 = [zero zero zero A_1 zero zero zero zero;
            zero zero zero zero zero zero zero B2to1];

       
 
        zero1 = zeros(size(A11,1),size(A11,2));
        InterpMatrix = [A11 zero1;zero1 A22;A31 A32;A41 A42;A51 A52;A61 A62];
        % full(InterpMatrix)                                                % 可以列印出完整的矩陣
        temppppp = inv(InterpMatrix);                                       % 可以使用pinv()指令處理非方正矩陣

        b1 = [y1w1; y2w1; y3w1; y4w1];
        b2 = [y1w2; y2w2; y3w2; y4w2];
        zero2 = zeros(size(A31,1)+size(A41,1)+size(A51,1)+size(A61,1),1);
        b = [b1; b2;zero2];

        HMatrix = InterpMatrix\b;    % inv(InterpMatrix)*b
        hh = size(u1w1,1);
        H11w1 = HMatrix(     1:  hh);
        H21w1 = HMatrix(  hh+1:2*hh);
        H31w1 = HMatrix(2*hh+1:3*hh);
        H41w1 = HMatrix(3*hh+1:4*hh);
        H12w1 = HMatrix(4*hh+1:5*hh);
        H22w1 = HMatrix(5*hh+1:6*hh);
        H32w1 = HMatrix(6*hh+1:7*hh);
        H42w1 = HMatrix(7*hh+1:8*hh);

        H11w2 = HMatrix(8*hh+1:9*hh);
        H21w2 = HMatrix(9*hh+1:10*hh);
        H31w2 = HMatrix(10*hh+1:11*hh);
        H41w2 = HMatrix(11*hh+1:12*hh);
        H12w2 = HMatrix(12*hh+1:13*hh);
        H22w2 = HMatrix(13*hh+1:14*hh);
        H32w2 = HMatrix(14*hh+1:15*hh);
        H42w2 = HMatrix(15*hh+1:16*hh);

        % -------------------------------------------------------
        % 判斷兩相鄰相位角是否超越180度，若超過則判斷為有跳變點(即有wrap的意思)，故-2*pi使相位角unwrap
        % 註：選擇使用下方程式碼if…else…判斷式的原因是因為想做到Real time，想節省運算時間
        %     (因為印象中使用內建的 unwrap()指令後，還要記錄轉了N次2pi，再扣掉N次*2pi…好像還要用到除法!?
        %     硬體實現除法相較於減法複雜，所以會增加運算時間)：
        H11w1_rad =  angle(H11w1);
        H11w2_rad =  angle(H11w2);
        H21w1_rad =  angle(H21w1);
        H21w2_rad =  angle(H21w2);
        H31w1_rad =  angle(H31w1);
        H31w2_rad =  angle(H31w2);
        H41w1_rad =  angle(H41w1);
        H41w2_rad =  angle(H41w2);

        H12w1_rad =  angle(H12w1);
        H12w2_rad =  angle(H12w2);
        H22w1_rad =  angle(H22w1);
        H22w2_rad =  angle(H22w2);
        H32w1_rad =  angle(H32w1);
        H32w2_rad =  angle(H32w2);
        H42w1_rad =  angle(H42w1);
        H42w2_rad =  angle(H42w2);




        switch wrap_case
            case'unwrap'
                if H11w2_rad(1)-H11w1_rad(1) >pi
                    H11w2_rad(1) = H11w2_rad(1)- 2*pi;
                elseif H11w2_rad(1)-H11w1_rad(1) <(-1*pi)
                    H11w2_rad(1) = H11w2_rad(1)+ 2*pi;
                else
                end
                for i = 2 : length(w1)
                    if  H11w1_rad(i) - H11w1_rad(i-1) > pi                          % 可以改用diff()指令
                        H11w1_rad(i) = H11w1_rad(i) - 2*pi;
                    elseif H11w1_rad(i) - H11w1_rad(i-1) < (-1*pi)                  % 可以改用diff()指令
                        H11w1_rad(i) = H11w1_rad(i) + 2*pi;
                    else
                    end
                end
                for i = 2 : length(w1)
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
                for i = 2 : length(w1)
                    if  H12w1_rad(i) - H12w1_rad(i-1) > pi
                        H12w1_rad(i) = H12w1_rad(i) - 2*pi;
                    elseif H12w1_rad(i) - H12w1_rad(i-1) < (-1*pi)
                        H12w1_rad(i) = H12w1_rad(i) + 2*pi;
                    else
                    end
                end
                for i = 2 : length(w1)
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
                for i = 2 : length(w1)
                    if  H21w1_rad(i) - H21w1_rad(i-1) > pi
                        H21w1_rad(i) = H21w1_rad(i) - 2*pi;
                    elseif H21w1_rad(i) - H21w1_rad(i-1) < (-1*pi)
                        H21w1_rad(i) = H21w1_rad(i) + 2*pi;
                    else
                    end
                end
                for i = 2 : length(w1)
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
                for i = 2 : length(w1)
                    if  H22w1_rad(i) - H22w1_rad(i-1) > pi
                        H22w1_rad(i) = H22w1_rad(i) - 2*pi;
                    elseif H22w1_rad(i) - H22w1_rad(i-1) < (-1*pi)
                        H22w1_rad(i) = H22w1_rad(i) + 2*pi;
                    else
                    end
                end
                for i = 2 : length(w1)
                    if  H22w2_rad(i) - H22w2_rad(i-1) > pi
                        H22w2_rad(i) = H22w2_rad(i) - 2*pi;
                    elseif H22w2_rad(i) - H22w2_rad(i-1) < (-1*pi)
                        H22w2_rad(i) = H22w2_rad(i) + 2*pi;
                    else
                    end
                end

                if H31w2_rad(1)-H31w1_rad(1) >pi
                    H31w2_rad(1) = H31w2_rad(1)- 2*pi;
                elseif H31w2_rad(1)-H31w1_rad(1) <(-1*pi)
                    H31w2_rad(1) = H31w2_rad(1)+ 2*pi;
                else
                end
                for i = 2 : length(w1)
                    if  H31w1_rad(i) - H31w1_rad(i-1) > pi                          % 可以改用diff()指令
                        H31w1_rad(i) = H31w1_rad(i) - 2*pi;
                    elseif H31w1_rad(i) - H31w1_rad(i-1) < (-1*pi)                  % 可以改用diff()指令
                        H31w1_rad(i) = H31w1_rad(i) + 2*pi;
                    else
                    end
                end
                for i = 2 : length(w1)
                    if  H31w2_rad(i) - H31w2_rad(i-1) > pi
                        H31w2_rad(i) = H31w2_rad(i) - 2*pi;
                    elseif H31w2_rad(i) - H31w2_rad(i-1) < (-1*pi)
                        H31w2_rad(i) = H31w2_rad(i) + 2*pi;
                    else
                    end
                end

                if H32w2_rad(1)-H32w1_rad(1) >pi
                    H32w2_rad(1) = H32w2_rad(1)- 2*pi;
                elseif H32w2_rad(1)-H32w1_rad(1) <(-1*pi)
                    H32w2_rad(1) = H32w2_rad(1)+ 2*pi;
                else
                end
                for i = 2 : length(w1)
                    if  H32w1_rad(i) - H32w1_rad(i-1) > pi
                        H32w1_rad(i) = H32w1_rad(i) - 2*pi;
                    elseif H32w1_rad(i) - H32w1_rad(i-1) < (-1*pi)
                        H32w1_rad(i) = H32w1_rad(i) + 2*pi;
                    else
                    end
                end
                for i = 2 : length(w1)
                    if  H32w2_rad(i) - H32w2_rad(i-1) > pi
                        H32w2_rad(i) = H32w2_rad(i) - 2*pi;
                    elseif H32w2_rad(i) - H32w2_rad(i-1) < (-1*pi)
                        H32w2_rad(i) = H32w2_rad(i) + 2*pi;
                    else
                    end
                end

                if H41w2_rad(1)-H41w1_rad(1) >pi
                    H41w2_rad(1) = H41w2_rad(1)- 2*pi;
                elseif H41w2_rad(1)-H41w1_rad(1) <(-1*pi)
                    H41w2_rad(1) = H41w2_rad(1)+ 2*pi;
                else
                end
                for i = 2 : length(w1)
                    if  H41w1_rad(i) - H41w1_rad(i-1) > pi
                        H41w1_rad(i) = H41w1_rad(i) - 2*pi;
                    elseif H41w1_rad(i) - H41w1_rad(i-1) < (-1*pi)
                        H41w1_rad(i) = H41w1_rad(i) + 2*pi;
                    else
                    end
                end
                for i = 2 : length(w1)
                    if  H41w2_rad(i) - H41w2_rad(i-1) > pi
                        H41w2_rad(i) = H41w2_rad(i) - 2*pi;
                    elseif H41w2_rad(i) - H41w2_rad(i-1) < (-1*pi)
                        H41w2_rad(i) = H41w2_rad(i) + 2*pi;
                    else
                    end
                end


                if H42w2_rad(1)-H42w1_rad(1) >pi
                    H42w2_rad(1) = H42w2_rad(1)- 2*pi;
                elseif H42w2_rad(1)-H42w1_rad(1) <(-1*pi)
                    H42w2_rad(1) = H42w2_rad(1)+ 2*pi;
                else
                end
                for i = 2 : length(w1)
                    if  H42w1_rad(i) - H42w1_rad(i-1) > pi
                        H42w1_rad(i) = H42w1_rad(i) - 2*pi;
                    elseif H42w1_rad(i) - H42w1_rad(i-1) < (-1*pi)
                        H42w1_rad(i) = H42w1_rad(i) + 2*pi;
                    else
                    end
                end
                for i = 2 : length(w1)
                    if  H42w2_rad(i) - H42w2_rad(i-1) > pi
                        H42w2_rad(i) = H42w2_rad(i) - 2*pi;
                    elseif H42w2_rad(i) - H42w2_rad(i-1) < (-1*pi)
                        H42w2_rad(i) = H42w2_rad(i) + 2*pi;
                    else
                    end
                end








            case 'wrap'
        end
% ------------------------------------------------------------------------------------------
%                                     sysID_lateral
% ------------------------------------------------------------------------------------------
    case 'sysID_lateral' % 3x5
        u1w1 = diag(input_chy(index(:,1),1));
        u1w2 = diag(input_chy(index(:,2),1));
        u1w3 = diag(input_chy(index(:,3),1));
        u2w1 = diag(input_chy(index(:,1),2));
        u2w2 = diag(input_chy(index(:,2),2));
        u2w3 = diag(input_chy(index(:,3),2));
        u3w1 = diag(input_chy(index(:,1),3));
        u3w2 = diag(input_chy(index(:,2),3));
        u3w3 = diag(input_chy(index(:,3),3));

        y1w1=output_chy(index(:,1),1);
        y1w2=output_chy(index(:,2),1);
        y1w3=output_chy(index(:,3),1);
        y2w1=output_chy(index(:,1),2);
        y2w2=output_chy(index(:,2),2);
        y2w3=output_chy(index(:,3),2);
        y3w1=output_chy(index(:,1),3);
        y3w2=output_chy(index(:,2),3);
        y3w3=output_chy(index(:,3),3);
        y4w1=output_chy(index(:,1),4);
        y4w2=output_chy(index(:,2),4);
        y4w3=output_chy(index(:,3),4);
        y5w1=output_chy(index(:,1),5);
        y5w2=output_chy(index(:,2),5);
        y5w3=output_chy(index(:,3),5);

        n = size(u1w1,1);
        e = ones(n,1);
        A_1 = spdiags([0*e -1*e 0*e],-1:1,n,n);                  % -1 對角矩陣

        N=3;    % 線性插補切N等份
        i=1;    % 內插第i個點
        j=1;    % 外插第j個點

        B2to1 = spdiags([(1-j/N)*e (j/N)*e 0*e],-1:1,n,n);       % 外插前面
        B2to1(1) = 2-j/N;
        B2to1(1,2) =-(1-j/N);
        B1to2 = spdiags([0*e (1-j/N)*e j/N*e],-1:1,n,n);         % 外插後面
        B1to2(end) = 1+j/N;
        B1to2(end,end-1) = -j/N;

        first_B_staet = B2to1;                                   % 外插最前面第一個點的矩陣
        first_B_end   = B1to2;                                   % 外插最後面第一個點的矩陣

        N=3;    % 線性插補切N等份
        i=2;    % 內插第i個點
        j=2;    % 外插第j個點

        B2to1= spdiags([(1-j/N)*e (j/N)*e 0*e],-1:1,n,n);        % 外插前面
        B2to1(1) = 2-j/N;
        B2to1(1,2) =-(1-j/N);
        B1to2 = spdiags([0*e (1-j/N)*e j/N*e],-1:1,n,n);         % 外插後面
        B1to2(end) = 1+j/N;
        B1to2(end,end-1)=-j/N;

        second_B_start = B2to1;                                  % 外插最前面第二個點的矩陣
        second_B_end   = B1to2;                                  % 外插最後面第二個點的矩陣
        zero=zeros(size(u1w1,1));
        A11 = [u1w1 zero zero zero zero u2w1 zero zero zero zero u3w1 zero zero zero zero;
            zero u1w1 zero zero zero zero u2w1 zero zero zero zero u3w1 zero zero zero;
            zero zero u1w1 zero zero zero zero u2w1 zero zero zero zero u3w1 zero zero;
            zero zero zero u1w1 zero zero zero zero u2w1 zero zero zero zero u3w1 zero;
            zero zero zero zero u1w1 zero zero zero zero u2w1 zero zero zero zero u3w1];
        A22 = [u1w2 zero zero zero zero u2w2 zero zero zero zero u3w2 zero zero zero zero;
            zero u1w2 zero zero zero zero u2w2 zero zero zero zero u3w2 zero zero zero;
            zero zero u1w2 zero zero zero zero u2w2 zero zero zero zero u3w2 zero zero;
            zero zero zero u1w2 zero zero zero zero u2w2 zero zero zero zero u3w2 zero;
            zero zero zero zero u1w2 zero zero zero zero u2w2 zero zero zero zero u3w2];
        A33 = [u1w3 zero zero zero zero u2w3 zero zero zero zero u3w3 zero zero zero zero;
            zero u1w3 zero zero zero zero u2w3 zero zero zero zero u3w3 zero zero zero;
            zero zero u1w3 zero zero zero zero u2w3 zero zero zero zero u3w3 zero zero;
            zero zero zero u1w3 zero zero zero zero u2w3 zero zero zero zero u3w3 zero;
            zero zero zero zero u1w3 zero zero zero zero u2w3 zero zero zero zero u3w3];
        % --------------- H11 -- H21 -- H31 -- H41 -- H51 ------------ w1 to w2/w3
        A41 = [first_B_end       zero         zero         zero         zero         zero zero zero zero zero zero zero zero zero zero;
            second_B_end      zero         zero         zero         zero         zero zero zero zero zero zero zero zero zero zero;
            zero              first_B_end  zero         zero         zero         zero zero zero zero zero zero zero zero zero zero;
            zero              second_B_end zero         zero         zero         zero zero zero zero zero zero zero zero zero zero;
            zero              zero         first_B_end  zero         zero         zero zero zero zero zero zero zero zero zero zero;
            zero              zero         second_B_end zero         zero         zero zero zero zero zero zero zero zero zero zero;
            zero              zero         zero         first_B_end  zero         zero zero zero zero zero zero zero zero zero zero;
            zero              zero         zero         second_B_end zero         zero zero zero zero zero zero zero zero zero zero;
            zero              zero         zero         zero         first_B_end  zero zero zero zero zero zero zero zero zero zero;
            zero              zero         zero         zero         second_B_end zero zero zero zero zero zero zero zero zero zero];

        A42 = [A_1  zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero A_1  zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero A_1  zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero A_1  zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero A_1  zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero];

        A43 = [zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            A_1  zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero A_1  zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero A_1  zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero A_1  zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero A_1  zero zero zero zero zero zero zero zero zero zero];
        % --------------- H11 -- H21 -- H31 -- H41 -- H51 ------------ w2 to w1/w3
        A51 = [zero zero zero zero zero A_1 zero zero zero zero zero zero zero zero zero;
            zero  zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero A_1 zero zero zero zero zero zero zero zero;
            zero zero  zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero A_1 zero zero zero zero zero zero zero;
            zero zero zero  zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero A_1 zero zero zero zero zero zero;
            zero zero zero zero  zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero A_1 zero zero zero zero zero;
            zero zero zero zero zero  zero zero zero zero zero zero zero zero zero zero];

        A52 = [zero zero zero zero zero second_B_start zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero first_B_end zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero second_B_start zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero first_B_end zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero second_B_start zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero first_B_end zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero second_B_start zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero first_B_end zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero second_B_start zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero first_B_end zero zero zero zero zero];

        A53 = [zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero  zero zero zero zero A_1 zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero  zero zero zero zero A_1 zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero  zero zero zero zero A_1 zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero  zero zero zero zero A_1 zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero  zero zero zero zero A_1 zero zero zero zero zero];
        % --------------- H13 -- H23 -- H33 -- H43 -- H53 ------------ w3 to w1/w2

        A61 = [zero zero zero zero zero zero zero zero zero zero A_1  zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero A_1  zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero A_1  zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero A_1  zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero A_1 ;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero];
        A62 = [zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero A_1  zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero A_1  zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero A_1  zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero A_1  zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero;
            zero zero zero zero zero zero zero zero zero zero zero zero zero zero A_1];
        A63 = [zero zero zero zero zero zero zero zero zero zero first_B_staet  zero           zero           zero           zero;
            zero zero zero zero zero zero zero zero zero zero second_B_start zero           zero           zero           zero;
            zero zero zero zero zero zero zero zero zero zero zero           first_B_staet  zero           zero           zero;
            zero zero zero zero zero zero zero zero zero zero zero           second_B_start zero           zero           zero;
            zero zero zero zero zero zero zero zero zero zero zero           zero           first_B_staet  zero           zero;
            zero zero zero zero zero zero zero zero zero zero zero           zero           second_B_start zero           zero;
            zero zero zero zero zero zero zero zero zero zero zero           zero           zero           first_B_staet  zero;
            zero zero zero zero zero zero zero zero zero zero zero           zero           zero           second_B_start zero;
            zero zero zero zero zero zero zero zero zero zero zero           zero           zero           zero           first_B_staet;
            zero zero zero zero zero zero zero zero zero zero zero           zero           zero           zero           second_B_start];
        % -------------------------------------------------------------------------
        zero1 = zeros(size(A11,1),size(A11,2));
        InterpMatrix = [A11 zero1 zero1;zero1 A22 zero1;zero1 zero1 A33;A41 A42 A43;A51 A52 A53;A61 A62 A63];
        b1 = [y1w1; y2w1; y3w1 ;y4w1 ;y5w1];
        b2 = [y1w2; y2w2; y3w2 ;y4w2 ;y5w2];
        b3 = [y1w3; y2w3; y3w3 ;y4w3 ;y5w3];
        zero2 = zeros(size(A41,1)+size(A51,1)+size(A61,1),1);
        b = [b1; b2; b3; zero2];
        HMatrix = InterpMatrix\b;    % inv(InterpMatrix)*b
        hh = size(u1w1,1);
        H11w1 = HMatrix(     1:  hh);
        H21w1 = HMatrix(  hh+1:2*hh);
        H31w1 = HMatrix(2*hh+1:3*hh);
        H41w1 = HMatrix(3*hh+1:4*hh);
        H51w1 = HMatrix(4*hh+1:5*hh);
        H12w1 = HMatrix(5*hh+1:6*hh);
        H22w1 = HMatrix(6*hh+1:7*hh);
        H32w1 = HMatrix(7*hh+1:8*hh);
        H42w1 = HMatrix(8*hh+1:9*hh);
        H52w1 = HMatrix(9*hh+1:10*hh);
        H13w1 = HMatrix(10*hh+1:11*hh);
        H23w1 = HMatrix(11*hh+1:12*hh);
        H33w1 = HMatrix(12*hh+1:13*hh);
        H43w1 = HMatrix(13*hh+1:14*hh);
        H53w1 = HMatrix(14*hh+1:15*hh);

        H11w2 = HMatrix(15*hh+1:16*hh);
        H21w2 = HMatrix(16*hh+1:17*hh);
        H31w2 = HMatrix(17*hh+1:18*hh);
        H41w2 = HMatrix(18*hh+1:19*hh);
        H51w2 = HMatrix(19*hh+1:20*hh);
        H12w2 = HMatrix(20*hh+1:21*hh);
        H22w2 = HMatrix(21*hh+1:22*hh);
        H32w2 = HMatrix(22*hh+1:23*hh);
        H42w2 = HMatrix(23*hh+1:24*hh);
        H52w2 = HMatrix(24*hh+1:25*hh);
        H13w2 = HMatrix(25*hh+1:26*hh);
        H23w2 = HMatrix(26*hh+1:27*hh);
        H33w2 = HMatrix(27*hh+1:28*hh);
        H43w2 = HMatrix(28*hh+1:29*hh);
        H53w2 = HMatrix(29*hh+1:30*hh);

        H11w3 = HMatrix(30*hh+1:31*hh);
        H21w3 = HMatrix(31*hh+1:32*hh);
        H31w3 = HMatrix(32*hh+1:33*hh);
        H41w3 = HMatrix(33*hh+1:34*hh);
        H51w3 = HMatrix(34*hh+1:35*hh);
        H12w3 = HMatrix(35*hh+1:36*hh);
        H22w3 = HMatrix(36*hh+1:37*hh);
        H32w3 = HMatrix(37*hh+1:38*hh);
        H42w3 = HMatrix(38*hh+1:39*hh);
        H52w3 = HMatrix(39*hh+1:40*hh);
        H13w3 = HMatrix(40*hh+1:41*hh);
        H23w3 = HMatrix(41*hh+1:42*hh);
        H33w3 = HMatrix(42*hh+1:43*hh);
        H43w3 = HMatrix(43*hh+1:44*hh);
        H53w3 = HMatrix(44*hh+1:45*hh);
        % -------------------------------------------------------
        % 判斷兩相鄰相位角是否超越180度，若超過則判斷為有跳變點(即有wrap的意思)，故-2*pi使相位角unwrap
        % 註：選擇使用下方程式碼if…else…判斷式的原因是因為想做到Real time，想節省運算時間
        %     (因為印象中使用內建的 unwrap()指令後，還要記錄轉了N次2pi，再扣掉N次*2pi…好像還要用到除法!?
        %     硬體實現除法相較於減法複雜，所以會增加運算時間)：
        H11w1_rad =  angle(H11w1);
        H11w2_rad =  angle(H11w2);
        H11w3_rad =  angle(H11w3);
        H12w1_rad =  angle(H12w1);
        H12w2_rad =  angle(H12w2);
        H12w3_rad =  angle(H12w3);
        H13w1_rad =  angle(H13w1);
        H13w2_rad =  angle(H13w2);
        H13w3_rad =  angle(H13w3);

        H21w1_rad =  angle(H21w1);
        H21w2_rad =  angle(H21w2);
        H21w3_rad =  angle(H21w3);
        H22w1_rad =  angle(H22w1);
        H22w2_rad =  angle(H22w2);
        H22w3_rad =  angle(H22w3);
        H23w1_rad =  angle(H23w1);
        H23w2_rad =  angle(H23w2);
        H23w3_rad =  angle(H23w3);

        H31w1_rad =  angle(H31w1);
        H31w2_rad =  angle(H31w2);
        H31w3_rad =  angle(H31w3);
        H32w1_rad =  angle(H32w1);
        H32w2_rad =  angle(H32w2);
        H32w3_rad =  angle(H32w3);
        H33w1_rad =  angle(H33w1);
        H33w2_rad =  angle(H33w2);
        H33w3_rad =  angle(H33w3);

        H41w1_rad =  angle(H41w1);
        H41w2_rad =  angle(H41w2);
        H41w3_rad =  angle(H41w3);
        H42w1_rad =  angle(H42w1);
        H42w2_rad =  angle(H42w2);
        H42w3_rad =  angle(H42w3);
        H43w1_rad =  angle(H43w1);
        H43w2_rad =  angle(H43w2);
        H43w3_rad =  angle(H43w3);

        H51w1_rad =  angle(H51w1);
        H51w2_rad =  angle(H51w2);
        H51w3_rad =  angle(H51w3);
        H52w1_rad =  angle(H52w1);
        H52w2_rad =  angle(H52w2);
        H52w3_rad =  angle(H52w3);
        H53w1_rad =  unwrap(angle(H53w1));
        H53w2_rad =  unwrap(angle(H53w2));
        H53w3_rad =  unwrap(angle(H53w3));
end
run('response.m')