
function  [X] =  WNNM( Y, C, r )
    [U,SigmaY,V] = svd(full(Y),'econ');    
    TempC        = C*2/r;
    [SigmaX,svp] = ClosedWNNM(SigmaY,TempC,eps);                        
    X =  U(:,1:svp)*diag(SigmaX)*V(:,1:svp)';     
return;
