% Example of use of convolution to create regressor for fMRI model

% Change the following path to wherever you have stuck the lecture directory
addpath /Users/kaeda/Documents/uw/2015spring/CS638/lec3/

tr_dat = 2;       % Time resolution of the BOLD data
ntpts = 182;      % Number of time points in BOLD data
 
tr_conv = 0.1;    % Time resolution for convolution
t_conv = 0:tr_conv:(tr_dat*(ntpts-1));  

% to get the box plot
onsets = [12, 35, 44.6, 90.756, 100.22, 150.33, 178.6, 200.5, 225.25, ...
          332.7, 355];
durs = 1.5*ones(size(onsets));
%1.5 second long
%start at sezros
reg1_unconv = zeros(size(t_conv));
num_trials = length(onsets); 
for i=1:num_trials
     reg1_unconv(onsets(i)<=t_conv & t_conv<=(onsets(i)+durs(i))) ...
         = 1;
end
%t_conv less or equal to... change matrix to one
plot(t_conv, reg1_unconv)
axis([0,400,0,1.1]) 
%check 

% Create hrf and convolve

% HRF is based on 2 gamma functions
x_gamma = 0:.1:5;
plot(x_gamma, gampdf(x_gamma, 2, .5))
%plot gamma against 
%hemoglobin spm function
hrf = spm_hrf(tr_conv);
plot(hrf)

reg1 = conv(reg1_unconv, hrf);

% Downsample to resolution of BOLD data
reg1 = reg1(1:(tr_dat/tr_conv):(length(t_conv)));
t_bold = t_conv(1:(tr_dat/tr_conv):(length(t_conv)));


plot(t_conv, reg1_unconv)
hold on
plot(t_bold, reg1, 'r')
hold off
%boxes smaller than 