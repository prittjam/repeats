% Making some data:
% MAKE SURE YOU UNDERSTAND HOW THE DATA IS ARRANGED WITHIN THE GRAPH
years = 6; % try to change this number
groups = 5; % try to change this number
data1 = rand(100,years);
data2 = rand(100,years)+0.3;
groups1 = randi(groups,100,1)*2-1; % groups 1 3 5 7 9
groups2 = randi(groups,100,1)*2; % groups 2 4 6 8 10
legendEntries = {'A' 'B'};
colors = [1 0 0;0 0 1]; % red and blue

% And we start:
% =============
% we need a wider figure, with a white background:
figure('Color',[1 1 1],'Position',[178 457 1400 521])
main_ax = axes; % create a temporary axes
% we get the measurements of the plotting area:
pos = main_ax.Position;
% and divide it to our data:
width = pos(3)/years; % the width of each group
% the bottom left corner of each group:
corner = linspace(pos(1),pos(3)+pos(1),years+1);
clf % clear the area!
% Now we plot everything in a loop:
for k = 1:years
    % create a different axes for each group:
    ax = axes;
    boxplot(ax,[data1(:,k); data2(:,k)],[groups1; groups2]);
    ax.XTick = 1.5:2:(groups*2-0.5); % to "combine" the groups in pairs
    ax.XTickLabel = {'a','b','c','v','f'};
    % set the ylim to include all data:
    ax.YLim = [min([data1(:); data2(:)]) max([data1(:); data2(:)])];
    box off
    if k == 1 
        ylabel('Miles per Gallon (MPG)') % only for the most right axes 
    else
        ax.YTick = [];
    end
    xlabel(num2str(2000+k)) % the labels for the years
    ax.Position = [corner(k) 0.11 width 0.8];
    % this will color the data:
    for g = 1:2:numel(ax.Children.Children)-1
       ax.Children.Children(g).Color = colors(1,:);
       ax.Children.Children(g).MarkerEdgeColor = colors(1,:);
       ax.Children.Children(g+1).Color = colors(2,:);
       ax.Children.Children(g+1).MarkerEdgeColor = colors(2,:);
    end
    if k == years
        % you can try to change here the index to 1:2 and see if you like it:
        leg = legend(ax.Children.Children(20:21),legendEntries);
        leg.Position(1) = 0.92;
    end
end
% and finally we place the title:
main_ax = axes('Position',[corner(1) 0.11 width*years 0.815]);
title('Miles per Gallon by Vehicle Origin')
axis off
