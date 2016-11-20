function [M,G_app,res,stats] = greedy_repeats(dr,varargin)
G_app = group_desc(dr);
sampler = VlSampler(G_app);
eval = VlEval();
model = RANSAC.laf3x1_to_HaHp_model();
lo = Lo();
ransac = RANSAC.Ransac(model,sampler,eval,'lo',lo);
[H,res,stats] = ransac.fit(dr,G_app);
v = LAF.renormI(blkdiag(H,H,H)*[dr(:).u]);
[corresp,X,Rt] = segment_motions(dr,findgroups(G_app.*res.cs));

keyboard;

cframes = join(corresp(corresp.G_rt > 0, ...
                       {'G_rt','G_app', 't_i'}), X, ...
               'Keys',{'G_rt','G_app'});
xforms = join(cframes, Rt, 'Keys',{'G_rt'});
y_ii = LAF.translate(xforms{:,'X0'}',xforms{:,'t_i'}');
y_jj = LAF.translate(y_ii,xforms{:,'Rt'}');

[G1,uG1] = findgroups(corresp(corresp.G_rt >0 ,{'G_rt','G_app'}));
cmap = distinguishable_colors(size(uG1,1));
colors = cmap(G1,:);

keyboard;
figure;
cmp_splitapply(@(v,color) LAF.draw(gca,v,'Color',color), ...
               [dr(:,corresp(corresp.G_rt > 0,'jj')).u],colors,G1);
figure;
cmp_splitapply(@(v,t,color) draw_it(gca,v,t,color), ...
               cframes(cframes.G_rt > 0,{'X0','t_i'}),colors,G1);


function [] = draw_it(gca,u,t,color)
v = LAF.translate(u,t);
LAF.draw(gca,v,'Color',color);

%function draw_cframes()
%
%draw_cframes
%figure;
%subplot(1,2,1);
%u = LAF.renormI(blkdiag(M,M,M)*[dr(:).u]);
%
%keyboard;
%LAF.draw(gca,u);
%
%subplot(1,2,2);
%LAF.draw(gca,[y_ii y_jj]);
%
%figure;
%LAF.draw(gca,[y_ii]);
%
%figure;
%LAF.draw(gca,[y_jj]);
%
%y_ii = refine_cframes(corresp,X,Rt);

%cmp_splitapply(@draw_cframes,



%colors2 = distinguishable_colors(max(corresp{:,{'G_rt'}}));
%tmp = corresp{G_rt > 0,{'G_rt'}};
%ttt = corresp{G_rt > 0,{'t_ij'}};
%gcolors = colors2(tmp,:);
%
%figure;
%cmp_splitapply(@draw_pts,ttt',gcolors',tmp');
%
%
%res = join(corresp(G_rt > 0,:),X,'Keys',{'G_rt','G_app'});
%
%
%{g,
%
%
%function [] = draw_pts(vv,color)
%hold on;
%scatter(vv(1,:),vv(2,:),10,color','filled');
%hold off;
%
%function [] = draw_cframes(X,Rt,corresp)
%for k = 1:size(X,1)
%
%end
%
%draw_cframes(X,cframes);


%figure;
%hold on;
%scatter(vv(1,ig),vv(2,ig),8,colors,'filled');
%scatter(vv(1,nig),vv(2,nig),20,cmap(end-1,:),'d');
%%draw_circles(vv(:,bandwidths > 0.1),bandwidths(bandwidths > 0.1));
%scatter(clust(1,:),clust(2,:),20,cmap(end,:),'*');
%hold off; 
%axis equal;

%function [] = draw_cframes(X,cframes)
%figure;
%hold on;
%
%for k = 1:max(table
%
%end