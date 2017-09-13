% Copyright (c) 2017 James Pritts
% 
function [X,labels,s0,M,s2,Xborder,Xborder2] = ...
    make_scene_plane(varargin)

cfg.do_outliers = 0;
cfg.do_rotate = false;

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

params = [60 90; ...  % scene plane height [h]
          60 90; ...  % scene plane width [w]
          5 5; ...    % template height [h2]
          5 5; ...    % template width  [w2]
          5 5]; ...  % number of lafs in template [nlafs];

params(5,2) = params(5,2)+1-eps;
rv = params(:,1)+(params(:,2)-params(:,1)).*rand(5,1);

maxr = floor(rv(1)/rv(3));
maxc = floor(rv(2)/rv(4));

params2 = [4 4; ...   % number of instance rows
           4 4];      % number of instance columns  

params2(1:2,2) = params2(1:2,2)+1-eps;
rv2 = params2(:,1)+(params2(:,2)-params2(:,1)).*rand(2,1);
rv = cat(1,rv,rv2);
rv([5 6 7]) = floor(rv([5 6 7]));

h = rv(1);
w = rv(2);
h2 = rv(3);
dy = (rv(1)-rv(3)*rv(6))/rv(6);
w2 = rv(4);
dx = (rv(2)-rv(4)*rv(7))/rv(7);
num_lafs = rv(5);
num_rows = rv(6);
num_cols = rv(7);

num_pts = 3*num_lafs;

g = [0 0 -1]'; % gravity direction
z2 = [1 0 0]';
x2 = cross(z2,g);
y2 = cross(z2,x2);

%M1 = [1  0 -w/2; ...
%      0 -1  h/2; ...
%      0  0    0; ...
%      0  0    1];  
%M0 = [ [x2 y2 z2] [0 0 h/2]'; ...
%       [0 0 0 1] ];
%
model_xform = eye(4);
%model_xform = M0*M1;

[u,xu] = sim.make_template(num_pts,w2,h2);

T = sim.make_template_xforms(num_rows,num_cols,w2,h2,dx,dy,cfg.do_rotate);

% make scene plane
X = [];
Xborder2 = [];
num_inliers = 0;
s0 = sparse([],[],[],num_lafs,num_rows*num_cols*num_lafs,false);
s2 = sparse([],[],[],num_lafs,num_rows*num_cols*num_lafs,false);

labels = zeros(1,num_rows*num_cols);

for r = 1:num_rows
    for c = 1:num_cols
        Xborder2 = cat(2,Xborder2,model_xform*T{r,c}*xu);
        ind = num_lafs*num_cols*(r-1)+num_lafs*(c-1)+[1:num_lafs];
        if cfg.do_outliers > eps
            pb = repmat(rand(1,size(u,2)/3) < cfg.do_outliers,3,1);
            pb = pb(:);

            u2 = ones(size(u));
            u2(:,~pb) = u(:,~pb);

            k = sum(pb);
            v = ones(3,k);
            v(1:2,:) = reshape(rand(1,2*k),2,[]);
            vz = cross(v(:,1:3:end)-v(:,2:3:end), ... 
                       v(:,3:3:end)-v(:,2:3:end));
            s1 = repmat(vz(3,:) < 0,3,1);
            ib = find(s1);
            tmp = v(:,ib(1:3:end));
            v(:,ib(1:3:end)) = v(:,ib(3:3:end));
            v(:,ib(3:3:end)) = tmp;

            u2(:,pb) = [[w2 0; 0 h2] [-w2/2 -h2/2]'; ...
                        0 0 1]*[1 0 0; 0 -1 1; 0 0 1]*v;

            X = cat(2,X,model_xform*T{r,c}*u2);
            num_inliers = num_inliers+sum(~pb)/3;

            pb2 = all(reshape(~pb,3,[]));
            ind2 = [1:num_lafs];
            s0(sub2ind(size(s0),ind2(pb2),ind(pb2))) = true;
            s2(sub2ind(size(s2),[1:num_lafs],ind)) = true;
            labels(ind(pb2)) = ind2(pb2);
            labels(ind(~pb2)) = num_lafs+1;
        else
            keyboard;
            X = cat(2,X,model_xform*T{r,c}*u);
            num_inliers = num_inliers+num_lafs;
            s0(sub2ind(size(s0),[1:num_lafs],ind)) = true;
            s2 = s0;
            lables(ind) = ind2;
        end
    end            
end 

Xborder = model_xform*[[0 0; w 0; w h; 0 h]';ones(1,4)];
M = inv(M0);
