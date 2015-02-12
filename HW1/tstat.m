function[tstat]=tstat(X,)
%reg: regressors


beta_hat=inv(X'*X)*X'*Bdat
Var_e=(Bdat-X*beta_hat)'*(Bdat-X*beta_hat)/(nTRs-1-length(beta))
 
% Compute the t statistic
c=[1; 0; 0];
t_stat=c'*beta_hat/sqrt(Var_e*c'*inv(X'*X)*c)