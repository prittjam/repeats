function draw2d_repeated_lafs2(ax0,u,vis,varargin)

colors = varycolor(ceil(1.2*size(vis,2)));

if isempty(varargin)
    varargin0 = {'LineWidth',3};
else
    varargin0 = varargin;
end

for i = 1:size(vis,2)
    varargin = cat(2,varargin0{:},{'Color',colors(i,:)});
    draw2d_lafs(gca,u(:,nonzeros(vis(:,:))),varargin{:});
end