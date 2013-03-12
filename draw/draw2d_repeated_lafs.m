function draw2d_repeated_lafs(ax0,u,vis,varargin)

if nargin < 4
    line_style = '-o';
end

colors = varycolor(size(vis,2));
for j = 1:size(vis,2)
    draw2d_lafs(ax0,u(:,nonzeros(vis(:,j))), ...
                'Color',colors(j,:), ...
                varargin{:});
    kkk = 3;    
end

%vist = vis';
%ss = sum(vist>0,2);
%vist = vist(find(ss),:);
%
%iv = nonzeros(vist);
%[ii,~] = find(vist);
%
%color_set = varycolor(max(ii));
%color_set = color_set(ii,:);
%
%tmp = get(gca,'ColorOrder');
%set(gca,'ColorOrder',color_set);
%
%x = reshape(u(1:3:end,iv),3,[]);
%y = reshape(u(2:3:end,iv),3,[]);
%
%hold all;
%h1 = plot(x,y,line_style, ...
%          'LineWidth'       , 2, ...
%          'MarkerEdgeColor','k', ...
%          'MarkerFaceColor',[.49 1 .63], ...
%          'MarkerSize',4);
%
%plot(x(1:3:end)',y(1:3:end)','o', ...
%     'LineWidth'       , 2, ...
%     'MarkerEdgeColor','k', ...
%     'MarkerFaceColor',[0.43 0.81 0.96], ...
%     'MarkerSize',5);
%hold off;
%
%set(gca,'ColorOrder', tmp);