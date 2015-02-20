%Q2
for i=46*46
    activation(j)=tstat(i)>2;
end

subplot(1,2,1)
plot(mriMat)
subplot(1,2,2)
imagesc(reshape(mriMat(activation)),64,64))

%Q3
wind_size=3;

num_surround_vox = (wind_size - 1)/2;
%num_surround_vox = rem(wind_size,2);   % rem is remainder after
                                       % division
pad_img = padarray(newdat(:,:,1), [num_surround_vox, num_surround_vox], 0);

mean_filt = zeros(size(newdat,1));
nrow=64;
ncol=64;
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
wind_size=9;
num_surround_vox = (wind_size - 1)/2;
%num_surround_vox = rem(wind_size,2);   % rem is remainder after
                                       % division
pad_img = padarray(newdat(:,:,1), [num_surround_vox, num_surround_vox], 0);

mean_filt = zeros(size(newdat,1));
nrow=64;
ncol=64;
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
