% lecture 11
% 2015 Febuary 24
% Image Topology
% Moo K. Chung mkchung@wisc.edu


%-----------------------------------
% Morphological Operations

% Dilatation
addpath 
I= imread('toy-key.tif');
I=(double(I)-219)/36; % makes binary image 
figure; imagesc(I); colormap('bone'); colorbar %596 x 368

SE=strel('square', 60); % structural elements w pixels of 60x60 matrix of 1 
Idilatate= imdilate(I, SE);
figure; imagesc(Idilatate); colormap('bone'); colorbar 
%Exericise: Why dilatation does not dilate? recognize which one as object
%or background

%???????? 
Icomplement = ~I;
figure; imagesc(Icomplement); colormap('bone'); colorbar 

ICdilatate= imdilate(Icomplement, SE);
figure; imagesc(ICdilatate); colormap('bone'); colorbar 


%----------------------------------
% Erosion
Ierosion= imerode(I, SE); %imerode does the erosion
figure; imagesc(Ierosion); colormap('bone'); colorbar 

ICerosion= imerode(Icomplement, SE);
figure; imagesc(ICerosion); colormap('bone'); colorbar 


%---------------------------------
% Closing

ICclose= imerode(imdilate(Icomplement, SE),SE);
figure; imagesc(ICclose); colormap('bone'); colorbar 
%did not close since the hole is 100x100 


ICclose = imclose(Icomplement, SE); %single operation in matlab
figure; imagesc(ICclose); colormap('bone'); colorbar 

%Excercise: Close the hole using morphological closing oeprations only
% while preserving the overall shape.


%%%reshape --> histogram -->


%CDF sum all the bins

%map using floor (make integers) 