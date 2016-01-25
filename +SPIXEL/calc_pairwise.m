function R = calc_pairwise(img,segments)
N = max(segments(:));

[Gx,Gy] = imgradientxy(rgb2gray(img.data),'Sobel');
[Nx,Ny] = imgradientxy(segments,'Sobel');
nrm = sqrt(Nx.^2 + Ny.^2);
Nx = Nx./nrm;       Ny = Ny./nrm;
Nx(isnan(Nx)) = 0;  Ny(isnan(Ny)) = 0;

response = abs(Nx.*Gx) + abs(Ny.*Gy);
response = response/max(response(:));

border = logical(abs(Nx)+abs(Ny));
border_thin = bwmorph(border,'thin');

[x y] = find(border_thin);
valid = x > 1 & x < img.height & y > 1 & y < img.width;
x = x(valid);       y = y(valid);
indxy = sub2ind(size(img.data),x,y);

offset = get_offset(segments);
nb = segments(bsxfun(@plus,indxy,offset'));
nb_cell = mat2cell(nb,ones(1,size(nb,1)),9);
ind = cellfun(@(t) get_ind(t,N),nb_cell,'UniformOutput',false);
all_ind = [ind{:}];
uind = unique(all_ind);

% counts of border pixels for each pair of superpixels
counts = zeros(N,N);
counts(uind) = histc(all_ind,uind);
counts = counts + counts';
counts(counts == 0) = 1;

% construct pairwise matrix
R = zeros(N,N);
for i = 1:numel(indxy)
	R(ind{i}) = R(ind{i}) + response(indxy(i))/numel(ind{i});
end
R = R + R';
R = R./counts;
b = 1/(2*mean((R(R>0)).^2));
R(R>0) = exp(-b*(R(R>0)).^2);


function ind = get_ind(array,N)
pairs = VChooseK(unique(array),2);
ind = sub2ind([N N],pairs(:,1),pairs(:,2))';

function offset = get_offset(M);
s=size(M);
N=length(s);
[c1{1:N}]=ndgrid(1:3);
c2(1:N)={2};
offset=sub2ind(s,c1{:}) - sub2ind(s,c2{:});
offset = offset(:);