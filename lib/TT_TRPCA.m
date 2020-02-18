function [Z, S, iter, relerr] = TT_TRPCA( X_noise, lambda, f, gamma, deta )
tol     = 10^(-4);      
Nway    = size( X_noise );  
maxiter = 200; 

% Compute the weights for each matrix
alpha = weightTC( Nway );
beta  = f*alpha;

N = length( Nway );   
dimL = zeros(1,N-1);
dimR = zeros(1,N-1);
IL = 1;
for m = 1:N-1
    dimL(m) = IL*Nway(m);
    dimR(m) = prod( Nway )/dimL(m);
    IL = dimL(m);
 end
%% initialization
Z = X_noise;
U = cell(1,N-1);
C = cell(1,N-1);
for i = 1:N-1
    C{i} = zeros(Nway); 
end
E = zeros(Nway);
S = zeros(Nway);
J = zeros(Nway);
Y = zeros(Nway);

k = 1;
iter      = [];
relerr    = [];
iter(1)   = 1;
relerr(1) = 1;

while relerr(k) > tol && k <= maxiter
    k = k+1;
    Zlast = Z;
          
    %% U
    for n = 1:N-1
        Un = SVT( reshape( Z, [dimL(n) dimR(n)] )-reshape(C{n}, [dimL(n) dimR(n)])/beta(n), alpha(n)./beta(n) );
        U{n} = reshape(Un, Nway);
    end
    
    %% Y - subproblem 
    Y = soft_shrink( S-J/deta, lambda/deta);
    
    %% Z,S- subproblem
    temp = beta(1)*(U{1}+C{1}./beta(1));
    for n = 2:N-1
      temp = temp + beta(n)*(U{n}+C{n}./beta(n));
    end
    e  = temp+gamma*( X_noise+E/gamma );
    f  = gamma*( X_noise+E/gamma )+deta*( Y+J/deta );
    tt = ( gamma^2-(sum(beta) + gamma)*(gamma + deta) );
    Z  = ( gamma*f-(gamma+deta)*e)./tt;
    S  = ( gamma*e-(sum(beta)+gamma)*f)./tt;
    
    %% Update C, E, J
    for n=1:N-1
        C{n} =  C{n} + beta(n)*(U{n}-Z);
    end
    E = E + gamma*(X_noise-Z-S);
    J = J + deta*(Y-S);
    gamma = 1.1*gamma;  
    deta  = 1.1*deta;
    %% Calculate relative error
    relerr(k) = abs(norm(Z(:)-Zlast(:))) / norm(Zlast(:));
 
end
iter( k )=k;
end