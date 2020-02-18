function [A,RankX] = SVD_MPS_Rank_Estimation(X,th)
%Function to decompose a high-order rank tensor into an MPS
N =  ndims(X);
A = cell(1,N);
RankX = zeros(1,N-1);
sizX = size(X);
%Left to Right sweeping
% form a matrix
T = reshape(X,[sizX(1) prod(sizX(2:end))]);
for k = 1:N-1    
    [A{k}, S, V, chi] = svd_RankEstimate(T,th);    
    %Reshape MPS tensor
    if k==1
        A{k} = reshape(A{k},[sizX(k) chi]);
    else
        A{k} = reshape(A{k},[size(T,1)/sizX(k) sizX(k) chi]);
    end
    T = S*V;    
    T = reshape(T,[chi sizX(k+1:end)]);
    if k<N-1
        T = reshape(T,[chi*sizX(k+1) prod(sizX((k+2):end))]);            
    end
    RankX(k) = chi;    
end
A{N} = T;

end
%%

function [U, S, V, chi]=svd_RankEstimate(T,th)
[U, S, V]=svd(T, 'econ');
V=V';
chi = 0;
szS = size(S,1); 
for k = 1:szS
    if S(k,k)/S(1,1)>th
        chi = chi+1;
    end
end
chi = max(chi,2); % avoid chi = 1
%Truncation
U = U(:,1:chi);
S = S(1:chi,1:chi);
V = V(1:chi,:);
fprintf('The original rank is %u and truncated rank is %u\n',szS,chi)
end
