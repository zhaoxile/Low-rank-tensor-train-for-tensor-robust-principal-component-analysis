function [M] = CastKet2Image22(X,R,C,I1,J1)
    i=1;j=1;
    Nway = size(X);
    N = 1:numel(Nway);
    M = zeros(R,C,3);


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
                                Mtemp = X(i8,i7,i6,i5,i4,i3,i2,:);                            
                                M(i:i+I1-1,j:j+J1-1,:)=reshape(Mtemp,I1,J1,3);
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
            iN = i0+2;
            K = sumi2(N);
            jN = j0+1 - K;
        case 3
            [K] = sumi3(N);
            iN = i0-K;
            jN = j0+2;
        case 4
            iN = i0+2;
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
        K = K+2^(n-1);
    end
end

