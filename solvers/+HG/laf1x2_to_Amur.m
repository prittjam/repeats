function A = laf1x2_to_Amur(x,G)
    Gr = ~LAF.is_right_handed(x);
    left = cmp_splitapply(@(v,gr) { v(:,gr) },x,Gr,G);
    right = cmp_splitapply(@(v,gr) { v(:,~gr) },x,Gr,G);

    for k = 1:numel(left)
        is_good(k) = ~(isempty(left{k}) || isempty(right{k}));
    end

    good_ind = find(is_good);
    if ~isempty(good_ind)
        A = laf2x1_to_Amur_internal(left(good_ind), ...
                                    right(good_ind));
    else
        A = eye(3);
    end

function A = laf2x1_to_Amur_internal(aY,arY)
    if ~iscell(aY)
        aY = {aY};
        arY = {arY};
    end

    X1 = [];
    X2 = [];

    for i = 1: length(aY)

        Y = aY{i};
        rY = arY{i};

        [aX1(:,3), aX2(:,3)] = makept(Y, rY, [1,2], [4,5]);
        [aX1(:,1), aX2(:,1)] = makept(Y, rY, [1,2], [7,8]);
        [aX1(:,2), aX2(:,2)] = makept(Y, rY, [4,5], [7,8]);

        X1 = [X1, aX1];
        X2 = [X2, aX2];
    end

    [U,D,V] = svd(X1');
    a1 = V(:,end);
    a1 = a1 * sign(a1(1));
    [U,D,V] = svd(X2');
    a2 = V(:,end);

    dt = det([a1';a2']);
    a2 = a2 * sign(dt);
    s = sqrt(abs(dt));

    A = eye(3);
    A(1,1:2) = a1 / s;
    A(2,1:2) = a2 / s;


function [pt1, pt2] = makept(Y, rY, p1, p2)
    m1 = mean(Y(p1,:) - Y(p2,:),2);
    m2 = mean(rY(p1,:) - rY(p2,:),2);
    pt1 = (m1 + m2) / 2;
    pt2 = (m1 - m2) / 2;
