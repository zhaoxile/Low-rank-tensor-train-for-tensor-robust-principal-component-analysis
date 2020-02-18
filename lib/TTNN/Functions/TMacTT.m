%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TMac-TT
% Time: 30/06/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Z, S, timeTC,iter,relerr] = TMacTT(Nway,Noi,tol,maxiter,lam,f,gamma,deta)
    % Compute the weights for each matrix
    lambda = weightTC(Nway);
    beta1  = f*lambda;
    % Start Time measure
    t0=tic;
    [Z, S, iter,relerr] = GlobalTMP(Nway,Noi,tol,maxiter,lambda,lam,beta1,gamma,deta);
    % Stop Time measure
    timeTC = toc(t0);
end
%%
function [Z, S, iter,relerr] = GlobalTMP(Nway,Noi,tol,maxiter,lambda,lam,beta1,gamma,deta)

    N = length(Nway);
    
    dimL = zeros(1,N-1);
    dimR = zeros(1,N-1);
    IL = 1;
    for m = 1:N-1
        dimL(m) = IL*Nway(m);
        dimR(m) = prod(Nway)/dimL(m);
        IL = dimL(m);
    end 
 %% initialization

Z  = Noi;
Uk = cell(1,N-1);
Ck = cell(1,N-1);
for i=1:N-1
    Ck{i} = zeros(Nway); 
end
Et = zeros(Nway);
J = zeros(Nway);
Y = zeros(Nway);
S = zeros(Nway);

iter=[];
k=1;
relerr = [];
relerr(1) = 1;
 %% main
% for k = 1:maxiter
%      nrmUS = norm([U,S],'fro');
while relerr(k) > tol   && k<=200
        k = k+1;
        Zlast = Z;
   
        
    %% Uk_K
     for n = 1:N-1
        Uk_m{n} = SVT( reshape( Z,[dimL(n) dimR(n)] )-reshape(Ck{n},[dimL(n) dimR(n)])/beta1(n), lambda(n)./beta1(n) );
     end
     for m = 1:N-1
        Uk{m} = reshape(Uk_m{m}, Nway);
     end   
    %% Y - subproblem ͹
    Y = soft_shrink(S+J/deta, lam/deta);
    
    %% Z,S- subproblem
    temp = beta1(1)*(Uk{1}+Ck{1}./beta1(1));
    for m=2:N-1
      temp = temp + beta1(m)*(Uk{m}+Ck{m}./beta1(m));
    end
    e = temp+gamma*(Noi+Et/gamma);
    f = gamma*(Noi+Et/gamma)+deta*(Y+J/deta);
    tt=( gamma*gamma-(sum(beta1) +gamma)*(gamma+deta) );
    Z =( gamma*f-(gamma+deta)*e)./tt;
    S =( gamma*e-(sum(beta1)+gamma)*f)./tt;
    
    %% Update C1,C2
   for m=1:N-1
      Ck{m} =  Ck{m} + beta1(m)*(Uk{m}-Z);
   end
    Et = Et + gamma * (Noi-Z-S);
    J = J+deta*(Y-S);
    
    beta1=1.1*beta1;
    gamma=1.1*gamma;
    deta=1.1*deta;
    %% Calculate relative error
    relerr(k) = abs(norm(Z(:)-Zlast(:))) / norm(Zlast(:));
   
end
iter=k;
%% check stopping criterion
%         if k > maxiter || (relerr(k)-relerr(k-1) > 0)
%             break 
%         end  
end

