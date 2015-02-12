function [mean_est, sd_est, median_est, n] = simple_stats(vec_in)
% Function for computing simple statistics from a vector of data
% [mean, sd, median, n] = simple_stats(vec_in)
% vec_in: vector of data
% mean_est: mean
% sd_est: standard deviation
% median_est: median
% n: sample size

% Verify only 1 input
if nargin ~=1 %nargin:how many argument fed into the function
    error('Only 1 input vector is allowed')
end


%  isvector: Verify that input is a vector
if isvector(vec_in) == 0
    error('input must be a vector') % spit out and stops the function
end


mean_est = mean(vec_in);
sd_est = std(vec_in);
median_est = median(vec_in);
n = length(vec_in);
% comment in the funtion line is the help (have to continous chunk)
% if want to output contain all information 
%[mn_est,sd_est, md_est]=





%%
function [mn_val]=mean_est_func(vec_in)
