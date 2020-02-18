function [P_Stripe,S]   =  m_Periodical_Simulated(Ori,Perio,rate,mean)
%% 
%case1:
%%%%%%%%%%%%%%%%%%%%-----------Chang creat stripe noise---------%%%%%%
%在1——10里面随机产生初始列，然后以10为周期加条带噪声
%前面的列同时加上一个固定的数：mean
%后面的列同时减去一个固定的数：mean
%这样的效果就可以达到加的条带的秩为1
rand('seed',2);
% Location = randperm(Perio,floor(rate*Perio));
Location = [42,43,44,45,46,47];
[Row, Col] = size(Ori);
S=zeros(Row,Col);
for i=0:1:floor(Col/Perio)-1   
    S(:,Location(1:floor(length(Location)/2)) + i * Perio) = S(:,Location(1:floor(length(Location)/2))...
      + i * Perio) + mean;
%     S(:,Location(floor(length(Location)/2)+1:length(Location))+ i * Perio) = ...
%     S(:,Location(floor(length(Location)/2)+1:length(Location))+ i * Perio) - mean;
end
% N=0.1*randn(Row,Col);
P_Stripe=Ori+S;
%%
% % case2  ：   条带上的值相同，但是不同条带上的值不同(有正有负），这样也可以达到条带的秩为1
% rand('seed',2);
% Location = randperm(Perio,floor(rate*Perio));
% % Location = [2,3];
% [Row, Col] = size(Ori);
% u= randi([0 50],2,floor(Col/Perio));
% S=zeros(Row,Col);
% for i=0:1:floor(Col/Perio)-1   
%     S(:,Location(1:floor(length(Location)/2)) + i * Perio) = S(:,Location(1:floor(length(Location)/2))...
%     + i * Perio) + u(1,i+1);
%     S(:,Location(floor(length(Location)/2)+1:length(Location))+ i * Perio) = ...
%     S(:,Location(floor(length(Location)/2)+1:length(Location))+ i * Perio) - u(2,i+1);   %+ u(2,i+1)条带值全为正数
% end
% N=0.01*randn(Row,Col);
% P_Stripe=Ori+S+N;

%%
%case3  ：   条带上的值不同，并且不同条带上的值不同(有正有负），这样不可以使得条带的秩为1
% rand('seed',0);
% Location = randperm(Perio,floor(rate*Perio));
% [Row, Col] = size(Ori);
% u= randi([0 60],Row,2*floor(Col/Perio));
% S=zeros(Row,Col);
% for i=0:1:floor(Col/Perio)-1   
%     S(:,Location(1:floor(length(Location)/2)) + i * Perio) = S(:,Location(1:floor(length(Location)/2))...
%     + i * Perio) + repmat(u(:,i+1),1,floor(length(Location)/2));
%     num=length(Location)-floor(length(Location)/2);
%     S(:,Location(floor(length(Location)/2)+1:length(Location))+ i * Perio) = ...
%     S(:,Location(floor(length(Location)/2)+1:length(Location))+ i * Perio) - repmat(u(:,floor(Col/Perio)+i+1),1,num);   %+ u(2,i+1)条带值全为正数
% end
% P_Stripe=Ori+S;
%%
%case4:    控制条带成分的秩等于
% rand('seed',0);
% Location = randperm(Perio,floor(rate*Perio));
% [Row, Col] = size(Ori);
% u= randi([0 60],2,floor(Col/Perio));
% S=zeros(Row,Col);
% for i=0:1:floor(Col/Perio)-1   
%     S(:,Location(1:floor(length(Location)/2)) + i * Perio) = S(:,Location(1:floor(length(Location)/2))...
%     + i * Perio) + u(1,i+1);
%     S(:,Location(floor(length(Location)/2)+1:length(Location))+ i * Perio) = ...
%     S(:,Location(floor(length(Location)/2)+1:length(Location))+ i * Perio) - u(2,i+1);   %+ u(2,i+1)条带值全为正数
% end
% Location = randperm(Row*Col,1000);
% S(Location)=randi([0 60],1,1000);
% P_Stripe=Ori+S;
%%
% rand('seed',2);
% % Location = randperm(Perio,floor(rate*Perio));
% [Row, Col] = size(Ori);
% S=zeros(Row,Col);
% for i=0:1:floor(Col/Perio)-1   
%     S(:,4 + i * Perio) = S(:,4 ...
%       + i * Perio) + mean;
%     S(:,5+ i * Perio) = ...
%     S(:,5+ i * Perio) - mean;
% end
% P_Stripe=Ori+S;
%%
%case2  ：   条带上的值相同，但是不同条带上的值不同(有正有负），这样也可以达到条带的秩为1
% rand('seed',2);
% [Row, Col] = size(Ori);
% u= randi([0 50],2,floor(Col/Perio));
% S=zeros(Row,Col);
% for i=0:1:floor(Col/Perio)-1   
%     S(:,4 + i * Perio) = S(:,4 ...
%     + i * Perio) + u(1,i+1);
%     S(:,5+ i * Perio) = ...
%     S(:,5+ i * Perio) - u(2,i+1);   %+ u(2,i+1)条带值全为正数
% end
% P_Stripe=Ori+S;