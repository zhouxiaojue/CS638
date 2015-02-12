% Examples of flow control

%%
% if

a = rand(3,3);  % uniform random variable
row = 1;
col = 3;
% %d filled in with the row, second %d filled with col
if a(row, col)<.5
    sprintf('row %d, column %d is less than .5', row, col)
elseif a(row, col)> .5
    sprintf('row %d, column %d is greater than .5', row, col)
else
    sprintf('row %d, column %d is equal to .5', row, col)
end



%%
% for loop : median filter (also mean filter)
% Replace each voxel with the mean of the data within a
% neighborhood of that voxel


% Let's start by creating some "fake" image data

fake_data = normrnd(zeros(100,100), 10*ones(100,100) );
imagesc(fake_data)
colormap('gray')

[nrow, ncol] = size(fake_data);  %I'll need this later. filter

wind_size = 3;  % 3x3 window centered around each voxel
% tell only to put in odd number 
%if rem(wind_siz,.2)==0
%    sprintf("window size must be odd, change from %d to %d, 
%    wind_size=wind_size+1 


num_surround_vox = rem(winde_size,2);   % rem is remainder after division. identify if it is odd or even
pad_img = padarray(fake_data, [num_surround_vox, num_surround_vox], 0); % padarray adding zeroes edges:zero

med_filt = zeros(size(fake_data));
mean_filt = zeros(size(fake_data));
% in this loop will not generalize to other window size
for row=1:nrow
    for col=1:ncol
        row
        pad_ind_x = row+1;
        pad_ind_y = col+1;
        xrng = (pad_ind_x-num_surround_vox):(pad_ind_x+num_surround_vox);
        yrng = (pad_ind_y-num_surround_vox):(pad_ind_y+num_surround_vox);
        med_filt(row, col) = median(reshape(pad_img(xrng, yrng), 1, ...
                                            wind_size^2));
        mean_filt(row, col) = mean(reshape(pad_img(xrng, yrng), 1, ...
                                            wind_size^2));      
    end
end

subplot(1, 3, 1)
imagesc(fake_data)
colormap('gray')
subplot(1, 3, 2)
imagesc(med_filt)
colormap('gray')
subplot(1,3,3)
imagesc(mean_filt)
colormap('gray')



%%
% switch 

val=3;

switch val
  case 1
    disp('one')
  case 2
    disp('two')
  otherwise
    disp('other')
end


% If we used if/else

if val==1
    disp('one')
elseif val==2
    disp('two')
else
    disp('other')
end

% more characters and a little harder to read

% Switch is useful for strings and notice that it is easier with
% multiple cases (compare to if)

theStr = 'alpha'

switch theStr
  case {'alpha' 'bravo'}
    disp('a or b')
  case 'charlie'
    disp('c')
  otherwise
    disp('unknown')
end



%%
% while loop

% how many iterations until we sample a value greater than 0.999998?

iterationNum = 1;
val = rand(1,1);
while val<=0.9999998
    val=rand(1,1);
    iterationNum = iterationNum+1;
end



%% 
% Exit loop if it goes on for too long

iterationNum = 1;
val = rand(1,1);
while val<=0.9999998
    val=rand(1,1);
    iterationNum = iterationNum+1;
    if iterationNum>1000000
        break
    end
end

%%
% Plotting sin/cos function

x  = 0: .1 : 2*pi; % from 0 to 0.1 with step size 2pi
y1 = cos(x);
y2 = sin(x);

% Plot y1 vs. x (blue, solid) and y2 vs. x (red, dashed)
figure
plot(x, y1, 'b', x, y2, 'r.-', 'LineWidth', 2) %default plot line (x,y1) first line, (x,y2) second line

% Turn on the grid
grid on

% Set the axis limits
axis([0 2*pi -1.5 1.5]) % beginning of x, end of x, beginning of y, end of y

% Add title and axis labels
title('Trigonometric Functions', 'fontsize', 16)
xlabel('angle')
ylabel('sin(x) and cos(x)')
% Change font size on tick labels gca: get current axis 
set(gca, 'fontsize', 15)


% Add legend
legend('cos', 'sin')

% Save it to a pdf
print -dpdf ~/Desktop/my_plot.pdf


% hold on/off

plot(x, y1, 'g-')
hold on
plot(x, y2, 'r-')
hold off

%%
% Easy to plot columns of matrices as separate lines
% plus an example using handles
dat = [y1', y2'];
h = plot(x,dat); %handle

get(h)
get(h(1))  % getting information for the first line
set(h(1), 'LineWidth', 2, 'Color', 'green')


%%
% plotting images

% I'm assuming most of our images with be greyscale

fake_data = rand(100,100);
%uniform choose 100x100 matrix from uniform (1~0) 

subplot(2,1,1)
image(fake_data)  % doesn't use full colormap
subplot(2,1,2)
imagesc(fake_data)  %uses full colormap, better representation of data

subplot(1,1,1)
imagesc(fake_data)
colormap('gray') %change image to greyscale
colorbar



% can also use imshow
figure
imshow(fake_data) %probably not well with small images
colorbar

%%%%%%%
% Day 2

%%
% Structure arrays (cramp a lot of object). period is special in matlab
% indicate the structure

% really simple
dat = rand(100,1);
output.mean = mean(dat);
output.sd = std(dat);
output.median = median(dat);

% More complicated put in different patients' information
patient(1).name = 'John Doe';
patient(1).billing = 127.00;
patient(1).test = [79, 75, 73; 180, 178, 177.5; 220, 210, 205];

patient(2).name = 'Ann Lane';
patient(2).billing = 28.50;
patient(2).test = [68, 70, 68; 118, 118, 119; 172, 170, 169];

% What if we add a field to one level of the array that isn't in
% the other levels?

%Each patient's info is in a separate element

% Can count the number of elements
numel(patient)

%%
% Speaking of structured arrays... reading and writing NIFTI images
% get toolbox here
% http://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image
addpath /Documents/Research/matlabcode/NIfTI_20140122/
!gunzip ~/Documents/Research/Teaching/BMI567/IntroMatlab/mprage_defaced_brain.nii.gz
%ignores the header and orient properly
data_struct = load_untouch_nii('~/Documents/Research/Teaching/BMI567/IntroMatlab/mprage_defaced_brain.nii');
!gzip ~/Documents/Research/Teaching/BMI567/IntroMatlab/mprage_defaced_brain.nii

data_struct
data_struct.hdr
% the data (slice 100)
size(data_struct.img)
imagesc(data_struct.img(:, :, 100)) %pick hundred slice
colormap('gray')
colorbar


% Note:  even reading in with load_nii won't fix it!


% Can carry out math on image 
data_struct.img(100,100,100)
newdat = data_struct.img/500;
newdat(100,100,100)
%What's wrong?
data_struct.img(100,100,100)
newdat = double(data_struct.img/500);
newdat(100,100,100)
%What's wrong?

data_save_struct = data_struct; %copy
data_save_struct.img = newdat; %put in new data

% Other possibly important fields to check (if you're saving the
% data)

data_struct.hdr.dime.dim(5)  % number of time points
data_struct.hdr.dime.datatype   % Change to 16 if you now have
                                % float32
% More info here http://nifti.nimh.nih.gov/nifti-1/documentation/nifti1fields/nifti1fields_pages/datatype.html
data_struct.hdr.dime.bitpix
% http://nifti.nimh.nih.gov/nifti-1/documentation/nifti1fields/nifti1fields_pages/bitpix.html

data_save_struct.dime.datatype=16

% Also check any saved image for a R/L swap
%viwer load_nii view_nii
%f=@(X)  evaluate each x 
%fzero find zero of function. get initial input and find the zero  can also
%feed function with certain interval (to find answer in) 
%roots 
%repmat repeat the matrix
%reshape change the shape of matrix from matrix to vector reshape(row,
%column) 

%4D to 3d

%save_untouch_nii .. save images 