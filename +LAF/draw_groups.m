function draw_groups(ax0,u,labeling,varargin)
cfg.exclude = 0;
cfg.color = '';
cfg.chain = [];
cfg.linewidth = 4;
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

ulabeling = unique(labeling);
udraw_labeling = setdiff(ulabeling,cfg.exclude);
mpdc = distinguishable_colors(max(udraw_labeling)+1);
cmap = [0:max(udraw_labeling)];

mu = [(u(1:2,:)+u(4:5,:)+u(7:8,:))/3];

if isempty(cfg.chain)
    for k = 1:numel(udraw_labeling)
        idx = find(labeling == udraw_labeling(k));
        color = mpdc(find(cmap==udraw_labeling(k)),:);
        if ~isempty(cfg.color)
        	color = cfg.color;
        end
        LAF.draw(ax0,u(:,idx),'Color',color,'LineWidth',cfg.linewidth);
        if numel(unique(labeling)) > 1
            text(mu(1,idx)',mu(2,idx)', ...
                 num2str(udraw_labeling(k)), ...
                 'Color',color);
        end
    end
else
    idx = labeling ~= cfg.exclude;
    chain = cfg.chain;
    keepmserp = chain{1}{2}.upg2dr([chain{1}{4}.affpt(:).id]);
    keepmserm = chain{2}{2}.upg2dr([chain{2}{4}.affpt(:).id]);

    chain{1}{1}.rle = chain{1}{1}.rle(:,keepmserp);
    chain{2}{1}.rle = chain{2}{1}.rle(:,keepmserm);
    MSER.draw(gca,chain{1}{1},'LineWidth',cfg.linewidth,'Color',rgb('SpringGreen'));
    MSER.draw(gca,chain{2}{1},'LineWidth',cfg.linewidth,'Color',rgb('SpringGreen'));

    A = LAF.p3x3_to_A(u(:,idx));
    ELL.draw_A(gca,A,'Color',rgb('Indigo'),'LineWidth',cfg.linewidth);
    
    tdru = u(:,idx);
    tdru(1:3,:) = tdru(7:9,:);
    LAF.draw(ax0,tdru,'Color',rgb('Red'),'LineWidth',cfg.linewidth);
    
    hold on;
    plot(gca,tdru(7,:),tdru(8,:),'*', ...
        'MarkerSize',8,'LineWidth',cfg.linewidth,'Color',rgb('Red'));
    plot(gca,tdru(4,:),tdru(5,:),'+', ...
        'MarkerSize',15,'LineWidth',cfg.linewidth,'Color',rgb('Indigo'));
end