function h1 = draw(ax1, s, varargin)
    s = reshape(s, 6, []);
    x = s(1:3:end,:);
    y = s(2:3:end,:);
    
    hold(ax1, 'on');
    h1 = plot(ax1, x, y, varargin{:});
    hold(ax1, 'off');
end