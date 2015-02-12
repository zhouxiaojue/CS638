function [reg] = regressor(tr_dat, ntpts, tr_conv, onsets,durst)
%tr_dat: time resolution for BOLD data
%ntpts: number of time points
%tr_conv: time resolution for convolution
%onsets: 
%durst: duration of each time
t_conv = 0:tr_conv:(tr_dat*(ntpts-1));  

% to get the box plot
durs = durst*ones(size(onsets));

reg1_unconv = zeros(size(t_conv));
num_trials = length(onsets); 
for i=1:num_trials
     reg1_unconv(onsets(i)<=t_conv & t_conv<=(onsets(i)+durs(i))) ...
         = 1;
end

% Create hrf and convolve

% HRF is based on 2 gamma functions
hrf = spm_hrf(tr_conv);

reg = conv(reg1_unconv, hrf);

% Downsample to resolution of BOLD data
reg = reg(1:(tr_dat/tr_conv):(length(t_conv)));
t_bold = t_conv(1:(tr_dat/tr_conv):(length(t_conv)));