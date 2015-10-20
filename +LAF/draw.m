function h1 = draw(ax1,u,varargin)
cfg.Color = [];
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

if isempty(cfg.Color)
    mpdc = distinguishable_colors(size(u,2));
    set(ax1,'ColorOrder',mpdc); 
end

x = reshape(u(1:3:end,:),3,[])+0.5;
y = reshape(u(2:3:end,:),3,[])+0.5;
hold(ax1,'on');
h1 = plot(ax1,x,y,varargin{:});
% h2 = plot(ax1,u(7,:),u(8,:),'*',varargin{:});
hold(ax1,'off');