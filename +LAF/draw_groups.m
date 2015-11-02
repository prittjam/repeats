function draw_groups(ax0,u,labeling,varargin)
cfg.exclude = 0;
cfg.color = '';
cfg.chain = [];
cfg.linewidth = 3;
cfg.text = true;
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

ulabeling = unique(labeling);
udraw_labeling = setdiff(ulabeling,cfg.exclude);
mpdc = distinguishable_colors(max(udraw_labeling)+1);
cmap = [0:max(udraw_labeling)];

mu = [(u(1:2,:)+u(4:5,:)+u(7:8,:))/3];
su = LAF.shrink(u,1.5);
if isempty(cfg.chain)
    for k = 1:numel(udraw_labeling)
        idx = find(labeling == udraw_labeling(k));
        color = mpdc(find(cmap==udraw_labeling(k)),:);
        if ~isempty(cfg.color)
        	color = cfg.color;
        end
        LAF.draw(ax0,u(:,idx),'Color','black','LineWidth',cfg.linewidth+2);
        LAF.draw(ax0,su(:,idx),'Color',color,'LineWidth',cfg.linewidth);
        if numel(unique(labeling)) > 1 && cfg.text
            text(mu(1,idx)',mu(2,idx)', ...
                 num2str(udraw_labeling(k)), ...
                 'Color',color);
        end
    end
else
    chain = cfg.chain;
    inl = labeling ~= cfg.exclude;
    if numel(chain) > 1
        inl_mserp = inl(1:numel(chain{1}{4}.affpt));
        inl_mserm = inl(end-numel(chain{2}{4}.affpt)+1:end);

        mserp_id = [chain{1}{4}.affpt(:).id];
        mserm_id = [chain{2}{4}.affpt(:).id];
        mserp_id = mserp_id(~[chain{1}{4}.affpt(:).reflected] & inl_mserp);
        mserm_id = mserm_id(~[chain{2}{4}.affpt(:).reflected] & inl_mserm);
        keepmserp = chain{1}{2}.upg2dr(mserp_id);
        keepmserm = chain{2}{2}.upg2dr(mserm_id);

        chain{1}{1}.rle = chain{1}{1}.rle(:,keepmserp);
        chain{2}{1}.rle = chain{2}{1}.rle(:,keepmserm);
        MSER.draw(gca,chain{1}{1},'LineWidth',cfg.linewidth,'Color',rgb('SpringGreen'));
        MSER.draw(gca,chain{2}{1},'LineWidth',cfg.linewidth,'Color',rgb('SpringGreen'));
    end
    
    A = LAF.p3x3_to_A(u(:,inl));
    ELL.draw_A(gca,A,'Color',rgb('Indigo'),'LineWidth',cfg.linewidth);
    
    tdru = u(:,inl);
    tdru(7:9,:) = tdru(1:3,:);
    LAF.draw(ax0,tdru,'Color',rgb('Gold'),'LineWidth',cfg.linewidth);
    
    tdru = u(:,inl);
    tdru(1:3,:) = tdru(7:9,:);
    LAF.draw(ax0,tdru,'Color',rgb('Red'),'LineWidth',cfg.linewidth);
    
    hold on;
    plot(gca,tdru(7,:)+0.5,tdru(8,:)+0.5,'*', ...
        'MarkerSize',8,'LineWidth',cfg.linewidth,'Color',rgb('Red'));
    plot(gca,tdru(4,:)+0.5,tdru(5,:)+0.5,'+', ...
        'MarkerSize',25,'LineWidth',cfg.linewidth,'Color',rgb('Indigo'));
end