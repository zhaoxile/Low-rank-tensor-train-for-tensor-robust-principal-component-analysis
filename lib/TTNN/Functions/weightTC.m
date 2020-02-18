function [lambda] = weightTC(Nway)
    N = length(Nway);
    lambda = zeros(1,N-1);
    IL = Nway(1);
    for k = 1:N-1
        IR = prod(Nway(k+1:end));
        lambda(k) = min(IL,IR);
        IL = IL*Nway(k+1);
    end
    lambda = lambda/(sum(lambda));
end