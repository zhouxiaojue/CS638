addpath /Users/lcnl/Documents/untitled folder
load mandible.mat
K=inline('exp(-(x.^2+y.^2)/2/sigma^2)');
mandible1=mandible(100,:,:);
mandible1=squeeze(mandible1(1,:,:));

e=normrnd(0,1,size(mandible1,1),size(mandible1,2));
Y=mandible1+e;
[dx,dy]=meshgrid ([-2:2]); 
weight=K(0.5,dx,dy)/sum(sum(K(0.5,dx,dy))); 

[dx,dy]=meshgrid([-10:10]) ; % regular grid
figure; imagesc(K(10, dx,dy)); colorbar
