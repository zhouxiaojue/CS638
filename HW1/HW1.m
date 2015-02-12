%Q2
addpath /Users/kaeda/Documents/uw/2015spring/CS638/HW1/NIfTI_20140122
data_struct = load_untouch_nii('/Users/kaeda/Documents/uw/2015spring/CS638/HW1/bold_mcf_brain_slice14.nii.gz');
newdat=squeeze(data_struct.img(:,:,1,:));
q2=load('task001_run001_stopfail_ons.txt');
%first column: onsets, second column: durations, TR:2s, time for
%convolution: 0.125s 
%tr_dat: time resolution for BOLD data
%ntpts: number of time points
%tr_conv: time resolution for convolution
%onsets: 
%durst: duration of each time
% X = zeros(size(q2,1), size(newdat,3));
% for i=1:size(q2,1)
%     X(i,:)=regressor(2,182,0.125,q2(i,1),q2(i,2));
% end
X = regressor(2,182,0.125,q2(:,1)',q2(:,2));

% Make X a column vector to match equations in text
X=X';

% Compute covariance
covariance = X'*X;

% Inverse covariance
invcov = inv(covariance);

z = X'*double(mriMat);

invcov * z

c=[0,1,0]';
for i=1:64
    for j= 1:64
        beta(i)=inv(X*X')*X'*data_struct.img(i,j,:);
    end
end


%Q3
wind_size=3

num_surround_vox = (wind_size - 1)/2;
%num_surround_vox = rem(wind_size,2);   % rem is remainder after
                                       % division
pad_img = padarray(fake_data, [num_surround_vox, num_surround_vox], 0);

mean_filt = zeros(size(fake_data));

for row=1:nrow
    for col=1:ncol
        row
        pad_ind_x = row + 1;
        pad_ind_y = col + 1;
        xrng = (pad_ind_x-num_surround_vox):(pad_ind_x+num_surround_vox);
        yrng = (pad_ind_y-num_surround_vox):(pad_ind_y+num_surround_vox);
         mean_filt(row, col) = mean(reshape(pad_img(xrng, yrng), 1, ...
                                            wind_size^2));   
    end
end
imagesc(mean_filt)


%%%%%%%%%windowsize=9
wind_size=9
num_surround_vox = (wind_size - 1)/2;
%num_surround_vox = rem(wind_size,2);   % rem is remainder after
                                       % division
pad_img = padarray(fake_data, [num_surround_vox, num_surround_vox], 0);

med_filt = zeros(size(fake_data));

for row=1:nrow
    for col=1:ncol
        row
        pad_ind_x = row + 1;
        pad_ind_y = col + 1;
        xrng = (pad_ind_x-num_surround_vox):(pad_ind_x+num_surround_vox);
        yrng = (pad_ind_y-num_surround_vox):(pad_ind_y+num_surround_vox);
         mean_filt(row, col) = mean(reshape(pad_img(xrng, yrng), 1, ...
                                            wind_size^2));   
    end
end
imagesc(mean_filt)

tstat()
