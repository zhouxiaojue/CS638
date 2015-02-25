addpath /Users/kaeda/Documents/uw/2015spring/CS638/HW2
load mandible.mat
%%%%%%%%
%Q1
%get only slice of mandible
mandible1=mandible(100,:,:);
mandible1=squeeze(mandible1(1,:,:)); 
%k= (bandwidth=sigma, x, y)

%generate noise and add it to the signal
e=normrnd(0,1,size(mandible1,1),size(mandible1,2));
Y=mandible1+e;

%generate Gaussian Kernel
K=inline('exp(-(x.^2+y.^2)/2/sigma^2)');
[dx,dy]=meshgrid ([-10:10]); 

%when bandwidth equals to 110100
weight=K(110100,dx,dy)/sum(sum(K(110100,dx,dy))); 

%figure; imagesc(K(110100, dx,dy)); colorbar
%convolve kernel to signal and generate smoothed image
Ysmooth=conv2(Y,weight,'same');
figure;imagesc(Ysmooth);colorbar;

%reshape signal and noise to 1*number of voxels
mandible_reshape=reshape(Y,1,size(mandible1,1)*size(mandible1,2));
noise_reshape=reshape(e,1,size(mandible1,1)*size(mandible1,2));
%signal to noise ratio
for i=1:(size(mandible1,1)*size(mandible1,2))
        SNR(i)=(mean(mandible_reshape(i)))/(std(noise_reshape(i)));
end
SNR=reshape(SNR,size(mandible1,1),size(mandible1,2));
figure;imagesc(SNR)
%%%%
%when bandwidth equals to 1

weight=K(1,dx,dy)/sum(sum(K(1,dx,dy))); 

%figure; imagesc(K(110100, dx,dy)); colorbar
%convolve kernel to signal and generate smoothed image
Ysmooth=conv2(Y,weight,'same');
figure;imagesc(Ysmooth);colorbar;

%reshape signal and noise to 1*number of voxels
mandible_reshape=reshape(Y,1,size(mandible1,1)*size(mandible1,2));
noise_reshape=reshape(e,1,size(mandible1,1)*size(mandible1,2));
%signal to noise ratio
for i=1:(size(mandible1,1)*size(mandible1,2))
        SNR_1(i)=(mean(mandible_reshape(i)))/(std(noise_reshape(i)));
end
SNR_1=reshape(SNR_1,size(mandible1,1),size(mandible1,2));
subplot(1,2,1);imagesc(SNR_1)
subplot (1,2,2);imagesc(SNR)
%%%%%%
%Q2
Kx=inline('exp(-(x.^2)/2/sigma^2)');
dx=-50:50;
weight=Kx(10,dx)/sum(Kx(10,dx));

for i=1:size(mandible,1)
    Ysmooth_x=conv2(Y[i,:],weight,'same');
    
end
Kx=inline('exp(-(y.^2)/2/sigma^2)');
dy=-50:50
weight=ky(10,dy)/sum(ky(10,dy))
for j=1:size(mandible,2)
    Ysmooth_xy=conv(Ysmooth_x[:,j],weight,'same');
end

%%
%Problem 2 
