function [M] = initialization_M(Nway,known,data)
    M = zeros(Nway);
    M(known) = data;
    for k = 2:length(known)
        inter = known(k)-known(k-1);
        if inter > 1
            x0 = known(k-1)+1;
            y0 = known(k)-1;
            meank = (data(k) + data(k-1))/2;
            M(x0:y0) = meank;        
        end
    end
    if length(known)<length(M(:))
        x0 = known(end)+1;
        y0 = length(M(:));
        meank = data(end);
        M(x0:y0) = meank;
    end
end