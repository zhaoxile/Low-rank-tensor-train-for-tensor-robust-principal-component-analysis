function err = RSE(X1,X2)
    err = norm(X1-X2,'fro')/norm(X2,'fro');
end