function [] = tc_draw_pt(u,varargin)
N = size(u,2);
K = nargin-1;

c = make_color_map(N);

for k = 1:K
    subplot(1,K,k);
    imshow(varargin{k});

    hold on;
    sh1 = scatter(u(1+3*(k-1),:),...
                  u(2+3*(k-1),:),...
                  15,c,'filled');
    set(sh1, 'SizeData', 15);
    hold off;
end


function c = make_color_map(N)
c = [ 1   0   0;
      0 0.8   0;
      1   1   0;
      0   0   0;
      0   0.5 0.5;
      0   0   1;
      1   0   1;
      .5   0   .5;
      1   .5  0;
     ];

k = ceil(N/size(c,1));
c = repmat(c,k,1);
c = c(1:N,:);