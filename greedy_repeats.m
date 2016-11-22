function [H,G_app,res,stats] = greedy_repeats(dr,varargin)


G_app = group_desc(dr);
sampler = GrSampler(G_app);
eval = GrEval();
model = RANSAC.laf3x1_to_HaHp_model();
lo = GrLo();
ransac = RANSAC.Ransac(model,sampler,eval,'lo',lo);

[H0,res,stats] = ransac.fit(dr,G_app);

u = [dr(:).u];
is_converged = false;
while ~is_converged
    v = LAF.renormI(blkdiag(H0,H0,H0)*u);
    [corresp,U,Rt] = segment_motions(v,findgroups(G_app.*res.cs));
    good_corresp = corresp(corresp.G_rt > 0,:); 
    keyboard;
    H = refine_motions(u,H0,q0,cc,corresp,U,Rt);
    H0 = H;
    is_converged = true;
end

[G1,uG1] = findgroups(good_corresp(:,'G_rt'));
numG = 1:numel(G1);

%figure;
%xx2 = ;
%LAF.draw(gca,xx2,'labels',good_corresp{:,'ii'});
%axis tight;
%axis equal;
%

figure;
LAF.draw(gca,v(:,good_corresp{:,'jj'}), ...
         'LineStyle','--','labels',good_corresp{:,'jj'});
axis tight;
axis equal;

figure;
xx3 = LAF.translate(xforms{:,'X0'}',xforms{:,'t_i'}');
yy2 = LAF.translate(xx3,xforms{:,'Rt'}');
LAF.draw(gca,yy2,'LineStyle','--', ...
         'labels',good_corresp{:,'jj'});
axis tight;
axis equal;


%
%subplot(2,2,3);
%figure;
%xx3 = LAF.translate(xforms{:,'X0'}',xforms{:,'t_i'}');
%LAF.draw(gca,xx3,'labels',good_corresp{:,'ii'});
%axis tight;
%axis equal;    







%for g = 50:80
%    figure;
%    subplot(2,2,1);
%    xx2 = v(:,good_corresp{find(g==G1),'ii'});
%    LAF.draw(gca,xx2);
%    axis tight;
%    axis equal;
%    
%    
%    subplot(2,2,2);
%    LAF.draw(gca,v(:,good_corresp{find(g==G1),'jj'}), ...
%             'LineStyle','--');
%    axis tight;
%    axis equal;
%
%    subplot(2,2,3);
%    xx3 = LAF.translate(xforms{find(g==G1),'X0'}', ...
%                        xforms{find(g==G1),'t_i'}');
%    LAF.draw(gca,xx3);
%    axis tight;
%    axis equal;    
%    
%    
%    subplot(2,2,4);
%    yy2 = LAF.translate(xx2,xforms{find(g==G1),'Rt'}');
%    LAF.draw(gca,yy2,'LineStyle','--');    
%    axis tight;
%    axis equal;
%end


%keyboard;

%figure;
%cmp_splitapply(@(v,color) LAF.draw_groups(gca,v,'Color',color), ...
%               [dr(:,corresp{corresp.G_rt > 0,'jj'}).u], ...
%               colors',G1');
%figure;
%cmp_splitapply(@(v,t,color) draw_it(gca,v,t,color), ...
%               cframes(cframes.G_rt > 0,{'X0','t_i'}),colors,G1);
%
%function [] = draw_it(gca,u,t,color)
%keyboard;
%v = LAF.translate(u,t);
%LAF.draw(gca,v,'Color',color);
%
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