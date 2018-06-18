N = 30;
p1 = 0.6;
p2 = 1-p1;
sigma = 2;

a = -50;
b = 50;
dx = abs(b-a);

X = [sigma*randn([1,int32(p1*N)]) dx*rand([1,int32(p2*N)])+a];

init.mu = 0;
init.Sigma = 6;
init.U = 1/abs(b-a);
init.prior = [0.5 0.5];

[label, model, llh, R] = UGMM.ugmm_em(X,init);

dt = 0.2
xx = [-50:dt:50];

n = hist(X,xx);
area = trapz(dt*n);
n = n/area;

y1 = 1/sqrt(2*pi)/model.Sigma*exp(-((xx-model.mu)/2/model.Sigma).^2);
y2 = init.U*ones(size(xx));
y3 = model.prior(1)*y1+model.prior(2)*y2;

y1gt = 1/sqrt(2*pi)/init.Sigma*exp(-((xx-init.mu)/2/init.Sigma).^2);
y3gt = init.prior(1)*y3+init.prior(2)*y3;

figure;
subplot(1,2,1);
hold on;

%hist(X,xx);
plot(xx,y1,'b','LineWidth',3);
plot(xx,y2,'r','LineWidth',3);
plot(xx,y3,'g','LineWidth',3);
plot(xx,n,'k');
hold off;

subplot(1,2,2);
hold on;
plot(xx,y1gt,'b','LineWidth',3);
plot(xx,y2,'r','LineWidth',3);
plot(xx,y3gt,'g','LineWidth',3);
plot(xx,n,'k');

hold off;

%disp(['Ground truth is Sigma: ' sigma^2] 
model.Sigma = sqrt(model.Sigma);
model
