% lecture 09
% 2015 Febuary 16
% Image Differentiation
% Moo K. Chung mkchung@wisc.edu


%---------------------------------
% Differentiation in 1D
% From lecture 06.  Truncated Gaussian Kernel  in 1D

K=inline('exp(-(x.^2)/2/sigma^2)');
dx= -50:50;

weight=K(10,dx)/sum(K(10,dx))
figure; plot(weight);

dweight = diff(weight)
hold on; plot(dweight, 'r');

% 1D signal jump detection
x=1:1000;
noise=normrnd(0, 0.1, 1,1000);
signal=[zeros(1,300) ones(1,400) zeros(1,300)]
figure; plot(signal, 'k', 'LineWidth', 3);
y= signal + noise;
hold on; plot(y, '.k');

smooth=conv(y,weight,'same');
hold on;plot(smooth, 'r:', 'LineWidth', 3); 

dsignal=conv(y,dweight,'same');
hold on;plot(dsignal, 'b', 'LineWidth', 3); 

figure; plot(dsignal, 'b', 'LineWidth', 3); 
find(dsignal == max(dsignal))
find(dsignal == min(dsignal))


%------------------------------
% EEG of epilpsy sisure patient
% Data: courtesy of Prof. Hernando Ombao, University of California-Irvine

% Channel names
% left temporal = T3, T5
% right temporal = T4
% left parietal = P3
% right parietal = P4
% central cz
% left central c3
% right central c4
% 
% Sampling rate is 100 Hertz 
% 
% Total T = 32000+
% 
% First half is preseizure; right half is seizure


c3=load('c3.formatted');
d=size(c3);
d(1)*d(2)

c3=reshape(c3', d(1)*d(2),1);
c3=c3(1:d(1)*d(2)-2);
figure; plot(c3)

d=length(c3)/2
c3sub = c3(d-2000:d+2000)
figure; plot(c3sub)

K=inline('exp(-(x.^2)/2/sigma^2)');
dx= -500:500;

weight=K(20,dx)/sum(K(20,dx))
smooth=conv(c3sub,weight,'same');
hold on;plot(smooth, 'r:', 'LineWidth', 3); 

%Edge detection method won't work.  
dweight = diff(weight)
dsignal=conv(c3sub,dweight,'same');
hold on;plot(dsignal, 'r', 'LineWidth', 3); 


%The variance map approach better than many edge detection technique.

for i=1:length(c3sub)-50
    c3var(i)=var(smooth(i:i+50));
end

hold on;plot(c3var, 'k', 'LineWidth', 3); 


%--------------------------------------------
% Edege detection in 2D


% manipulating color image
f= imread('FluorescentCells.tif');

R=double(squeeze(f(:,:,1)));  %MATLAB 2014b does not require squeeze.
G=double(squeeze(f(:,:,2)));
B=double(squeeze(f(:,:,3)));

figure; subplot(1,3,1); imagesc(R); colorbar; colormap('bone')
subplot(1,3,2); imagesc(G); colorbar;  colormap('bone')
subplot(1,3,3); imagesc(B); colorbar;  colormap('bone')

g= 2*R+ G+ B;
figure; imagesc(g); colorbar; colormap('jet')

g= R +G +B ;
figure; imagesc(g); colorbar; colormap('jet')


%sobel operator
Gsobel= edge(G, 'sobel');
figure; imagesc(Gsobel); colorbar; colormap('bone')

%Derivatives

Gdx = diff(G,1,1);
Gdy = diff(G,1,2);

figure; imagesc(Gdx); colorbar; colormap('bone')
figure; imagesc(Gdy); colorbar; colormap('bone')

% you will get error messeage. Why?
% Exercise. Try to fix diff somehow so that the below operation can be performed
figure; imagesc(Gdx.^2+Gdy.^2); colorbar; colormap('bone')

[Gdx,Gdy] = gradient(G);
Ggrad = sqrt(Gdx.^2+Gdy.^2);
figure; imagesc(Ggrad); colorbar; colormap('bone')

Ghist= reshape(Ggrad, 512^2,1);
figure; hist(Ghist,100)

ind =find(Ggrad<10);
Ggrad(ind)=0;
ind =find(Ggrad>=10);
Ggrad(ind)=1;
figure; imagesc(Ggrad); colorbar; colormap('bone')

ind =find(Ggrad<15);
Ggrad(ind)=0;
ind =find(Ggrad>=15);
Ggrad(ind)=1;
figure; imagesc(Ggrad); colorbar; colormap('bone')

%----------------------------------
% Diffusion Equation in 1D
% Lecture 10

x=1:1000;
noise=normrnd(0, 0.5, 1,1000);
signal=[zeros(1,300) ones(1,400) zeros(1,300)] %step function
figure; plot(signal, 'k', 'LineWidth', 3);
y= signal + noise;
hold on; plot(y, '.k');
% to recover the step function

%gaussian kernel smoothering
K=inline('exp(-(x.^2)/2/sigma^2)');
dx= -50:50;
weight=K(10,dx)/sum(K(10,dx))
smooth=conv(y,weight,'same');
hold on;plot(smooth, 'r:', 'LineWidth', 3); 

%1D Laplacian = 2nd derivative
L = [1 -2 1] %one dimension laplacian weight
Lsmooth = conv(y,L,'same');
hold on;plot(Lsmooth, 'r', 'LineWidth', 1); %convolve laplance with time delta t

%heat diffusion 
ytemp=y; %temperature 
for i=1:100 %100 times iteration
    Lsmooth = conv(ytemp,L,'same');
    ytemp = ytemp + 0.01*Lsmooth; %update the temperature variable
end
hold on;plot(ytemp, 'b', 'LineWidth', 3);     
%shrinkage the noise to smooth can try for i=1:10 -->1:20

ytemp=y;
for i=1:50000
    Lsmooth = conv(ytemp,L,'same');
    ytemp = ytemp + 0.01*Lsmooth;
end
hold on;plot(ytemp, 'g', 'LineWidth', 3);     
%nicer here 
%Exercise: what will happen if you run the iteration 
%for infinite number of times?



