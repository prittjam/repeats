function err = geman_mcclure(err,sigma)
err = sqrt(err.^2./(sigma^2+err.^2));
