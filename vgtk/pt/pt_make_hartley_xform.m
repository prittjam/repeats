function varargout = make_hartley_xform(pts)
    if size(pts,1) ~= 3
        error('pts must be 3xN');
    end
    
    % Find the indices of the points that are not at infinity
    finiteind = find(abs(pts(3,:)) > eps);
    
    if length(finiteind) ~= size(pts,2)
        warning('Some points are at infinity');
    end
    
    % For the finite points ensure homogeneous coords have s of 1
    pts(1,finiteind) = pts(1,finiteind)./pts(3,finiteind);
    pts(2,finiteind) = pts(2,finiteind)./pts(3,finiteind);
    pts(3,finiteind) = 1;
    
    c = mean(pts(1:2,finiteind)')';            % Centroid of finite points
    newp(1,finiteind) = pts(1,finiteind)-c(1); % Shift origin to centroid.
    newp(2,finiteind) = pts(2,finiteind)-c(2);
    
    meandist = mean(sqrt(newp(1,finiteind).^2 + newp(2,finiteind).^2));
    
    s = sqrt(2)/meandist;
    
    varargout{ 1 } = [s  0  -s*c(1); ...
                      0  s  -s*c(2); ...
                      0  0     1];

    if nargout > 1
        varargout{ 2 } = [1/s  0  c(1); ...
                           0  1/s c(2); ...
                           0   0   1];
    end