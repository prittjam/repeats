% Created by Zuzana Kukelova 11.11.2014

%  H + r polyeig solver from Fitzgibbon
%
%  input  x - 5x2 matrix of 2D distorted measuremants
%         u - 5x2 matrix of 2D distorted measuremants
%


% 06.01.2013 - Kukelova


function [H k] = H5rFitz(x, u)

H{1} = 10000*rand(3,3);
k{1} = 10000;

rp = x(:,1).^2 + x(:,2).^2;
r = u(:,1).^2 + u(:,2).^2;

D1 = [ zeros(5,1)  zeros(5,1)  zeros(5,1) -x(:,1) -x(:,2) -ones(5,1) u(:,2).*x(:,1) u(:,2).*x(:,2) u(:,2);
       x(:,1) x(:,2) ones(5,1) zeros(5,1)  zeros(5,1)  zeros(5,1)  -u(:,1).*x(:,1) -u(:,1).*x(:,2) -u(:,1)];  
       
D2 = [ zeros(5,1)  zeros(5,1)  zeros(5,1) -r.*x(:,1) -r.*x(:,2) -rp-r  zeros(5,1)   zeros(5,1)  u(:,2).*rp ;
       r.*x(:,1) r.*x(:,2) r+rp zeros(5,1)  zeros(5,1)  zeros(5,1)   zeros(5,1)  zeros(5,1) -u(:,1).*rp];
       
D3 = [ zeros(5,1)  zeros(5,1)  zeros(5,1) zeros(5,1)  zeros(5,1)  -r.*rp zeros(5,1) zeros(5,1) zeros(5,1) ;
       zeros(5,1) zeros(5,1)  r.*rp zeros(5,1) zeros(5,1) zeros(5,1) zeros(5,1) zeros(5,1) zeros(5,1) ];       

[h, kv] = polyeig(D1(1:9,:),D2(1:9,:),D3(1:9,:)); 

for i = 1:18
    if kv(i) ~= Inf
        if abs(imag(kv(i))) < 10e-4
            k{i} = real(kv(i));
        else
            k{i} = 10000;
        end
    else
        k{i} = 10000;
    end
    H{i} = reshape(h(:,i),3,3);
end


    
end

