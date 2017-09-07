function [G,err2] = label_inliers(err)
sigma = max([1.4826*mad(err) 1]);
err2 = reshape(err.^2,6,[]);
err2 = [ err2(:,1:end/2); ...
         err2(:,(end/2+1):end) ];
err2 = sum(err2);
G = err2 < 21.026*sigma^2;
