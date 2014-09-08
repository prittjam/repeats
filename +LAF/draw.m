function h1 = draw(ax1,u,varargin)
x = reshape(u(1:3:end,:),3,[]);
y = reshape(u(2:3:end,:),3,[]);

if ~isempty(varargin) 
    hold all;
    h1 = plot(ax1,x,y,varargin{:});
    set(h1,varargin{:});
    hold off;
else
    hold on;
    h1 = plot(ax1,x,y,varargin{:});
    hold off;
end