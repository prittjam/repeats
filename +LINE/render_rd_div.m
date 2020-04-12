function img = render_rd_div(img,q,cc,l,col,varargin)
cfg = struct('linewidth',5);
cfg = cmp_argparse(cfg,varargin{:});
linewidth = cfg.linewidth;
n = size(l,2);
if q < 0
    for k = 1:n
        c = reshape(LINE.rd_div(q,cc,l(:,k)),[],3);
        img = ...
            insertShape(img,'circle',c,'LineWidth',linewidth+3,'Color','w');
        img = ...
            insertShape(img,'circle',c,'LineWidth',linewidth,'Color',col(k,:));
    end
end