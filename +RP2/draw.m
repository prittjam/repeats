function h1 = draw(ax1,u,varargin)
    if size(u,1)==2
        u = PT.homogenize(u);
    end
    
    cfg.labels = [];
    [cfg,leftover] = cmp_argparse(cfg,varargin{:});

    m = size(u,1);
    m2 = m/3;
    
    if ~any(strcmpi('color',leftover))
        mpdc = distinguishable_colors(size(u,2));
        set(ax1,'ColorOrder',mpdc); 
    end
    
    x = reshape(u(1:3:end,:),m2,[]);
    y = reshape(u(2:3:end,:),m2,[]);
    
    hold(ax1,'on');
    if isempty(leftover)
        scatter(u(1,:),u(2,:),40,'filled');
    else
        scatter(u(1,:),u(2,:),leftover{:});
    end
    hold(ax1,'off');