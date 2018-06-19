function h1 = draw(ax1,u,varargin)
cfg.labels = [];
cfg.draw_centroid = false;
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

if ~any(strcmpi('color',leftover))
    mpdc = distinguishable_colors(size(u,2));
    set(ax1,'ColorOrder',mpdc); 
end

x = reshape(u(1:3:end,:),3,[]);
y = reshape(u(2:3:end,:),3,[]);

hold(ax1,'on');
if isempty(leftover)
    h1 = plot(ax1,x,y);
else
    h1 = plot(ax1,x,y,leftover{:});    
end

if ~isempty(cfg.labels)
    label_str = num2str(reshape(cfg.labels,1,[]));
    labels = regexp(label_str,'(\w+)','tokens');
    mu = [(u(1:2,:)+u(4:5,:)+u(7:8,:))/3];
    text(mu(1,:),mu(2,:),labels);
end

if cfg.draw_centroid
    mu = (u(1:2,:)+u(4:5,:)+u(7:8,:))/3;
    plot(mu(1,:),mu(2,:),'r+');
end

hold(ax1,'off');
