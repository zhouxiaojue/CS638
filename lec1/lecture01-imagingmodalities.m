%CS-638 Medical Image Analysis
%Lecture 01  Imaging Modalities
% (c) Moo K. Chung   mkchung@wisc.edu
addpath /Users/kaeda/Documents/uw/2015spring/CS638/lec1
%------------------------------------------------------
%Confocal microscope images of Rosenthal fibers

dir
%m8000alhipcc35fl.tif          
%m8000alob19fl.tif  

%load images
J = imread('m8000alhipcc35fl.tif');
% unit 8 = 256 gray scale
help imread

imtool(J)

I = imread('m8000alob19fl.tif');
imtool(I)
figure;imagesc(double(I))

%background computation
background = imopen(I,strel('disk',20));
imtool(background)
figure; imagesc(double(background))

% substract background from raw image
I2 = imsubtract(I,background); 
imtool(I2)
figure; imagesc(double(I2))

% automatic intensity correction
I3 = imadjust(I2);
imtool(I3)

figure; subplot(1,2,1); hist(double(I2))
subplot(1,2,2); hist(double(I3))


%---------------------------------------------------------
% Binary MRI of manual segmentation of left amygdala

clear all

%Analyze image format developed at Mayo clinic

header = analyze75info('left_amygdala.hdr')

% header = 
%             Filename: [1x17 char]
%           Dimensions: [1x4 int16]

vol=analyze75read(header);
% MATLAB usually filips image dimension x- and y-. 
% It should be in logical (int2) format.

vol=double(vol);
figure; imagesc(squeeze(vol(102,:,:)))
figure; imagesc(squeeze(vol(:,120,:)))
figure; imagesc(squeeze(vol(:,:,60)))

surf = isosurface(vol);
figure;figure_wire(surf,'black', 'white')
surface.faces %how to form triangle 
surface.vertices 
%---------------------------------------------------------
% 22 subject amgydala binary segmentation data
% This is the subset of the dataset used in 
% Chung, M.K., Worsley, K.J., Nacewicz, B.M., Dalton, K.M., Davidson, R.J. 2010. 
% General multivariate linear modeling of surface shapes using SurfStat. NeuroImage. 53:491-505
% http://www.stat.wisc.edu/~mchung/papers/chung.2010.NI.pdf

clear all
load amygdala.volume.mat

size(leftvol)
% amygdala surface visualization
vol=squeeze(leftvol(1,:,:,:)); %from four to three dimension
surf = isosurface(vol);
figure;figure_wire(surf,'yellow', 'white')

vol=squeeze(rightvol(1,:,:,:));
surf = isosurface(vol);
hold on ;figure_wire(surf,'green', 'white') %holding two images together
 
% volume computation, i:subject  three sums--> three dimensions
left=zeros(22,1);
right=zeros(22,1);
for i=1:22
    left(i)=sum(sum(sum(squeeze(leftvol(i,:,:,:)))));
    right(i)=sum(sum(sum(squeeze(rightvol(i,:,:,:)))));
end;

al= left(find(group));
ar=right(find(group));

cl= left(find(~group));
cr=right(find(~group));

% plot for amygdala volume
figure;
plot(al,ar,'or', 'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',7)
hold on
plot(cl,cr,'ob', 'MarkerEdgeColor','k', 'MarkerFaceColor','w', 'MarkerSize',7)
legend('Autism','Control')
xlabel('Left Amygdala')
ylabel('Right Amygdala')
set(gcf,'Color','w');

%size of amygdala
2000^(1/3)
%13mm

% THIS IS NOT HOMEWORK. NO NEED TO SUBMIT.
%
%Exercise 1: Compute the surface area of each amygdala surface
%Hint: You need to figure out the area of each triangle element first. 
% Given coordinates (x1, x1, x1), (x2, y2, z2) and (x3, y3, z3) that form
% the corners of a triangle, what is the area of the triangle?

%Exercise 2: Determine if there is any surface area difference between
%autistic children and normal controls. 
% Hint: Perform two sample t-test and determine the p-value associated with
% the above test. 






