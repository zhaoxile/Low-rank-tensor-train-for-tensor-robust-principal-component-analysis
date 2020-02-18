clc; clear all; close all;
addpath(genpath(cd));
rand('seed',213412); 

EN_SNN   = 1;
EN_TNN   = 1;
EN_TTNN  = 1;
methodname  = {'SNN','TNN','TTNN'};

X0 = double(imread('lena.bmp'));
X0 = X0/(max(X0(:)));
maxP = max(abs(X0(:)));
name = {'lena'};
[n1 n2 n3] = size(X0);
Xn = X0;
%% 10%
rhos = 0.1;
ind = find(rand(n1*n2*n3,1)<rhos);
Xn(ind) = rand(length(ind),1);
%% SNN
j = 1;
if EN_SNN
    %%%%
    fprintf('\n');
    disp(['performing ',methodname{j}, ' ... ']);
    
    opts.mu = 1e-4;
    opts.tol = 1e-5;
    opts.rho = 1.2;
    opts.max_iter = 500;
    opts.DEBUG = 1;
    
    alpha = [5 7 2.6];
    [Xhat,E,err,iter] = trpca_snn(Xn,alpha,opts);
    Xhat = max(Xhat,0);
    Xhat = min(Xhat,maxP);
    alpha1 = alpha(1);
    alpha2 = alpha(2);
    alpha3 = alpha(3);
 
   PSNRvector = zeros(1,n3);
   for i = 1:1:n3
       J = 255*X0(:,:,i);
       I = 255*Xhat(:,:,i);
       PSNRvector(1,i) = PSNR(J,I,n1,n2);
   end       
    MPSNR = mean(PSNRvector);

    SSIMvector = zeros(1,n3);
    for i = 1:1:n3
        J = 255*X0(:,:,i);
        I = 255*Xhat(:,:,i);
        SSIMvector(1,i) = SSIM(J,I);
    end       
    MSSIM = mean(SSIMvector);

    imname = [num2str(name{1}),'_SNN_result_rho_',num2str(rhos,'%.1f'),'_psnr_',num2str(MPSNR,'%.2f'),'_ssim_',num2str(MSSIM,'%.4f'),'_alpha1_',num2str(alpha1,'%.2f'),'_alpha2_',num2str(alpha2,'%.2f'),'_alpha3_',num2str(alpha3,'%.2f'),'.mat'];
    save(imname,'Xhat');
 end

%% TNN
j = j+1;
if EN_TNN
    %%%%
    fprintf('\n');
    disp(['performing ',methodname{j}, ' ... ']);

    opts.mu = 1e-4;
    opts.tol = 1e-5;
    opts.rho = 1.2;
    opts.max_iter = 500;
    opts.DEBUG = 1;

    [N1,N2,N3] = size(Xn);
    lambda = 1/sqrt(max(N1,N2)*N3);
    [Xhat,E,err,iter] = trpca_tnn(Xn,lambda,opts);
    Xhat = max(Xhat,0);
    Xhat = min(Xhat,maxP);
    
    PSNRvector = zeros(1,n3);
    for i = 1:1:n3
        J = 255*X0(:,:,i);
        I = 255*Xhat(:,:,i);
        PSNRvector(1,i) = PSNR(J,I,n1,n2);
    end
     MPSNR = mean(PSNRvector);

     SSIMvector = zeros(1,n3);
     for i = 1:1:n3
         J = 255*X0(:,:,i);
         I = 255*Xhat(:,:,i);
         SSIMvector(1,i) = SSIM(J,I);
     end
     MSSIM = mean(SSIMvector);
     
     imname = [num2str(name{1}),'_TNN_result_rho_',num2str(rhos,'%.1f'),'_psnr_',num2str(MPSNR,'%.2f'),'_ssim_',num2str(MSSIM,'%.4f'),'_lambda_',num2str(lambda,'%.3f'),'.mat'];
     save(imname,'Xhat');
end

%% TTNN
j = j+1;
if EN_TTNN
    %%%%
     fprintf('\n');
     disp(['performing ',methodname{j}, ' ... ']);
    
     % Initial parameters
     Nway = [4 4 4 4 4 4 4 4 3];     % 9th-order dimensions for KA
     N = numel(Nway);                % numel返回Nway中的数量   
     I1 = 2; J1 = 2;                 % KA parameters

     X_noise = CastImageAsKet22(Xn,Nway,I1,J1);
     lambda = 0.07;
     f = 2;
     gamma = 0.001;
     deta = 0.002;

     [Z, S, iter, relerr] = TT_TRPCA(X_noise, lambda, f, gamma, deta);
     Z_img = CastKet2Image22( Z, n1, n2, I1, J1 );
     S_img = CastKet2Image22( S, n1, n2, I1, J1 );       
     Z_img = max(Z_img,0);
     Z_img = min(Z_img,maxP);   
 
      PSNRvector = zeros(1,n3);
      for i = 1:1:n3
          J = 255*X0(:,:,i);
          I = 255*Z_img(:,:,i);
          PSNRvector(1,i) = PSNR(J,I,n1,n2);
      end  
      MPSNR = mean(PSNRvector);
                
      SSIMvector = zeros(1,n3);
      for i = 1:1:n3
          J = 255*X0(:,:,i);
          I = 255*Z_img(:,:,i);
          SSIMvector(1,i) = SSIM(J,I);
      end
      MSSIM = mean(SSIMvector);
          
      imname = [num2str(name{1}),'_TTNN_result_rho_',num2str(rhos,'%.1f'),'_psnr_',num2str(MPSNR,'%.2f'),'_ssim_',num2str(MSSIM,'%.4f'),'_lambda_',num2str(lambda,'%.2f'),'_f_',num2str(f,'%.1f'),'_gamma_',num2str(gamma,'%.3f'),'_deta_',num2str(deta,'%.3f'),'.mat'];
      save(imname,'Z_img','S_img');
end

