K=inline('exp(-(x.^2)/2/sigma^2)');
dx= -5:5;
sum(K(10,dx))
weight=K(10,dx)/sum(K(10,dx))
sum(weight)
t=1:100;
mu=(t-50).?2/500;
noise= normrnd(0, 2, 1,100);
Y=mu + noise
figure; plot(Y, ?.?);
smooth=conv(Y,weight,?same?);
hold on; plot(smooth, ?r?);