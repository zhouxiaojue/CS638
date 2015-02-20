function[tstat]=tstat(i)
%i:ith voxel 

addpath /Users/kaeda/Documents/uw/2015spring/CS638/HW1
q2=load('task001_run001_stopfail_ons.txt');
data_struct = load_untouch_nii('/Users/kaeda/Documents/uw/2015spring/CS638/HW1/bold_mcf_brain_slice14.nii.gz');
newdat=squeeze(data_struct.img(:,:,1,:));
X = regressor(2,182,0.125,q2(:,1)',q2(:,2));
% Make X a column vector to match equations in text
X=X';

% Compute covariance
covariance = X'*X;

% Inverse covariance
invcov = inv(covariance);
%every column is one voxel over 182 time points
mriMat = reshape(newdat,64*64,182)';
mriMat=double(mriMat);
z = X'*mriMat(:,i);

beta=invcov * z;

c=[0;1;0]';
var=((mriMat(:,i)-X.*beta)'*(mriMat(:,i)-X.*beta))/(182-2)
convariance_beta=var*invcov
tstat= (c*beta)/(sqrt(c*convariance_beta*c'))

% beta_hat=inv(X'*X)*X'*Bdat
% Var_e=(Bdat-X*beta_hat)'*(Bdat-X*beta_hat)/(nTRs-1-length(beta))
%  
% % Compute the t statistic
% c=[1; 0; 0];
% t_stat=c'*beta_hat/sqrt(Var_e*c'*inv(X'*X)*c)

end