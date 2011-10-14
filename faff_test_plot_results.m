function [px] = faff_test_plot_results(pth)
load(pth);
Fa_list = experiment_list;

for i = 1:length(Fa_list)
    inlier_arg_list{2*i-1} = stats.(Fa_list{i}).num_inliers;
    inlier_arg_list{2*i} = Fa_list{i};
    
    trial_arg_list{2*i-1} = stats.(Fa_list{i}).num_trials;
    trial_arg_list{2*i} = Fa_list{i};
    
    card_arg_list{2*i-1} = stats.(Fa_list{i}).Ia_p;
    card_arg_list{2*i} = Fa_list{i};
end

figure;
hold on;
title('Inlier ratio: N_p/max(N_i) for all i');
xlabel('N_p/max(N_i)');
ylabel('P(N_p/max(N_i) < X)');
plot_ratio_wrt_f(@max, inlier_arg_list{:});
hold off;
set(gcf, 'PaperPositionMode', 'auto');
print -painters -dpdf -r600 fig1.pdf

figure;
hold on;
title('(Oxford) Inlier ratio: N_p/N_r');
xlabel('N_p/N_r');
ylabel('P(N_p/N_r < X)');
plot_oxford_ratio(inlier_arg_list{:});
hold off;
set(gcf, 'PaperPositionMode', 'auto');
print -painters -dpdf -r600 fig2.pdf


figure;
hold on;
title('|intersect(Ia,If)|/max|If|');
plot_ratio_wrt_f(@max, inlier_arg_list{:});
hold off;
set(gcf, 'PaperPositionMode', 'auto');
print -painters -dpdf -r600 fig3.pdf

figure;
hold on;
title('|intersect(Ia,If)|/If');
plot_oxford_ratio(inlier_arg_list{:});
hold off;
set(gcf, 'PaperPositionMode', 'auto');
print -painters -dpdf -r600 fig4.pdf

%figure;
%hold on;
%title('Trial ratio: T_p/min(T_i)');
%xlabel('T_p/min(T_i)');
%ylabel('P(T_p/min(T_i))');
%plot_ratio_wrt_f(@min, trial_arg_list{:});
%hold off;
%
%
%
%figure;
%hold on;
%title('(Oxford) Trial ratio');
%xlabel('Speedup');
%ylabel('P(Speedup < X');
%plot_oxford_ratio(inlier_arg_list{:});
%hold off;
end

function [] = plot_oxford_ratio(varargin)
Nr = varargin{1};
[Np label_list] = get_Np(varargin{3:end});
[nrows ncols] = size(Np);
Nr = repmat(Nr',nrows,1);
ry = Np./Nr;
rx = min(ry(:)):0.01:max(ry(:));
s = zeros(nrows,size(rx,2));
for i=1:nrows
    s(i,:) = cumsum(hist(ry(i,:),rx))/size(ry,2);
end
plot(rx,s);
h = legend('show');
set(h,'String',label_list);
set(h,'Location','Northwest');
end

function [] = plot_ratio_wrt_f(f,varargin)
[Np label_list] = get_Np(varargin{:});
[nrows ncols] = size(Np);
d = f(Np(:));
Np_ratio = Np/d;
N = length(Np_ratio);
x = min(Np_ratio(:)):0.01:max(Np_ratio(:));
h = zeros(nrows,length(x));
for i=1:nrows
    h(i,:) = cumsum(hist(Np_ratio(i,:),x))/N;
end
plot(x,h);
h = legend('show');
set(h,'String',label_list);
set(h,'Location','Northwest');
end

function [Np labels] = get_Np(varargin)
Np = zeros(length(varargin)/2, ...
           size(varargin{1},1));
for i = 1:nargin
    j = ceil(i/2);
    x = varargin{i};
    if strcmpi(class(x),'double')
        Np(j,:) = x';
    else
        labels{j} = x;
    end
end
end


%function [px x] = calc_px(Np_x,Np_y,Nr_x,Nr_y)
%cs_Nr_y = cumsum(Nr_y)/sum(Nr_y);
%
%r = [Nr_x(end)/Np_x(1) Nr_x(1)/Np_x(end)];
%
%min_x = min(r);
%max_x = max(r);
%
%step_x = 0.01;
%
%x = min_x:step_x:max_x;
%
%b = min([x*Np_x(end); ...
%         repmat(Nr_x(end),1,length(x))],[],1);
%
%n1 = max([Nr_x(1)./x; ...
%          repmat(Np_x(1),1,length(x))],[],1);
%n2 = b./x; 
%
%i = 1;
%for xi = x
%    step_n = (n2(i)-n1(i))/100;
%    if (step_n < 10*eps)
%        nn = n2(i);
%    else
%        nn = n1(i):step_n:n2(i);
%    end
%    
%    nx = xi.*nn;
%    s1 = xi*interp1(Nr_x,cs_Nr_y,nx,'cubic');
%    p = interp1(Np_x,Np_y/sum(Np_y),nn,'cubic');
%    px(i) = sum(p.*s1)*step_n;
%    i=i+1;
%end
%
%end
%

%
%an_ratio3 = mean(inlier_ratio3);
%dian_ratio3 = median(inlier_ratio3);
%
%n_trials = min([cumulative_stats.two_ellipse_gs_faff.num_trials; ...
%                cumulative_stats.four_point_gs_faff.num_trials; ...
%                cumulative_stats.two_ellipse_four_point_gs_faff.num_trials]);
%ial_ratio1 = cumulative_stats.two_ellipse_gs_faff.num_trials/min_trials;
%ial_ratio2 = cumulative_stats.four_point_gs_faff.num_trials/min_trials;
%ial_ratio3 = cumulative_stats.two_ellipse_four_point_gs_faff.num_trials/min_trials;
%
%n_trial_ratio = min([trial_ratio1; trial_ratio2; trial_ratio3]);
%x_trial_ratio = max([trial_ratio1 ;trial_ratio2 ;trial_ratio3])
%
%n = [min_trial_ratio:0.1:max_trial_ratio];
%_trial_ratio1 = cumsum(hist(trial_ratio1,dmn))/N;
%_trial_ratio2 = cumsum(hist(trial_ratio2,dmn))/N;
%_trial_ratio3 = cumsum(hist(trial_ratio3,dmn))/N;
%
%
%gure;
%ld on;
%tle('Trial Ratio respect to min trials');
%ot(dmn,cs_trial_ratio1, 'r');
%ot(dmn,cs_trial_ratio2, 'g');
%ot(dmn,cs_trial_ratio3, 'b');
%eg1 = legend('2 ellipse', ...
%             '4 point', ...
%             '2 ellipse-gs-4 point-gs-max');
%ld off;
%
%d
%
%ction [z yy] = calc_cdf_ratio(x,y,num_bins)
%ort(x);
%ort(y);
% 1/(2*num_bins);
% x./y;
%vl = 2*c*length(x);
% zeros(1,num_bins);
%= [c:2*c:1-c];
%
% i=1:num_bins
% b = (i-1)*intvl+1;
% e = i*intvl;
% z(i) = (sum(r(floor(b):ceil(e)))-(b-floor(b))*r(floor(b)) ...
%        -(ceil(e)-e)*r(ceil(e)))./intvl;
%
%
%
%ction [] = plot_ratio_max(cs)
%
%_inliers = max([cs.two_ellipse_gs_faff.num_inliers; ...
%                cs.four_point_gs_faff.num_inliers; ...
%                cs.two_ellipse_four_point_gs_faff ...
%                .num_inliers]);
%
%ier_ratio1 = cs.two_ellipse_gs_faff.num_inliers/ ...
% max_inliers;
%ier_ratio2 = cs.four_point_gs_faff.num_inliers/ ...
% max_inliers;
%ier_ratio3 = ...
% cs.two_ellipse_four_point_gs_faff.num_inliers/ ...
% max_inliers;
%
% = 0:0.01:1;
% cs.num_experiments;
%inlier_ratio1 = cumsum(hist(inlier_ratio1,dmn))/N;
%inlier_ratio2 = cumsum(hist(inlier_ratio2,dmn))/N;
%inlier_ratio3 = cumsum(hist(inlier_ratio3,dmn))/N;
%
%ure;
%
%d on;
%le('Inlier Ratio respect to max inliers');
%t(dmn,cs_inlier_ratio1, 'r');
%t(dmn,cs_inlier_ratio2, 'g');
%t(dmn,cs_inlier_ratio3, 'b');
%g1 = legend('2 ellipse', ...
%            '4 point', ...
%            '2 ellipse-gs-4 point-gs');
%(hleg1,'Location','NorthWest');
%bel('Relative number of inliers Np/max');
%bel('P(Np/max)');
%d off;
%
%
%ction [] = plot_oxford_inlier_ratio(cs)
% cs.num_experiments;
%er_bound = min(min(inlier_ratio32), min(inlier_ratio12));
%er_bound = max(max(inlier_ratio32), max(inlier_ratio12));
%
% = [lower_bound:0.01:upper_bound];
%
%ier_ratio12 = cs.two_ellipse_four_point_gs_faff.num_inliers./cs.four_point_gs_faff.num_inliers;
%n_ratio12 = mean(inlier_ratio12);
%ian_ratio12 = median(inlier_ratio12);
% = cumsum(hist(inlier_ratio12,dmn))./N;
%
%ier_ratio32 = cs.four_point_gs_faff.num_inliers./cs.two_ellipse_four_point_gs_faff.num_inliers;
%n_ratio32 = mean(inlier_ratio32);
%ian_ratio32 = median(inlier_ratio32); 
% = cumsum(hist(inlier_ratio32,dmn))./N;
%
%ure;
%d on;
%le('Inlier Ratio: 2-ellipse & 2-Ellipse-4-point vs 4-point');
%t(dmn, s12, 'b',... 
%  dmn, s32,'r');
%bel('Relative number of inliers Np/Nr');
%bel('P(Np/Nr)');
%g1 =legend('two ellipse', ...
%    'two ellipse-four point');
%(hleg1,'Location','Northwest');
%d off;
%(gcf, 'PaperPositionMode', 'auto');
%nt -painters -dpdf -r600 ir_overlayed.pdf
%
%
%ction [] = plot_oxford_speedup()
%al_ratio12 = cs.four_point_gs_faff.num_trials./cs.two_ellipse_four_point_gs_faff.num_trials;
%n_speedup12 = mean(trial_ratio12);
%ian_speedup12 = median(trial_ratio12);
%
%al_ratio32 = cs.four_point_gs_faff.num_trials./cs.two_ellipse_four_point_gs_faff.num_trials;
%n_speedup32 = mean(trial_ratio32);
%ian_speedup32 = median(trial_ratio32);
%
%ure;
%d on;
%le('Speedup Ratio');
% = cumsum(hist(inlier_ratio12,dmn))/N;
% = 
%t(dmn, cumsum(hist(inlier_ratio12,dmn))/N, 'b', ...
%  dmn, cumsum(hist(inlier_ratio32,dmn))/N,'r');
%bel('Relative number of inliers Np/Nr');
%bel('P(Np/Nr)');
%g1 =legend('two ellipse', ...
%    'two ellipse-four point');
%(hleg1,'Location','Northwest');
%d off;
%
%(gcf, 'PaperPositionMode', 'auto');
%nt -painters -dpdf -r600 ir_overlayed.pdf
%
%
%cation =3D {};
% = fieldnames(s);
%r i=3D1:numel(fn)
%  f =3D fn{i};
%  for j=3D1:numel(s)
%      if strcmp(f, aField)
%          location =3D {aField};
%          return
%      end
%      if isstruct(s(j).(f))
%          location =3D findField(s(j).(f),aField);
%          if ~isempty(location)
%              location =3D {f, location{:}};
%              return
%          end
%      end
%  end
%d
%
%
%
%gure;
%ld on;
%tle('Inlier Ratio:2-ellipse vs 4-point');
%ine(mean_ratio12, '--b');
%ine(median_ratio12, 'r');
%ot(dmn, cumsum(hist(inlier_ratio12,dmn))/num_experiments, 'k');
%eg1 = legend('mean ratio','median ratio');
%t(hleg1,'Location','NorthWest');
%
%ld off;
%t(gcf, 'PaperPositionMode', 'auto');
%int -painters -dpdf -r600 ir_two_ellipse.pdf
%
%gure;
%ld on;
%tle('Speedup:2-ellipse vs 4-point');
%ine(mean_speedup12, '--b');
%ine(median_speedup12, 'r');
%ot(dmn2, cumsum(hist(trial_ratio12,dmn2))/num_experiments, 'k');
%eg1 = legend('mean speedup','median speedup');
%t(hleg1,'Location','SouthEast');
%abel('Speedup');
%abel('P(Speedup < X)');
%ld off;
%t(gcf, 'PaperPositionMode', 'auto');
%int -painters -dpdf -r600 su_two_ellipse.pdf
%
%gure;
%ld on;
%tle('Inlier Ratio: 2-ellipse-4-point vs 4-point');
%ine(mean_ratio32, '--b');
%ine(median_ratio32, 'r');
%ot(dmn, cumsum(hist(inlier_ratio32,dmn))/num_experiments, 'k');
%eg1 = legend('mean ratio','median ratio');
%t(hleg1,'Location','NorthWest');
%abel('Relative number of inliers Np/Nr');
%abel('P(Np/Nr)');
%ld off;
%t(gcf, 'PaperPositionMode', 'auto');
%int -painters -dpdf -r600 ir_two_ellipse_four_point.pdf
%
%
%
%ction [x y] = calc_cdf(s,t)
%p = 0.01;
% length(s);
%vl = floor(step*N);
%ns = floor(N/intvl);
%s_remaining = mod(N,intvl);
%= sort(s);
%= sort(t);
%(bins_remaining > 0)
%= [sum(reshape(ss(1:end-bins_remaining),nbins,intvl)) ...
%   sum(ss(end-bins_remaining+1,end))./bins_remaining];
%= [sum(reshape(st(1:end-bins_remaining),nbins,intvl)) ...
%   sum(st(end-bins_remaining+1,end))./bins_remaining];
%e
%= [sum(reshape(ss,nbins,intvl))];
%= [sum(reshape(st,nbins,intvl))]; 
%
%
% ss./st;
% [0:step:1]
%