function u = DA_Allocation(IN_MAT)
% Make single input, single output version of Direct Allocation for use in
% Simulink via the MATLAB Fcn block

% IN_MAT = 1-3  [B       d           前面數字代表所佔列數
%            4   upast   dt
%            5   Umax'   0
%            6   Umin'   0
%            7   DUmax'  0
%            8   DUmin'  0
%            9   INDX    LPmethod 無用，已廢棄
%         10~18  N       0        ] 18*10

[k2,m1] = size(IN_MAT);
m = m1-1;
k = k2-(m+6); %這邊矩陣IN_MAT的列與行分別要減掉(m+3)和1，求取B矩陣的行與列
%這個步驟主要是將原先在MakeINMAT模塊中組成的IN_MAT做劃分
    B = IN_MAT(1:k,1:m);          % 3*9
    v = IN_MAT(1:k,end);          % 3*1
u_max = IN_MAT(k+2,1:m)';         % 1*9
u_min = IN_MAT(k+3,1:m)';         % 1*9


 

switch m
    case 9
        %do nothing
    case 7
        %do nothing
%       B(2,5) = 0.000001;  B(2,6) = 0.000001;  
        B(1,7) = 0.000001;  B(3,7) = 0.000001;
    case 5
        % 五個控制面時，由於B矩陣中容易出現RANK1的平面，導致直接幾何法無法順利的找到平面，因此在B矩陣加入微擾項。
%         B(2,1) = 0.000001; B(1,2) = 0.000001; B(3,2) = 0.000001; B(2,3) = 0.000001; B(2,4) = 0.000001; B(1,5) = 0.000001; B(3,5) = 0.000001;
          B(1,2) = 0.000001; B(3,2) = 0.000001; B(1,5) = 0.000001; B(3,5) = 0.000001;
end

[u,a,count,BTrow,mat_max,uall_max] = da_attain(B,v,u_min,u_max); %by豪  透過function 對期望力矩進行直接配置法

%KAB mod of files from MC Cotting
    function [u_final, mom_attain,count,BTrow,mat_max,uall_max]  = da_attain (B,v,umin,umax)
        
        cmom(1) = v(1);
        cmom(2) = v(2);
        cmom(3) = v(3);
        
        [nrow,ncol]=size(B);
        num_eff=ncol;
        num = 1;
        % for迴圈中列出所有的控制偏轉組合(從九個控制面中選出兩個控制面ui,uj)
        for i=1:num_eff-1
            for j=i+1:num_eff
                u_1(num) = i;
                u_2(num) = j;
                num = num + 1;
            end
        end
        % Determine a non-singular 2x2 partition of the control eff. matrix
        % using the facet-defining controls
        
        %尋找一個旋轉矩T陣使得ui,uj所產生的平面垂直於L軸
        allocated = 0;   % 1 = TRUE, 0 = Not yet...
        limit     = 1;
        Attain_mom = [];
        u_allo = []; U_final = [];  mom_attain = [];
        kij=[0 3 2;0 0 1];
        while limit <= num -1
            u1 = u_1(limit);
            u2 = u_2(limit);
            for i = 1:2
                for j=i+1:3
                    A(1,1) = B(i,u1);
                    A(1,2) = B(j,u1);
                    A(2,1) = B(i,u2);
                    A(2,2) = B(j,u2);
                    A_det = det(A);
                    if A_det == 0.0
%                         warnstring = 'Redundant controls, cannot allocate';
                    elseif A_det ~= 0.0
                        break
                    end
                end
                if A_det ~= 0.0
                    break
                end
            end
            
            k=kij(i,j);
            A_inv = inv(A);
            tr1(i) = -(A_inv(1,1)*B(k,u1) + A_inv(1,2)*B(k,u2));
            tr1(j) = -(A_inv(2,1)*B(k,u1) + A_inv(2,2)*B(k,u2));
            tr1(k) = 1.0;
            for k = 1:num_eff
                BTrow(k) = tr1(1)*B(1,k) + tr1(2)*B(2,k) + tr1(3)*B(3,k);
            end
            
            % BTrow should have 0 entries corresponding to controls u1 and u2.
            % The signs of the other entries determine whether they are a maximum
            % or minimum on the given face.  If other entries are zero, we have
            % to guess whether they are are min or max.  Introduce a new system
            % of classification where 0 == min deflection, 1 == max deflection,
            % and 2 == somewhere in between...
            
            count = 0;
            i_min(u1) = 2;
            i_min(u2) = 2;
            i_max(u1) = 2;
            i_max(u2) = 2;
            integer = [];
            uall_min = zeros(1,k);
            uall_max = zeros(1,k);
            for k=1:num_eff
                if (k ~= u1) && (k ~= u2)  % KAB 21092013
                    if BTrow(k) > 0+eps
                        uall_min(k) = umin(k);
                        uall_max(k) = umax(k);
                        i_min(k) = 0;
                        i_max(k) = 1;
                    elseif BTrow(k) < 0-eps
                        uall_min(k) = umax(k);
                        uall_max(k) = umin(k);
                        i_min(k) = 1;
                        i_max(k) = 0;
                    else
                        i_min(k) = 2;
                        i_max(k) = 2;
                        count = count +1;
                        integer(count) = k;
                    end
                end
            end
            
            % Now try to guess "special controls" by trial and error.  For ease
            % of calculation, assume only a "small" delta in BTrow so that the
            % control entries for u1 and u2 become positive
            
            %      if count > 0
            %         for i= 1:count
            %             u_min(integer(i)) = umin(integer(i));
            %             u_max(integer(i)) = umax(integer(i));
            %             i_min(integer(i)) = 0;
            %             i_max(integer(i)) = 1;
            %         end
            %     end
            
            % Call the sub-function MATRIX.M to determine the facet verticies.
            [mat_max] = da_matrix (num_eff, B, uall_max, u1, u2, umin, umax);
            [mat_min] = da_matrix (num_eff, B, uall_min, u1, u2, umin, umax);
            
            % Call the sub-function DIRALLO.M to check the current facet and
            % allocate controls if possible.  If this facet cannot be used for
            % allocation (i.e. the condition with allo_flag = 0), then check
            % opposite facet.
            
            [u_allo, flag_max, i_status, Max_mom] = da_dirallo(num_eff, B, u1, u2 ,mat_max, umin, umax,i_max, cmom, integer);
            
            
            if flag_max == 1
                U_final = u_allo;
                Attain_mom = Max_mom;
            else
                [u_allo, flag_min, i_status, Max_mom] = da_dirallo(num_eff, B, u1, u2 ,mat_min, umin, umax, i_min, cmom, integer);
                
                if flag_min == 1
                    U_final = u_allo;
                    Attain_mom = Max_mom;
                    min_flag=1;
                end
            end
            
            limit = limit + 1;   % Increase iteration counter
            if ~isempty(Attain_mom) && ~isempty(U_final)
                mom_attain = Attain_mom;
                u_final = U_final;
                allocated = 1;
                % KAB 21092013
                break
                % KAB 21092013
            end
        end
        if allocated ~= 1
            u_final = [];
            mom_attain = [];
        end                
          u_final;
          mom_attain;
    end

    function [ X_mat ] = da_matrix (m ,B ,uall_X, u1, u2, umin, umax)
        
        % Form a 3x3 matrix in moment space so that the facets determined can
        % be used to allocate controls.  This matrix consists of columns
        % corresponding to the facet vertex vector (referenced from the
        % origin, origin), and the two facet edge vectors (referenced from the
        % vertex) .
        
        % Initialize the four verticies defining the facet and the base-2
        % control vector.
        
        %透過輸入至da_matrix副程式的"B"矩陣與"uall_X"(BTrow非零元素所對應的控制面於可達集邊界時的偏轉位置)來建立殼達集的其中一個表面
        %計算表面的三個頂點，根據一頂點以及頂點和其他兩個頂點連接的邊組成一個3X3的"X_mat"矩陣
        Cl_mom = zeros(1,3);
        Cm_mom = zeros(1,3);
        Cn_mom = zeros(1,3);
        U      = uall_X;
        
        %第一個頂點(ui,uj都位於最小值)
        U(u1) = umin(u1);
        U(u2) = umin(u2);
        for i = 1:3
            for j=1:m
                Cl_mom(i) = Cl_mom(i) + B(i,j)*U(j);
            end
        end
        
        %第二個頂點(ui位於最小值,uj都位於最大值)
        U(u1) = umin(u1);
        U(u2) = umax(u2);
        for i = 1:3
            for j=1:m
                Cm_mom(i) = Cm_mom(i) + B(i,j)*U(j);
            end
        end
        
        %第二個頂點(ui位於最大值,uj都位於最小值)
        U(u1) = umax(u1);
        U(u2) = umin(u2);
        for i = 1:3
            for j=1:m
                Cn_mom(i) = Cn_mom(i) + B(i,j)*U(j);
            end
        end
        
        
        for j = 1:3
            % Construct the matrix where Column 1 is the vector from the origin to
            % the vertex 0 (both U(u1) and U(u2) are fixed at their minimums),
            % Column 2 is the vector from vertex #0 to the vertex #2 (where U(u1)
            % is the varying control), and Column 3 is the vector from vertex #0 to
            % vertex #1 (where U(u2) is the varying control)
            
            X_mat(j,1) = Cl_mom(j);
            X_mat(j,2) = Cn_mom(j) - Cl_mom(j);
            X_mat(j,3) = Cm_mom(j) - Cl_mom(j);            
        end        
    end

    function [X_uallo, X_flag, istatus, Xmom_max] = da_dirallo(m, B, u1, u2, mat_X, umin, umax, ifac_X, X_mom, integer)
        % This subfunction is the actual direct allocation implementation.  It
        % requires the control effectiveness matrix, min/max control position
        % limits, the number of controls, and the previously determined facet
        % geometry.  To perform allocation certain requirements must be met.
        % These are presented below.
        
        X_uallo = [];
        Xmom_max = [];
%         X_uallo = zeros(9,1);
%         Xmom_max = zeros(3,1);
        
        X_flag = 0;        % Allocation flag 0,1   1 == TRUE
        istatus = 0;
        mat_det = det(mat_X);
        mat_X1 = mat_X; mat_X2 = mat_X; mat_X3 = mat_X;
        size_integer = size(integer,2);
        %未滑動平面
        mat_inv1 = inv(mat_X1);
        %沿u_k正方向滑動平面
        for i = 1:size_integer
            mat_X2(:,1) = mat_X2(:,1)+B(:,integer(i))*umax(integer(i));
        end
        mat_inv2 = inv(mat_X2);
        %沿u_k負方向滑動平面
        for i = 1:size_integer
            mat_X3(:,1) = mat_X3(:,1)+B(:,integer(i))*umin(integer(i));
        end
        mat_inv3 = inv(mat_X3);
        
        
        % This section allocates the controls provided that the determinant of
        % the matrix containging the facet geometry (mat_X) is not zero.
        
        % if mat_det ~= 0.0    % desired condition
        if abs(mat_det) > eps    % desired condition KAB Mod Never hitting else condition
            %未滑動平面      %沿u_k正方向滑動平面    %沿u_k負方向滑動平面
            c1_1 = 0.0;     c1_2 = 0.0;            c1_3 = 0.0;
            c2_1 = 0.0;     c2_2 = 0.0;            c2_3 = 0.0;
            c3_1 = 0.0;     c3_2 = 0.0;            c3_3 = 0.0;
            
            for i = 1:3  %未滑動平面
                c1_1 = c1_1 + mat_inv1(1,i)*X_mom(i);
                c2_1 = c2_1 + mat_inv1(2,i)*X_mom(i);
                c3_1 = c3_1 + mat_inv1(3,i)*X_mom(i);
            end
            for i = 1:3  %沿u_k正方向滑動平面
                c1_2 = c1_2 + mat_inv2(1,i)*X_mom(i);
                c2_2 = c2_2 + mat_inv2(2,i)*X_mom(i);
                c3_2 = c3_2 + mat_inv2(3,i)*X_mom(i);
            end
            for i = 1:3  %沿u_k負方向滑動平面
                c1_3 = c1_3 + mat_inv3(1,i)*X_mom(i);
                c2_3 = c2_3 + mat_inv3(2,i)*X_mom(i);
                c3_3 = c3_3 + mat_inv3(3,i)*X_mom(i);
            end
            c = [c1_1   c1_2   c1_3 ;
                  c2_1   c2_2   c2_3 ;
                  c3_1   c3_2   c3_3 ];
            %Test the value of c1.  If it is zero, then allocation cannot
            %continue, if it is greater than zero, allocation proceeds, if it is
            %less than or equal to zero then there is negative saturation.
            if c1_1 == 0.0
                istatus = -1;   %Moment is parallet to the facet
                return
            end
            if c1_1 > 0.0
                %未滑動平面
                c2_1 = c2_1/c1_1;
                c3_1 = c3_1/c1_1;
                if c1_1 > 1.0
                    c1_1 = 1.0;
                end
                %沿u_k正方向滑動平面
                c2_2 = c2_2/c1_2;
                c3_2 = c3_2/c1_2;
                if c1_2 > 1.0
                    c1_2 = 1.0;
                end
                %沿u_k負方向滑動平面
                c2_3 = c2_3/c1_3;
                c3_3 = c3_3/c1_3;
                if c1_3 > 1.0
                    c1_3 = 1.0;
                end
                
                %         if (c2 >= 0.0) & (c3 >= 0.0) & (c2 <=1.0) & (c3 <= 1.0)
                % KAB Mod: add eps, because algorithm not finding solution if moment is
                % pointed add edge (==1 or ==0 were off by a small precision error)
                if (c2_1 >= 0.0-eps) && (c3_1 >= 0.0-eps) && (c2_1 <=1.0+eps) && (c3_1 <= 1.0+eps)     %未滑動平面
                    istatus = 0;      % Everything is good
                    %              for i = 1:size_integer
                    %               ifac_X(integer(i)) = 2;
                    %              end
                    [X_uallo, Xmom_max] = da_allocate (m, B, u1, u2, ifac_X, c1_1, c2_1, c3_1, umin, umax);
                    X_flag = 1;
                    allo1=1  ;% KILL ME!!
                    
                elseif (c2_2 >= 0.0-eps) && (c3_2 >= 0.0-eps) && (c2_2 <=1.0+eps) && (c3_2 <= 1.0+eps)  %沿u_k正方向滑動平面
                    istatus = 0;      % Everything is good
                    for i = 1:size_integer
                        ifac_X(integer(i)) = 1;
                    end
                    [X_uallo, Xmom_max] = da_allocate (m, B, u1, u2, ifac_X, c1_2, c2_2, c3_2, umin, umax);
                    X_flag = 1;
                    allo1=1  ;% KILL ME!!
                    
                elseif (c2_3 >= 0.0-eps) && (c3_3 >= 0.0-eps) && (c2_3 <=1.0+eps) && (c3_3 <= 1.0+eps)  %沿u_k負方向滑動平面
                    istatus = 0;      % Everything is good
                    for i = 1:size_integer
                        ifac_X(integer(i)) = 0;
                    end
                    [X_uallo, Xmom_max] = da_allocate (m, B, u1, u2, ifac_X, c1_3, c2_3, c3_3, umin, umax);
                    X_flag = 1;
                    allo1=1  ;% KILL ME!!
                    
                else
                    istatus = 6;      % Everything is ok, just have the wrong facet
                end
            else                  % if c1 <= 0.0
                istatus = 7;        % negative saturation (a bad thing...)
            end
%             c2 = [c1_1   c1_2   c1_3 ;
%                   c2_1   c2_2   c2_3 ;
%                   c3_1   c3_2   c3_3 ];
%             c = [c1 c2];
            %  This section tests to see if the origin is on the boundary, or if
            %  the edges in question are parallel.  If the origin is on the
            %  boundary, the moment may be as well and allocation is still
            %  possible.  If the edges are parallel, allocation of hte defining
            %  controls is possible.
            
            % elseif mat_det == 0
        else %KAB Mod
            %     A2(1,1) = mat_X(1,2);
            %     A2(1,2) = mat_X(1,3);
            %     A2(2,1) = mat_X(2,2);
            %     A2(2,2) = mat_X(2,3);
            %     A2_det = det(A2);
            %     if A2_det == 0          % Co-linear edges, cannot allocate
            %         return
            %     end
            %
            %     % Found a non-singular 2x2 partition of a geometry matrix, proceed
            %     % with tests
            %
            %     %     i = 0;
            %     %     j = 1;
            %     %     k = 2;
            %     % KAB I think the above was from C-code, Matlab does not index 0-2
            %     i = 1;
            %     j = 2;
            %     k = 3;
            %
            %     A2_inv = inv(A2);
            %
            %     % Determine if the defining vertex (ie column 1 of mat_X) is in the
            %     % place of the facet being studied.
            %
            %     c2_1 = -(A2_inv(1,1)*mat_X(i,1) + A2_inv(1,2)*mat_X(j,1));
            %     c3_1 = -(A2_inv(2,1)*mat_X(i,1) + A2_inv(2,2)*mat_X(j,1));
            %     c1_1 = c2_1*mat_X(k,2) + c3_1*mat_X(k,3);
            %
            %     if mat_X(k,1) ~= c1_1
            %         istatus = 1;            % Singular Origin not on boundary
            %         return
            %     end
            %
            %     c2_1 = -(A2_inv(1,1)*X_mom(i) + A2_inv(1,2)*X_mom(j));
            %     c3_1 = -(A2_inv(2,1)*X_mom(i) + A2_inv(2,2)*X_mom(j));
            %     c1_1 = c2_1*mat_X(k,2) + c3_1*mat_X(k,3);
            %
            %     if X_mom(k) ~= c1_1
            %         status = 3;             % Origin on boundary, moment is not
            %         return
            %     end
            %
            %     % Now determine if the origin is on the facet or just in the plane of
            %     % the facet.
            %
            %     if (c2_1 >= 0.0) & (c3_1 >= 0.0) & (c2_1 <= 1.0) & (c3_1 <= 1.0)
            %         % Origin and moment on boundary, can allocate
            %         [X_uallo, Xmom_max] = da_allocate (m, B, u1, u2, ifac_X, c1_1, ...
            %             c2_1, c3_1, umin, umax);
            %         X_flag = 1;
            %         allo2=1  % KILL ME!!
            %     else
            %         return                  % Origin on boundary, moment is not
            %     end
            %
        end        
    end

    function [U_vec, M_vec] = da_allocate (m, B, u1, u2, i_factor, var1, var2, var3, umin, umax)
        
        % This subfunction proceeds only if the control allocation is
        % determined to be possible.  The purpose of this routine is to find
        % the allocation control vector X_uallo and the corresponding maximum
        % moment vector, Xmom_max.
%         U_vec = zeros(9,1);
        M_vec=[0 0 0];
        for i = 1:m
            if (i ~= u1) && ( i ~= u2)   % Effectively skips u1 and u2 % KAB 21092013
                if i_factor(i) == 0
                    U_vec(i) = umin(i) *var1;
                elseif i_factor(i) == 1
                    U_vec(i) = umax(i) * var1;
                else
                    U_vec(i) = 0;
                end
            end
        end
        U_vec(u1) = var1*(umin(u1) + var2*(umax(u1) - umin(u1)));
        U_vec(u2) = var1*(umin(u2) + var3*(umax(u2) - umin(u2)));
        
        for i = 1:3
            for j = 1:m
                M_vec(i) = M_vec(i) + B(i,j)*U_vec(j);
            end
        end
    end
end

