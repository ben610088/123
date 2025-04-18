close all;
clc;

% 執行前請先確認資料夾 sysID_timeDomain 中的檔案 sysID_GeometryData_A1.mat、sysID_InputData.mat、sysID_OutputData.mat 是否正確
test_case = 999;                  
% Flight motion , test aircraft F-16A/B-all           % 1:different_simplify
                                                      % 2:different_origin
                                                      % 3:same_simplifyn
                                                      % 4:same_origin
% Flight motion , test aircraft F-16A/B-longitudinal  % 5:different_simplify
                                                      % 6:different_origin
                                                      % 7:same_simplifyn
                                                      % 8:same_origin
% Flight motion , test aircraft F-16A/B-lateral       % 9:different_simplify
                                                      % 10:different_origin
                                                      % 11:same_simplifyn
                                                      % 12:same_origin
                                                      % 81:same_origin_簡化版
                                                      % 999: 書附範例程式

% Model definition; functions for state derivatives and outputs
% 全開
if (test_case == 1)
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata, ...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase01_all_different_simplify(test_case);
elseif (test_case == 2)
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata,...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase02_all_different_origin(test_case);
elseif (test_case == 3)
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata,...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase03_all_same_simplify(test_case);
elseif (test_case == 4)
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata,...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase04_all_same_origin(test_case);
% 縱向
elseif (test_case == 5)
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata,...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase05_longitudinal_different_simplify(test_case);
elseif (test_case == 6)
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata,...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase06_longitudinal_different_origin(test_case);
elseif (test_case == 7)
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata,...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase07_longitudinal_same_simplify(test_case);
elseif (test_case == 8)
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata,...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase08_longitudinal_same_origin(test_case);
% 橫向
elseif (test_case == 9)
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata, ...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase09_lateral_different_simplify(test_case);
elseif (test_case == 10)
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata, ...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase10_lateral_different_origin(test_case);
elseif (test_case == 11)
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata, ...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase11_lateral_same_simplify(test_case);
elseif (test_case == 12)
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata, ...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase12_lateral_same_origin(test_case);
    elseif (test_case == 81)
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata,...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase81_longitudinal_same_origin(test_case);
elseif (test_case == 999)       % 書附範例程式
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata,...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase999(test_case);
else
    disp('Error Termination:');
    disp('Wrong specification of test_case.');

end 

% Verify model definition
iError = mDefCHK_fem(test_case, Nx, Ny, Nu, NparSys, Nparam, NparID, Ndata, ...
                                            t, Z, Uinp, param, parFlag, x0, iSD, SDyError);
if iError ~= 0, return, end        % Error termination 
                                    
%----------------------------------------------------------------------------------------
% parameter perturbation size for gradient computation by numerical approximation
%par_step  = 1e-6;
par_step  = 1e-4;
% Convergence limit in terms of relative change in thc cost function
tolR      = 1e-4;
%tolR      = 1e-3;
% max number of iterations
niter_max = 15;

% Iteration count from which F-estimate will be corrected using latest R-estimate
iterFupR = 3;

%----------------------------------------------------------------------------------------
% Initialize iteration counter, counter for halving step (maximum of ten)
iter     = 0;
khalf    = 0;
prevcost = 0;
iFup     = 0;
iFcmp    = 0;
ihalved  = 0; % Monitors if the parameter step has been halved or not. 
              % This is used to overwrite parameters for convergence plots
              
% Store parameter values for plotting purposes
params   = param;
par_std  = zeros(NparID,1);

disp('Parameter estimation applying Maximum Likelihood (Filter Error) Method:');

%----------------------------------------------------------------------------------------
% Initial measurement noise covariance matrix R: (see section 5.6)
if (iSD == 0)                                       % Default values with K = 0
    Kgain = zeros(Nx,Ny);
% 
% disp('jjjjjjjjjjjjjjj')

    [currentcost, R, RI, Y] = costfun_fem (state_eq, obser_eq, Ndata, Ny, Nu, Nx,...
                                           dt, t, x0, Uinp, Z, param, Kgain);
    disp(['Cost function: det(R) = ' num2str(currentcost)]);
else
    % Specified as standard deviations of output errors
    disp ('Standard deviations of the output errors:');
    SDyError;
    RI = diag(1./SDyError.^2);
end

%-----------------------------------------------------------------------------------------
% Iteration Loop (Jump back address)
while iter <= niter_max
    
    while iFcmp <= 0
        % Compute steady-state Kalman Gain matrix
        xt = x0;
        [Kgain, Cmat] = gainmat(state_eq, obser_eq, Nx, Ny, Nu, Nparam,...
                                          dt, t, param, parFlag, xt, Uinp, RI);    
        % simulation for the current parameter values
        % estimate covariance matrix R; determinant and inverse of R



        xt = x0;
        [currentcost, R, RInew, Y] = costfun_fem (state_eq, obser_eq, Ndata, Ny, Nu,... 
                                          Nx, dt, t, xt, Uinp, Z, param, Kgain);

        if  iFup == 0
%             disp('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
            % Print out the iteration count, parameter values and cost function
            disp(' ');
            disp(['iteration = ', num2str(iter)]);
            %disp('param'); param
            disp(['cost function: det(R) = ' num2str(currentcost)]);
            iFcmp = 1;
        else
            disp('Correction of F (with the new estimated value of R)');
            %disp('param'); param
            disp(['cost function: det(R) = ' num2str(currentcost)]);  
            if  currentcost > prevcost
                disp('Local divergence after F-compensation');
                khalf = khalf + 1;
                if  khalf < 3               % Allow 2 step of halving
                    param(Nparam-Nx+1:Nparam) = (param(Nparam-Nx+1:Nparam)+FAlt)/2;
                elseif khalf == 3           % At 3rd halving restore previous values
                    param(Nparam-Nx+1:Nparam) = FAlt;
                    RI = RIAlt;
                else                        % After 3rd halving, discontinue F-correction 
                    iFcmp = 1;              % and proceed to the next full step.
                end
            else
                iFcmp = 1;                  % Set iFcmp > 0 after halving is done
            end
        end
        
    end   % end of while iFcmp <= 0
%     disp('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb')
    % khalf = 0;                       % 2014_04-22

    % store parameters and standard deviations only if successful step: convergence plot 
	if (ihalved ==0)
%         disp('ccccccccccccccccccccccccccccccccccccccccccccc')
        if  (iter > 0 && iFup == 0) || (iter > 0 && iFcmp == 1)
            params  = [params, param];
            pcov    = inv(F);
            par_std = [par_std, sqrt(diag(pcov))];    
        end
	else
		params(:,end) = param; % save only the latest one when halved
	end
%     disp('ddddddddddddddddddddddddddddddddddddddddd')
    %------------------------------------------------------------------------------------
    % Check convergence: relative change in the cost function
    relerror = abs((currentcost-prevcost)/currentcost)
    %disp(['relative error = ', num2str(relerror)]);

    if (relerror<tolR) && (iter > 0)  && (iFcmp ==0)
        
        disp('Iteration concluded: relative change in det(R) < tolR')
        break;
        
    else

        if  iter == niter_max
            disp(' ');
            disp('Maximum number of iterations reached.');
            break;
            
        elseif (currentcost>prevcost) && (iter > 0)
%             disp('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee')
            % Maximum of 10 times halving of the parameters
            if  khalf == 10
                disp('Intermediate divergence:!')
                disp('Error termination:')
                disp('No further improvement after 10 times halving of parameters.')
                break;
            else
                disp('Intermediate divergence: halving of parameter step')
                param = (param+param_old)/2;
                khalf = khalf + 1;
                iFcmp = 0;             %2014-04-20
                % iter  = iter + 1;      %2014-04-20 ??
                ihalved = 1;           %2014-04-20
            end 
            
        else
%             disp('ffffffffffffffffffffffffffffffffffffffffffffffff')
            %----------------------------------------------------------------------------
			ihalved = 0;               %2014-04-20
            xt = x0;
            par_del = par_step*param;               % parameter perturbations for gradients
            % par_del(find(par_del==0)) = par_step;   % if zero, set to par_step
            par_del((par_del==0)) = par_step;       % if zero, set to par_step
%             disp('gggggggggggggggggggggggggggggggggggg')
            % compute the perturbed gain matrices for gradient computations
            [KGPert, gradKC] = gainmatPert(state_eq, obser_eq, Nx, Ny, Nu, Nparam,...
                                           dt, t, param, par_del, parFlag, xt,...
                                           Uinp, RI, Kgain, Cmat);
            disp('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh')
            % compute the matrix of second gradients F and gradient G
            [F,G, tempQ]  = gradFG(Ny, Nparam, NparID, Ndata, Nu, Nx, dt, Z, Y, RI,...
                            param, par_del, parFlag, state_eq, Uinp, obser_eq,...
                            t, xt, Kgain, KGPert)
            disp('iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii')
            % compute parameter update using Cholesky factorization: 
            uptF   = chol(F)                    % Upper traiangular F = uptF'*uptF 
            delPar = -uptF \ (uptF'\G)
            disp('jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj')
            % Check for the inequality contraints KC <= 1
            Nk = NparSys + Nx;                   % Number of parameters affecting K
            [delPar] = kcle1(Nx, Ny, Nparam, NparID, Nk, delPar, Cmat, Kgain, gradKC, F);
              
            %----------------------------------------------------------------------------
            % update parameter vector param
            param_old = param;
            iPar = 0;
            
            for i1=1:Nparam
                if  parFlag(i1) > 0
                    iPar = iPar + 1;
                    param(i1) = param(i1) + delPar(iPar);
                end
            end
            
            prevcost = currentcost;
            iter  = iter + 1;
            iFcmp = 0;
            khalf = 0;                           %2014-04-22

            if  iter >= iterFupR                 % F compensation using new R

                khalf = 1;                       % Initialize counter
                while  khalf ~= 0                % Jump back address; 2014-04-22

                    xt = x0;
                    [Kgain, Cmat] = gainmat(state_eq, obser_eq, Nx, Ny, Nu, Nparam,...
                                            dt, t, param, parFlag, xt, Uinp, RI);

                    [currentcost, Rnew, RInew, Y] = ...
                            costfun_fem (state_eq, obser_eq, Ndata, Ny, Nu, Nx, dt,...
                                         t, xt, Uinp, Z, param, Kgain);
                        
                    if (khalf == 1), disp(' '); end        %2014-04-22
                    disp(['iteration = ', num2str(iter)]);
                    %disp('param'); param
                    disp(['cost function: det(R) = ' num2str(currentcost)]);
                                
                    relerror = abs((currentcost-prevcost)/currentcost);
                    if  relerror < tolR
                        % On eps-convergence after the full iteration, no need to carry out
                        % F-compensation, because at the true minimum it would not (or rather
                        % should not) lead to any changes in det(R). Hence, terminate.
                        disp(' ')
                        disp('Iteration concluded: relative change in det(R) < tolR')
                        params  = [params, param];
                        pcov    = inv(F);        % save param and std.Dev for conver-plot
                        par_std = [par_std, sqrt(diag(pcov))];    
                        break
                    elseif (currentcost > prevcost)
                        
                        if  khalf == 10         % Maximum 10 times halving of parameters
                            disp('Error termination:')
                            disp('No further improvement after 10 times halving of parameters.')
                            break;
                        else
                            disp('Intermediate divergence: halving of parameter step')
                            param = (param+param_old)/2;
                            khalf = khalf + 1;
                        end
                    else
                        khalf = 0;
                    end
                end

				if khalf == 10 
					param = param_old; % go back to old parameters. These are the last to make sense.
					iter = iter - 1;
					break;             % error termination.
				elseif relerror < tolR
					break;             % converged.
				end
                
                prevcost = currentcost;
                
                paralt = param;
                FAlt   = param(Nparam-Nx+1:Nparam);
                RIAlt  = RI;
                
                % Compensate F-estimates using new RI
                param = fcompn(Nx, Nparam, FAlt, RInew, RI, Cmat, param, parFlag);
                RI    = RInew;
                iFup  = 1;
                iFcmp = 0;
                % khalf = 0;                     %2014-04-22
            end              % end of: iter >= iterFupR, F compensation using new R

        end                 % end of: if iter == niter_max,
        
    end                     % end of: if (relerror<tolR) & (iter > 0) & (iFcmp ==0),
  
end                         % end of: while iter <= niter_max;


%----------------------------------------------------------------------------------------
% Printout of final parameter estimates, standard deviations and correlation coefficients
if  iter > 0
    par_std_rel = par_accuracy(iter, Nparam, param, par_std, pcov, parFlag, NparID);
end


%----------------------------------------------------------------------------------------
% plots of measured and estimated time histories of outputs and inputs
% convergence plots of parameter estimates
if (test_case == 1)
    [t]=plots_TC01_F16_all_different_simplify(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 2)
    [t]=plots_TC02_F16_all_different_origin(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 3)
    [t]=plots_TC03_F16_all_same_simplify(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 4)
    [t]=plots_TC04_F16_all_same_origin(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 5)
    [t]=plots_TC05_F16_longitudinal_different_simplify(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 6)
    [t]=plots_TC06_F16_longitudinal_different_origin(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 7)
    [t]=plots_TC07_F16_longitudinal_same_simplify(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 8)
    [t]=plots_TC08_F16_longitudinal_same_origin(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 9)
    [t]=plots_TC09_F16_lateral_different_simplify(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 10)
    [t]=plots_TC10_F16_lateral_different_origin(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 11)
    [t]=plots_TC11_F16_lateral_same_simplify(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 12)
    [t]=plots_TC12_F16_lateral_same_origin(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 81)
    [t]=plots_TC81_F16_longitudinal_same_origin(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 999)
    [t]=plots_TC999_oem_hfb(t, Z, Y, Uinp, params, par_std, iter);
end
