function [timg,T,A] = rectify(img,H,varargin)
    assert(all(size(H) == [3 3]));
    
    cfg.registration = 'Similarity';
    cfg.ru_xform = maketform('affine',eye(3));
    cfg.good_points = [];
    cfg.fill = [255 255 255]';
    
    [cfg,leftover] = cmp_argparse(cfg,varargin{:});

    leftover = { 'Fill', cfg.fill };

    nx = size(img,2);
    ny = size(img,1);

    border = [0.5    0.5; ...
              nx+0.5 0.5; ...    
              nx+0.5 ny+0.5; ...
              0.5    ny+0.5];

    ru_border = tformfwd(cfg.ru_xform,border);

    minx = min(ru_border(:,1));
    maxx = max(ru_border(:,1));
    miny = min(ru_border(:,2));
    maxy = max(ru_border(:,2));

    rect = [minx maxx miny maxy];

    [endpts,rect_lines] = LINE.intersect_rect(H(3,:)',rect);

    in_image = ~isempty(endpts);
    
    if in_image
        assert(size(endpts,2)==2,...
               ['The vanishing line must cross the image border twice']);
        
        [~,ind] = sort(endpts(1,:));
        endpts = endpts(:,ind);

        l = LINE.inhomogenize(cross(endpts(:,1),endpts(:,2)));

        v = tformfwd(cfg.ru_xform,cfg.good_points(1:2,:)');
        mu = PT.homogenize(mean(v',2));

        if dot(l,mu) < 0
            l = -l;
        end

        newpt = endpts(:,1)+[200*l(1:2);1];
        l(3) = -dot(l(1:2),newpt(1:2));

        [pts,rect_lines] = LINE.intersect_rect(l,rect);
        
        idx = find(dot(repmat(l,1,4),[ru_border';ones(1,4)]) > 0);
        xx = [pts(1,:) ru_border(idx,1)'];
        yy = [pts(2,:) ru_border(idx,2)'];
        K = convhull(xx,yy);
        xx = xx(K);
        yy = yy(K);
        
        cropped_ru_border = [xx;yy]';
        border = tforminv(cfg.ru_xform,cropped_ru_border);        
    end
    
    T0 = maketform('composite', ...
                   maketform('projective',H'), ...
                   cfg.ru_xform);

    switch lower(cfg.registration)
      case 'affinity'
        assert(~isempty(cfg.good_points), ...
               ['You cannot register the rectification without inliers!']);
        [T,A] = register_by_affinity(cfg.good_points,T0);
        
      case 'similarity'
        assert(~isempty(cfg.good_points), ...
               ['You cannot register the rectification without inliers!']);
        [T,A] = register_by_similarity(cfg.good_points,T0);
        
      case 'scale'
        [T,A] = register_by_scale(img,T0);
    end

    tbounds = tformfwd(T,border);

    minx = floor(min(tbounds(:,1)));
    maxx = ceil(max(tbounds(:,1)));
    miny = floor(min(tbounds(:,2)));
    maxy = ceil(max(tbounds(:,2)));
        
    timg = imtransform(img,T,'XYScale',1, ...
                       'XData',[minx maxx], ...
                       'YData',[miny maxy], ...
                       leftover{:});
    
    if in_image
        BW = roipoly([minx maxx], ...
                     [miny maxy], ...
                     zeros(maxy-miny+1,maxx-minx+1,3), ...
                     tbounds(:,1),tbounds(:,2));
        BW3 = repmat(~BW,1,1,3);
        fill = BW3.*permute(cfg.fill,[3 2 1]);
        timg(find(BW3)) = fill(find(BW3));
    end
    
function [T,A] = register_by_similarity(u,T0)
    v = [tformfwd(T0,transpose(u(1:2,:))) ... 
         ones(size(u,2),1)];
    A = HG.pt2x2_to_sRt([transpose(v);u]);
    T = maketform('composite', ...
                  maketform('affine',transpose(A)), ...
                  T0);

function [T,A] = register_by_affinity(u,T0)
    v = [tformfwd(T0,transpose(u(1:2,:))) ... 
         ones(size(u,2),1)];
    A = HG.pt3x2_to_A([transpose(v);u]);
    T = maketform('composite', ...
                  maketform('affine',transpose(A)), ...
                  T0);

function [T,S] = register_by_scale(img,T0)
    nx = size(img,2);
    ny = size(img,1);

    border = [0.5    0.5; ...
              nx+0.5 0.5; ...    
              nx+0.5 ny+0.5; ...
              0.5    ny+0.5];
    tborder = tformfwd(T0,border);
    
    s1 = polyarea(border(:,1),border(:,2));
    s2 = polyarea(tborder(:,1),tborder(:,2));
    s3 = sqrt(s1/s2);

    S = [s3 0 0; 0 s3 0; 0 0 1];

    T = maketform('composite', ...
                  maketform('affine',S'), ...
                  T0);
