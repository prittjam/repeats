%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = draw2d_UGMMF(X,model)

[d,m] = size(X);

dt = 0.1
xx = [-3:dt:3];

figure; 

for k = 1:d
    n = hist(X(k,:),xx);
    area = trapz(dt*n);
    n = n/area;

    subplot(1,4,k);

    y1 = 1/sqrt(2*pi)/model.Sigma*exp(-((xx-model.mu(k))/2/model.Sigma).^2);
    y2 = model.U*ones(size(xx));
    y3 = model.prior(1)*y1+model.prior(2)*y2;

    hold on;
    %    plot(xx,y1,'b','LineWidth',3);
    %   plot(xx,y2,'r','LineWidth',3);
    plot(xx,y3,'g','LineWidth',3);
    plot(xx,n,'k');
    hold off;
end



jjj = 3;