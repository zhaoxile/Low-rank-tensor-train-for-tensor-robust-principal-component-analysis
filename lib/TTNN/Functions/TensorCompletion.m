function [Z_3,S_3,iter,relerr] = TensorCompletion(Noi,lam,f,gamma,deta)
    %% Missing data
    Nway = size(Noi); 
    
    %% TMac-TT Algorithm        
    thl = [0.02];       % Adjust this value for different thresholds
    tol = 10^(-4);      % tol from Eq. (43)
    maxiter = 1000;     % max iterations
    RSl = zeros(1,length(thl));MSl = cell(1,length(thl));relerrSl = MSl;timeTSl = RSl;
    for k=1:length(thl)
        th = thl(k);
        [Z, S, timeTC, iter,relerr] = TMacTT(Nway,Noi,tol,maxiter,lam,f,gamma,deta);    
    end
    %Choose the minimum RSE
%     [Out.RSEmin, Idx] = min(RSl);
%     Out.timeTS = timeTSl(Idx);
%     Out.muf = thl(Idx);
%     Out.MS = MSl{Idx};
%     Out.err = relerrSl{Idx};
        
    %% Original image with missing pixels
    R=256;C=256;I1=2;J1=2;
    Z_3 = CastKet2Image22(Z,R,C,I1,J1);
    S_3 = CastKet2Image22(S,R,C,I1,J1);
%     h3 = figure();
%     set(h3,'Position',[700 150 400 350]);
%     imagesc(uint8(Xmiss));
%     st = strcat('Original image with{ }',num2str(mr),'% missing pixels');
%     title(st);
    
end
