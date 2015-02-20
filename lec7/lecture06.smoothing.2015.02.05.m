% lecture 06
% 2015 Febuary 05
% Image Smoothing
% Moo K. Chung mkchung@wisc.edu

%----------------------------------
% Hemodynamic response function (HRF) convolution in fMRI from Lecture 03. 

% signle Gamma function
help gampdf

x = 0:.1:5;
y1 = gampdf(x, 2, .4); 
figure; plot(x, y1, 'k')

y2 = gampdf(x, 3, .4); 
hold on; plot(x, y2, 'b')

% linear combination of two Gamma functions
y3 = y1 - y2;
hold on; plot(x, y3, 'r')

% stimuli modeled as a sequence of impulse functions
stimuli = zeros(1000,1);
ind = randi([1 1000], 100,1);
stimuli(ind)=1;
figure; plot(stimuli,'.')

bold = conv(stimuli, y3,'same');
hold on; plot(bold, 'r')

%---------------------------------
% Gaussian Kernel Smoothing in 1D

% Truncated Gaussian Kernel  in 1D
K=inline('exp(-(x.^2)/2/sigma^2)');
dx= -50:50;
figure; plot(dx,K(10, dx));

sum(K(10,dx))
weight=K(10,dx)/sum(K(10,dx))
sum(weight)
figure; plot(weight);

% 1D Gaussian kernel smoothing
x=1:1000;
noise=normrnd(0, 1, 1,1000);
signal=cos(x/100);
figure; plot(signal, 'k', 'LineWidth', 3);
y= signal + noise;
hold on; plot(y, '.k');

smooth=conv(y,weight,'same');
hold on;plot(smooth, 'r', 'LineWidth', 3); 


%EXERCISE: Construct kernel and perform kernel smoothing such that
% the smoothed singals does not wiggle too much and approximate the underlying signal.

% boundary effect
noise=normrnd(10, 1, 1000,1);
figure; plot(noise, '.k');

smooth=conv(noise,weight,'same');
hold on;plot(smooth, 'r:', 'LineWidth', 3); 


%How to fix the boundary effect?

snoise= noise-mean(noise); % shift noise by mean value
smooth=conv(snoise,weight,'same') + mean(noise);
hold on;plot(smooth, 'r', 'LineWidth', 3);

%Exercise: Why we have the identical smoothing pattern in the middle?
% Is it even mathemtically possible?

%--------------------------------------------
% Gaussian Kernel Smoothing in 2D

% Truncated Gaussian Kernel  in 2D
K=inline('exp(-(x.^2+y.^2)/2/sigma^2)');  %kernel
[dx,dy]=meshgrid([-10:10])  % regular grid
figure; imagesc(K(10, dx,dy)); colorbar

sum(sum(K(10, dx,dy)))
%313.6054

weight=K(100000,dx,dy)/sum(sum(K(1000000,dx,dy)))
sum(sum(weight))

figure; imagesc(weight); colorbar

% toy example
signal= imread('toy-key.tif');
signal=(double(signal)-219)/36; % makes the image into real number
figure; imagesc(signal); colormap('bone'); colorbar %596 x 368

% Gaussian kernel smoothing
smooth=conv2(signal,weight,'same');
figure;imagesc(smooth); colormap('bone');colorbar;

weight=K(sqrt(100),dx,dy)/sum(sum(K(sqrt(100),dx,dy)))
smooth=conv2(signal,weight,'same');
figure;imagesc(smooth); colormap('bone');colorbar;

weight=K(sqrt(1000000),dx,dy)/sum(sum(K(sqrt(1000000),dx,dy)))
smooth=conv2(signal,weight,'same');
figure;imagesc(smooth); colormap('bone');colorbar;

% Exercise: Why increasing the bandwidth will not change the amount of smoothing?

[dx,dy]=meshgrid([-100:100]); 
weight=K(sqrt(1000),dx,dy)/sum(sum(K(sqrt(1000),dx,dy)));
figure; imagesc(weight); colorbar
smooth=conv2(signal,weight,'same');
figure;imagesc(smooth); colormap('bone');colorbar;

%--------------------------------------
% Gaussian white noise
% 2D Gaussian kernel smoothing 

noise= normrnd(0, 5, 596, 368);
f = signal + noise;
figure; imagesc(f); colormap('bone'); caxis( [0 1]); colorbar

weight=K(sqrt(2),dx,dy)/sum(sum(K(sqrt(2),dx,dy)));
smooth=conv2(f,weight,'same');
figure; imagesc(smooth); colormap('bone'); caxis( [0 1]); colorbar

weight=K(sqrt(200),dx,dy)/sum(sum(K(sqrt(200),dx,dy)));
smooth=conv2(f,weight,'same');
figure; imagesc(smooth); colormap('bone'); caxis( [0 1]); colorbar

% Kernel smoothing is very robust and if used smartly, 
% it can outperform many advanced smoothing methods. 


% Smooth Gaussian random field/stochastic process
[dx,dy]=meshgrid([-20:20])
weight=K(sqrt(1),dx,dy)/sum(sum(K(sqrt(1),dx,dy)));

smooth=conv2(noise,weight,'same');
figure; imagesc(smooth); colormap('bone'); caxis( [-1 1]); colorbar

for i=1:10
    noise= normrnd(0, 1, 100, 100);
    weight=K(sqrt(10*i),dx,dy)/sum(sum(K(sqrt(10*i),dx,dy)));
    smooth=conv2(noise,weight,'same');
    figure; imagesc(smooth); caxis( [-1 1]); colorbar
end;

%Exercise. As the bandwidth goes to infity, show the Gaussian kernel
%smoothing of white noise will converge to 0. 


%----------------------------------
% Gaussian kernel smoothing on graph/surface mesh
% load amygdala.volume.mat from /lecture01 directory

addpath /Users/kaeda/Documents/uw/2015spring/CS638/lec7
vol= squeeze(leftvol(1,:,:,:));
surf=isosurface(vol)

figure;figure_wire(surf,'black', 'white')

nbr= FINDnbr(surf.faces);
%surf.faces gives information about how each triangle forms
nbr(1,:) % neighboring vertices of node 1.

x=surf.vertices(:,1);
y=surf.vertices(:,2);
z=surf.vertices(:,3);

%bandwidth 100 gausian kernel smoothering  (x,y,z) coordinate on first
%neighbour
sigma=100;
sx=hk_smooth(x,surf,sigma,1);
sy=hk_smooth(y,surf,sigma,1);
sz=hk_smooth(z,surf,sigma,1);

%reconstruct surface with smoothering coordinate. the position change but
%connecitity doesn't change (using the connectivity information)
ssurf.vertices=[sx sy sz];
ssurf.faces=surf.faces;
figure;figure_wire(ssurf,'black', 'white')
%increase the number of sigma (bandwidth) the smoothering effect will not
%change much. Need to increase the window size. Can apply the gaussian
%smoothering one more time. The second neighbour information will be
%incorporate.

x=surf.vertices(:,1);
y=surf.vertices(:,2);
z=surf.vertices(:,3);

sigma=100;
sx=hk_smooth(x,surf,sigma,1);
sy=hk_smooth(y,surf,sigma,1);
sz=hk_smooth(z,surf,sigma,1);
sigma=100;
sx=hk_smooth(x,surf,sigma,1);
sy=hk_smooth(y,surf,sigma,1);
sz=hk_smooth(z,surf,sigma,1);
sigma=100;
sx=hk_smooth(x,surf,sigma,1);
sy=hk_smooth(y,surf,sigma,1);
sz=hk_smooth(z,surf,sigma,1);
sigma=100;
sx=hk_smooth(x,surf,sigma,1);
sy=hk_smooth(y,surf,sigma,1);
sz=hk_smooth(z,surf,sigma,1);
ssurf.vertices=[sx sy sz];
ssurf.faces=surf.faces;
figure;figure_wire(ssurf,'black', 'white')

%here is much smootherer ten iterations (???is the same as ten neighbours.
%solving nonlinearity 
%Exercise: perform Gaussian kernel smoothing using up to 2nd neighbors.

%-------------------------------
% Quantitle-quantile plot
% Smoothing increases Gaussianness

p=[1:99]/100; 
q=inline('-log(1-p)/2');
subplot(2,2,1); plot(q(p),p);
xlabel('q')
ylabel('p=P(X < q)')
title('CDF of exponential(2)')

X=exprnd(2, 500,1);
Y=exprnd(2, 500,1);
subplot(2,2,2); qqplot(X,Y)
title('QQ-plot')

X=exprnd(2, 500,1);
Y=exprnd(2, 500,1);
subplot(2,2,3); qqplot(X,Y)
title('QQ-plot')

X=exprnd(2, 500,1);
Y=exprnd(2, 500,1);
subplot(2,2,4); qqplot(X,Y)
title('QQ-plot')
%the limitation of QQ plot. need to look at the slope not just if that's
%the straight line. need to be y=x
%------------------------------------
% Checking Gaussianness after smoothing

X=exprnd(2, 100,100);
figure; imagesc(X); colormap('bone'); colorbar

Y=reshape(X, 100^2,1);
figure; qqplot(Y)
%single argument, will plot x: standard normal vs. Y 
[dx,dy]=meshgrid([-20:20])
weight=K(sqrt(1),dx,dy)/sum(sum(K(sqrt(1),dx,dy)));

smooth=conv2(X,weight,'same');
figure; imagesc(smooth); colormap('bone'); colorbar

Y=reshape(smooth, 100^2,1);
figure; qqplot(Y)
%the smootheness increase, the straghter the line is
%Exam: why apply gaussian smootheness will increase the gaussianess?
%central-limit theorem? 

%if the image looks like the gaussian, tool can be used for processing next
%step

%increase the bandwidth

X=exprnd(2, 100,100);
figure; imagesc(X); colormap('bone'); colorbar

Y=reshape(X, 100^2,1);
figure; qqplot(Y)
%single argument, will plot x: standard normal vs. Y 
%not bandwidth bigger than image size
%increase bandwidth
[dx,dy]=meshgrid([-20:20])
weight=K(sqrt(10),dx,dy)/sum(sum(K(sqrt(1),dx,dy)));

smooth=conv2(X,weight,'same');
figure; imagesc(smooth); colormap('bone'); colorbar

Y=reshape(smooth, 100^2,1);
figure; qqplot(Y)

%problem of kernel convolution of edges. boundary effects ????zero will
%contaminate the boundary

%get rid of boundary

temp=smooth(10:90,10:90);
figure; imagesc(temp); colormap('bone'); colorbar
%cut the boundary
%limitation of gaussian smoothering, the boundary effect
%------------------------------
%Mean filter as Gaussian kernel smoothing

K=inline('exp(-(x.^2+y.^2)/2/sigma^2)');  %kernel
[dx,dy]=meshgrid([-1:1])  % regular grid

w=K(0.1,dx,dy)/sum(sum(K(0.1,dx,dy)))
w=K(1,dx,dy)/sum(sum(K(1,dx,dy)))

w=K(100,dx,dy)/sum(sum(K(100,dx,dy)))

