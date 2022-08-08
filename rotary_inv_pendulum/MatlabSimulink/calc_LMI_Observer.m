function [L,LMIsys] = calc_LMI_Observer(A,C,alpha)
% 1. Beginnig of LMI programm
    
    setlmis([]);
    
    % 2. Define all LMI variable
    
    varType_symBlock = 1; %symmetric block diagonal
    varType_fullRectangular = 2;
    
   
    [n,~] = size(A);
    [p,~] = size(C);
    
    P = lmivar(varType_symBlock,[n 1]); % specify variable P as square symmetric (n,n) matrix
    N = lmivar(varType_fullRectangular,[n p]);

    % 3. Define all LMI terms lmiterm(TERMID,A,B,FLAG) L(z) < R(z)
    % LMI1: A'P + PA -NC -C'N' + 2 alpha P < 0
    % LMI2: P>0
    
    lmiterm([1 1 1 P],1,A,'s');     % A'P+PA 
    lmiterm([1 1 1 P],2*alpha,1);   % 2*alpha P
    lmiterm([1 1 1 N],1,-C,'s');   % -NC - C'N   
    lmiterm([-2 1 1 P],1,1);        % P > 0
    
    
    % 4. Solve LMI problem
    
    LMIsys = getlmis;               % Declare the whole LMI problem
    [tmin,xfeas] = feasp(LMIsys);   % Solve the LMI problem
    disp(tmin)
    
    P_sol = dec2mat(LMIsys,xfeas,P); % Get the numerical value of P
    N_sol = dec2mat(LMIsys,xfeas,N);
    
    L = inv(P_sol)*N_sol;
end

