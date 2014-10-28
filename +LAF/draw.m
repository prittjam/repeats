function h1 = draw(ax1,u,varargin)
x = reshape(u(1:3:end,:),3,[]);
y = reshape(u(2:3:end,:),3,[]);

mpdc = distinguishable_colors(size(u,2));
hold(ax1,'on');
set(ax1,'ColorOrder',mpdc); 
h1 = plot(ax1,x,y,varargin{:});
hold(ax1,'off');