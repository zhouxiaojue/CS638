% Examples of flow control

%%
% if

a = rand(3,3);  % uniform random variable
row = 1;
col = 3;

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

[nrow, ncol] = size(fake_data);  %I'll need this later

wind_size = 3;  % 3x3 window centered around each voxel

if rem(wind_size,2) == 0
    sprintf('Window size must be odd, changing from %d to %d', ...
            wind_size, wind_size + 1)
    wind_size = wind_size + 1;
end

num_surround_vox = (wind_size - 1)/2;
%num_surround_vox = rem(wind_size,2);   % rem is remainder after
                                       % division
pad_img = padarray(fake_data, [num_surround_vox, num_surround_vox], 0);

med_filt = zeros(size(fake_data));
mean_filt = zeros(size(fake_data));

for row=1:nrow
    for col=1:ncol
        row
        pad_ind_x = row + 1;
        pad_ind_y = col + 1;
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

x  = 0: .1 : 2*pi;
y1 = cos(x);
y2 = sin(x);

% Plot y1 vs. x (blue, solid) and y2 vs. x (red, dashed)
figure
plot(x, y1, 'b', x, y2, 'r.-', 'LineWidth', 2)

% Turn on the grid
grid on

% Set the axis limits
axis([0 2*pi -1.5 1.5])

% Add title and axis labels
title('Trigonometric Functions', 'fontsize', 16)
xlabel('angle')
ylabel('sin(x) and cos(x)')
% Change font size on tick labels
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
h = plot(x,dat);

get(h)
get(h(1))
set(h(1), 'LineWidth', 2, 'Color', 'green')

%% START HERE

% gca : return handle of current axes
% gcf : return handle of current figure
% get : Query values of object's property
% set : Set values of object's properties

fh = figure
ah = plot(x,dat)

% Sometimes you want less white space on the edge of a figure

figure
plot(x,dat);
print(gcf, '-dpdf', '~/Desktop/figure_try1.pdf');  %note the syntax is slightly
                                       %different than what I used
                                       %above.  function syntax vs
                                       %command syntax

get(gcf)
get(gcf, 'PaperSize')  % How big is the "paper"
get(gcf, 'PaperPositionMode')
get(gcf, 'PaperPosition')  % Left, bottom, width, height

figure
plot(x,dat);
% gcf = get current figure handle
set(gcf, 'PaperSize', [10 5]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 10 5]);
print(gcf, '-dpdf', '~/Desktop/figure_try2.pdf')


figure
plot(x,dat)
% This is equivalent
set(gcf, 'PaperSize', [10,5], ...
         'PaperPositionMode', 'manual', ...
         'PaperPosition', [0 0 10 5])
print(gcf, '-dpdf', '~/Desktop/figure_try3.pdf')



%%
% plotting images

% I'm assuming most of our images with be greyscale

fake_data = rand(100,100);

figure
subplot(2,1,1)
image(fake_data)  % doesn't use full colormap
subplot(2,1,2)
imagesc(fake_data)  %uses full colormap

subplot(1,1,1)
imagesc(fake_data)
colormap('gray')
colorbar


% can also use imshow
figure
imshow(fake_data)
colorbar


%%
% Structure arrays

% really simple
dat = rand(100,1);
output.mean = mean(dat);
output.sd = std(dat);
output.median = median(dat);

% More complicated
patient(1).name = 'John Doe';
patient(1).billing = 127.00;
patient(1).test = [79, 75, 73; 180, 178, 177.5; 220, 210, 205];

patient(2).name = 'Ann Lane';
patient(2).billing = 28.50;
patient(2).test = [68, 70, 68; 118, 118, 119; 172, 170, 169];

% What if we add a field to one level of the array that isn't in
% the other levels?

% Each patient's info is in a separate element

% Can count the number of elements
numel(patient)


%%
% Speaking of structured arrays... reading and writing NIfTI images
% get toolbox here
% http://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image
addpath /Users/kaeda/Documents/uw/2015spring/CS638/HW1/NIfTI_20140122
!gunzip ~/Documents/Research/Teaching/BMI567/IntroMatlab/mprage_defaced_brain.nii.gz
data_struct = load_untouch_nii('/Users/kaeda/Documents/uw/2015spring/CS638/HW1/bold_mcf_brain_slice14.nii.gz');
!gzip ~/Documents/Research/Teaching/BMI567/IntroMatlab/mprage_defaced_brain.nii

% the data (slice 100)
size(data_struct.img)
imagesc(data_struct.img(:, :, 100))
colormap('gray')
colorbar


% Can carry out math on image 
data_struct.img(100,100,100)
newdat = double(data_struct.img)/500;
newdat(100,100,100)
%What's wrong?

data_save_struct = data_struct;
data_save_struct.img = newdat;

% Other possibly important fields to check (if you're saving the
% data)

%data_struct.hdr.dime.dim(5)  % number of time points
%data_struct.hdr.dime.datatype   % Change to 16 if you now have
                                % float32

%data_struct.hdr.dime.bitpix

% See table here
% http://brainder.org/2012/09/23/the-nifti-file-format/ for
% matching bitpix and datatype
data_save_struct.hdr.dime.datatype = 16;
data_save_struct.hdr.dime.bitpix = 32;

% Also check any saved image for a R/L swap

save_untouch_nii(data_save_struct, '~/Desktop/img_try1.nii')

% Write a 4D file using a 3D header
img_dat = double(data_struct.img);
newdat2=zeros([size(newdat), 3]);

newdat2(:,:,:,1) = img_dat;
newdat2(:,:,:,2) = 2*img_dat;
newdat2(:,:,:,3) = 3*img_dat;

data_save_struct2 = data_struct;
data_save_struct2.img = newdat2;
% See table here
% http://brainder.org/2012/09/23/the-nifti-file-format/ for
% matching bitpix and datatype
data_save_struct2.hdr.dime.bitpix = 32;
data_save_struct2.hdr.dime.datatype = 16;
data_save_struct2.hdr.dime.dim(1) = 4;
data_save_struct2.hdr.dime.dim(5) = 3;

% What else needs changing


save_untouch_nii(data_save_struct2, '~/Desktop/img_4D.nii')


% Let's check out the viewer  
!gunzip ~/Documents/Research/Teaching/BMI567/IntroMatlab/mprage_defaced_brain.nii.gz
data_struct_no_untouch = load_nii('~/Documents/Research/Teaching/BMI567/IntroMatlab/mprage_defaced_brain.nii');
!gzip ~/Documents/Research/Teaching/BMI567/IntroMatlab/mprage_defaced_brain.nii

view_nii(data_struct_no_untouch)



%%%%%
%Other helpful odds and ends

%%%
% function handlers

% what if you want to specify the funcion
% f(x) = 5*sin(x) - x^2 +3?

f = @(x) 5*sin(x) - x.^2 +3;
f(3)
f(1:3)

% Why would you need this?  Perhaps you need to find the zeros of a
% function 

help fzero

fun = @(x) sin(x); % function
x0 = 3; % initial point
x = fzero(fun,x0)

% Can also give an initial interval
x0 = [2, 4];
x = fzero(fun, x0)

% If you simply have a polynomial, you can use roots
% Root of f(x) = x^2 -x - 2?  

roots([1 -1 -2])

% How about f(x) = x^4 - 1?
roots([1 0 0 0 -1 ])


% repmat - repeat a matrix

a = [1 2 3; 4 5 6]
repmat(a, 2, 3)

% Reshape (change shape of matrix)

reshape(a, 1, 6)
reshape(a, 3, 2)
