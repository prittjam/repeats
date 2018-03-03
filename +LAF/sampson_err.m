function err = sampson_err(u,H)
u2 = [reshape(u(1:9,:),3,[]); ...
      reshape(u(10:18,:),3,[])];
err = reshape(fHDs(inv(H),u2),3,[]);