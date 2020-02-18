function [X] = CastImageAsKet32(M,Nway,I1,J1)
    i=1;j=1; % Nway = [4,4,4,4,4,4,4,4,3]
    N = 1:numel(Nway); % N = [1 2 3 4 5 6 7 8 9]
    X = zeros(Nway);

 for i9 = 1: Nway(9)
       [i,j] = index_ij(i,j,i9,N(9));
    for i8 = 1: Nway(8)
        [i,j] = index_ij(i,j,i8,N(8));
        for i7 = 1: Nway(7)
            [i,j] = index_ij(i,j,i7,N(7));
            for i6 = 1: Nway(6)
                [i,j] = index_ij(i,j,i6,N(6));
                for i5 = 1: Nway(5)
                    [i,j] = index_ij(i,j,i5,N(5));
                    for i4 = 1: Nway(4)
                        [i,j] = index_ij(i,j,i4,N(4));
                        for i3 = 1: Nway(3)
                            [i,j] = index_ij(i,j,i3,N(3));
                            for i2 = 1: Nway(2)
                                [i,j] = index_ij(i,j,i2,N(2));
                                Mtemp = M(i:i+I1-1,j:j+J1-1,:);
                                X(i9,i8,i7,i6,i5,i4,i3,i2,:) = Mtemp(:);
                            end
                        end
                    end
                end
            end
        end
    end
 end
end

function [iN,jN] = index_ij(i0,j0,k_N,N)
    switch k_N
        case 1
            iN = i0;
            jN = j0;           
        case 2
            iN = i0+3;
            K  = sumi2(N);
            jN = j0+1 - K;
        case 3
            iN = i0+3;
            K  = sumi2(N);
            jN = j0+1 - K;
        case 4
            [K] = sumi3(N);
            iN  = i0-K;
            jN  = j0+2;
        case 5
            iN = i0+3;
            K  = sumi2(N);
            jN = j0+1 - K;
        case 6
            iN = i0+3;
            K = sumi2(N);
            jN = j0+1 - K;
    end
end

function [K] = sumi2(N)
    K=0;
    for n = 2:N
        K = K+2^(n-2);
    end
end

function [K] = sumi3(N)
    K=0;
    for n = 2:N
        K = K+2*3^(n-1);
    end
end