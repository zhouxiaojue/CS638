addpath /Users/kaeda/Documents/uw/2015spring/CS638/HW2
load mandible.mat
K=inline('exp(-(x.^2+y.^2)/2/sigma^2)');
mandible1=mandible(100,:,:);
[dx,dy]=meshgrid([-10:10]) ; % regular grid
figure; imagesc(K(10, dx,dy)); colorbar
