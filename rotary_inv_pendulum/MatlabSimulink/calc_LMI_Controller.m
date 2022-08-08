function [K,LMIsys] = calc_LMI_Controller(A,B,alpha)
    % 1. Beginnig of LMI programm
    
    setlmis([]);
    
    % 2. Define all LMI variable
    
    varType_symBlock = 1; %symmetric block diagonal
    varType_fullRectangular = 2;
    
   
    [n,~] = size(A);
    [~,m] = size(B);
    
    X = lmivar(varType_symBlock,[n 1]); % specify variable P as square symmetric (n,n) matrix
    M = lmivar(varType_fullRectangular,[m n]);
    
    % 3. Define all LMI terms lmiterm(TERMID,A,B,FLAG) L(z) < R(z)
    % XA' + AX - M'B' -BM + 2 alpha X < 0
    % X > 0
    %lmiterm([1 1 1 X],A,1,'s');    % XA'+AX
    %lmiterm([1 1 1 X],2*alpha,1);   % 2*alpha X
    %lmiterm([1 1 1 M],-B,1,'s');    % M'B' - BM !!! Hier könnte Fehler liegen
    %lmiterm([-2 1 1 X],1,1);        % X > 0
    
    lmiterm([1 1 1 X],1,A')         % XA'
    lmiterm([1 1 1 X],A,1)          % AX
    lmiterm([1 1 1 -M],-1,B');      % -M'B'
    lmiterm([1 1 1 M],-1*B,1);        % -BM
    %lmiterm([1 1 1 M],-B,1,'s');
    lmiterm([1 1 1 X],2*alpha,1);   % 2*alpha X
    lmiterm([-2 1 1 X],1,1);        % X > 0
    
    % 4. Solve LMI problem
    
    LMIsys = getlmis;               % Declare the whole LMI problem
    [tmin,xfeas] = feasp(LMIsys);   % Solve the LMI problem
    disp(tmin)
    
    X_sol = dec2mat(LMIsys,xfeas,X); % Get the numerical value of P
    M_sol = dec2mat(LMIsys,xfeas,M);
    
    K = M_sol * inv(X_sol);
end



