function x = mtx_solve_2x2(C,y)
A = reshape(cell2mat(C),2,2,[]);
M = [ A(2,2,:) -A(1,2,:)
     -A(2,1,:)  A(1,1,:) ] ;
M = bsxfun(@rdivide,M,A(1,1,:).*A(2,2,:)-A(1,2,:).*A(2,1,:));
x = [ reshape(M(1,:,:),2,[]).*y ; ...
      reshape(M(2,:,:),2,[]).*y ];
