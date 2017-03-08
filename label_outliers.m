function G = label_outliers(err)
sigma = max([1.4826*mad(err) 1]);
err = reshape_err(err);
err2 = sum(err.^2);
G = err2 < 21.026*sigma^2;

function err = reshape_err(err)
err = reshape(err,6,[]);
err = [ err(:,1:end/2); ...
        err(:,(end/2+1):end) ];
