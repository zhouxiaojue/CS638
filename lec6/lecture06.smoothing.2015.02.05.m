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

% linear combination of two Gamma functions  subtract it to get hemody...
y3 = y1 - y2;
hold on; plot(x, y3, 'r')

% stimuli modeled as a sequence of impulse functions
stimuli = zeros(1000,1);
ind = randi([1 1000], 100,1); %randomly index hundred of them of one
stimuli(ind)=1;
figure; plot(stimuli,'.')

bold = conv(stimuli, y3,'same');
hold on; plot(bold, 'r')

%---------------------------------
% Gaussian Kernel Smoothing in 1D

% Truncated Gaussian Kernel  in 1D
K=inline('exp(-(x.^2)/2/sigma^2)'); %define a function the kernel/ can also @ slash before sigma to 
dx= -50:50;
figure; plot(dx,K(10, dx));

sum(K(10,dx)) %integral sum height of function at each x
weight=K(10,dx)/sum(K(10,dx)) %normalize it
sum(weight) %if =1 properly devided
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
%more bandwidth, smoother (not that wiggle), nonparametric regression

%EXERCISE: Construct kernel and perform kernel smoothing such that
% the smoothed singals does not wiggle too much and approximate the underlying signal.

% boundary effect
noise=normrnd(10, 1, 1000,1);
figure; plot(noise, '.k');

smooth=conv(noise,weight,'same');
hold on;plot(smooth, 'r:', 'LineWidth', 3); 
% wrong model, limitation of kernel smoothing. Boundary is not right 

%How to fix the boundary effect?

snoise= noise-mean(noise); % shift noise by mean value 
%first subtract, then adding the mean back. lowering the level and then
%bring it back
smooth=conv(snoise,weight,'same') + mean(noise);
hold on;plot(smooth, 'r', 'LineWidth', 3);
%Why?
%1. K?*Y --> 0 |K?*Y|<|Y| 2. starting point and ending points are zeros
%fix: partial differential equation "heat diffusion" 
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

weight=K(sqrt(1000000),dx,dy)/sum(sum(K(sqrt(1000000),dx,dy))) %increased bandwidth doesn't change the kernel of a small window
smooth=conv2(signal,weight,'same');
figure;imagesc(smooth); colormap('bone');colorbar;

% Exercise: Why increasing the bandwidth will not change the amount of smoothing?
% then change the window size the image got very blurred
[dx,dy]=meshgrid([-100:100]); 
weight=K(sqrt(1000),dx,dy)/sum(sum(K(sqrt(1000),dx,dy)));
figure; imagesc(weight); colorbar
smooth=conv2(signal,weight,'same');
figure;imagesc(smooth); colormap('bone');colorbar;

%--------------------------------------
% This is why you need to smooth images

noise= normrnd(0, 5, 596, 368);
f = signal + noise;
figure; imagesc(f); colormap('bone'); caxis( [0 1]); colorbar

weight=K(sqrt(2),dx,dy)/sum(sum(K(sqrt(2),dx,dy)));
smooth=conv2(f,weight,'same');
figure; imagesc(smooth); colormap('bone'); caxis( [0 1]); colorbar

weight=K(sqrt(200),dx,dy)/sum(sum(K(sqrt(200),dx,dy)));
smooth=conv2(f,weight,'same');
figure; imagesc(smooth); colormap('bone'); caxis( [0 1]); colorbar
% different weight, much smoother
% Kernel smoothing is very robust and if used smartly, 
% it can outperform many advanced smoothing methods. 

%-----------------------------------------
% Gaussian white noise

figure; imagesc(noise); colormap('bone'); caxis( [-1 1]); colorbar

% Smooth Gaussian random field/stochastic process
[dx,dy]=meshgrid([-20:20])
weight=K(sqrt(1),dx,dy)/sum(sum(K(sqrt(1),dx,dy)));

smooth=conv2(noise,weight,'same');
figure; imagesc(smooth); colormap('bone'); caxis( [-1 1]); colorbar
% ten iteration of kernel smoothing, each time bandwidth increase by 10,
% increased smoothing
%generate moving images
for i=1:10
    noise= normrnd(0, 1, 100, 100);
    weight=K(sqrt(10*i),dx,dy)/sum(sum(K(sqrt(10*i),dx,dy)));
    smooth=conv2(noise,weight,'same');
    figure; imagesc(smooth); caxis( [-1 1]); colorbar
end;

%Exercise. As the bandwidth goes to infity, show the Gaussian kernel
%smoothing of white noise will converge to 0. 

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

%------------------------------------
% Checking Gaussianness after smoothing

X=exprnd(2, 100,100);
figure; imagesc(X); colormap('bone'); colorbar

Y=reshape(X, 100^2,1);
figure; qqplot(Y)

[dx,dy]=meshgrid([-20:20])
weight=K(sqrt(1),dx,dy)/sum(sum(K(sqrt(1),dx,dy)));

smooth=conv2(X,weight,'same');
figure; imagesc(smooth); colormap('bone'); colorbar

Y=reshape(smooth, 100^2,1);
figure; qqplot(Y)

%Exercise: Why Gaussianness is increases?




