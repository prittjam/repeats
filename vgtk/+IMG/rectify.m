function [timg,T,A] = rectify(img,H,varargin)
    assert(all(size(H) == [3 3]));

    cfg.bbox = [];
    cfg.extents = [];
    cfg.registration = 'Similarity';
    cfg.ru_xform = maketform('affine',eye(3));
    cfg.good_points = [];
    cfg.fill = [255 255 255]';
    
    [cfg,leftover] = cmp_argparse(cfg,varargin{:});

    leftover = { 'Fill', cfg.fill, ...
                 leftover{:} };

    nx = size(img,2);
    ny = size(img,1);


    if ~isempty(cfg.bbox)
        border = cfg.bbox;
    else
        border = [0.5        0.5; ...
                  (nx-1)+0.5 0.5; ...    
                  (nx-1)+0.5 (ny-1)+0.5; ...
                  0.5        (ny-1)+0.5];
    end
    
    ru_border = tformfwd(cfg.ru_xform,border);

    minx = min(ru_border(:,1));
    maxx = max(ru_border(:,1));
    miny = min(ru_border(:,2));
    maxy = max(ru_border(:,2));

    rect = [minx maxx miny maxy];

    endpts = LINE.intersect_rect(H(3,:)',rect);

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

        newpt = endpts(:,1)+[100*l(1:2);1];

        l(3) = -dot(l(1:2),newpt(1:2));

        pts = LINE.intersect_rect(l,rect);
        
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
      case 'none'
        T = T0;
        A = eye(3);
    end

    if ~isempty(cfg.extents)
        [T,A2] = register_by_extent(img,T,cfg.extents);
        A = A2*A;
    end
    
    tbounds = tformfwd(T,border);

    minx = round(min(tbounds(:,1)));
    maxx = round(max(tbounds(:,1)));
    miny = round(min(tbounds(:,2)));
    maxy = round(max(tbounds(:,2)));

%    tnx = max(cfg.oborder(:,1))-min(cfg.oborder(:,1))+1;
%    tny = max(cfg.oborder(:,2))-min(cfg.oborder(:,2))+1;
%%    assert(maxx-minx+1==tnx,'problem in x dimension');
%    assert(maxy-miny+1==tny,'problem in y dimension');

    timg = imtransform(img,T,'bicubic', ...
                       'XData',[minx maxx], ...
                       'YData',[miny maxy], ...
                       'XYScale',1, ...
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
    
    if ~isempty(cfg.extents)
        timg = imresize(timg,[ny nx]);
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

    border = [0.5        0.5; ...
              (nx-1)+0.5 0.5; ...    
              (nx-1)+0.5 (ny-1)+0.5; ...
              0.5        (ny-1)+0.5];
    tborder = tformfwd(T0,border);
    
    s1 = polyarea(border(:,1),border(:,2));
    s2 = polyarea(tborder(:,1),tborder(:,2));
    s3 = sqrt(s2/s1);

    S = [s3 0 0; 0 s3 0; 0 0 1];

    T = maketform('composite', ...
                  maketform('affine',S'), ...
                  T0);

function [T,S] = register_by_extent(img,T0,extents)
    nx = size(img,2);
    ny = size(img,1);
   
    border0 = [0.5       0.5; ...
              (nx-1)+0.5 0.5; ...    
              (nx-1)+0.5 (ny-1)+0.5; ...
              0.5        (ny-1)+0.5];
    tborder0 = tformfwd(T0,border0);
    
    xextent = max(tborder0(:,1))-min(tborder0(:,1))+1;
    yextent = max(tborder0(:,2))-min(tborder0(:,2))+1;
    
    sx = abs(extents(1)/xextent);
    sy = abs(extents(2)/yextent);

    S = [sx  0 0;
          0 sy 0;
          0  0 1];
    
    T = maketform('composite', ...
                  maketform('affine',S'), ...
                  T0);
