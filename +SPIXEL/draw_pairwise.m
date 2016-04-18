function [] = draw_pairwise(img,segments,pairwise,varargin)
N = max(segments(:));
cfg = struct('segments',1:N, ...
             'markersize',5);
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

[Nx,Ny] = imgradientxy(segments,'Sobel');
border = logical(abs(Nx)+abs(Ny));
border_thin = bwmorph(border,'thin');

N = max(segments(:));

[x y] = find(border_thin);
valid = x > 1 & x < img.height & y > 1 & y < img.width;
x = x(valid);
y = y(valid);
indxy = sub2ind(size(img.data),x,y);

offset = get_offset(segments);
nb = segments(bsxfun(@plus,indxy,offset'));
nb = sort(nb')';
ind = sub2ind([N N],nb(:,1),nb(:,9));

figure;
imshow(img.data);
hold on;
scatter(y,x,(50)*(1 - pairwise(ind)/max(pairwise(:))+eps),'filled','MarkerFaceColor','w');
% scatter(y,x,100*pairwise(ind)/max(pairwise(:))+eps,'filled');
 
for i = 1:N
	[x y] = find(segments == i);
	text(mean(y),mean(x), num2str(i));
end

function offset = get_offset(M);
s=size(M);
N=length(s);
[c1{1:N}]=ndgrid(1:3);
c2(1:N)={2};
offset=sub2ind(s,c1{:}) - sub2ind(s,c2{:});
offset = offset(:);

