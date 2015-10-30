function rimg = rectify_inliers(im,Hinf,dr,inl_idx)
rimg = [];
if isempty(inl_idx)
    return;
end
if all(size(Hinf) == [1 3])
    Hinf = [1 0 0; 0 1 0; Hinf];
end
inl_idx = inl_idx(cellfun(@numel, inl_idx) > 1);        
u2 = dr.u(:,unique([inl_idx{:}]));
mu2 = dr.mu(:,unique([inl_idx{:}]));
if ~isempty(u2)
    v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u2);
    A = HG.laf1_to_A([v;u2]);
    H = A*Hinf;
    for i = 0:500
        BW = LINE.line2mask(Hinf(3,:)',im,mu2,i*10);
        inboundary = find_inboundary(BW);
        rimg = IMG.rectify_part(im,H,inboundary);
        if ~isempty(rimg)
            break;
        end
    end
    if isempty(rimg)
        warning('Probably wrong line infinity. Skipping...');
        return;
    end
else
    warning('No inliers. Skipping...');
end

function inboundary = find_inboundary(BW)
inboundary =[];
x = find(BW(1,:));  
if ~isempty(x)
    inboundary = [inboundary; x(1) 1; x(end) 1];
end
x = find(BW(end,:));  
if ~isempty(x)
    inboundary = [inboundary; x(1) size(BW,1); x(end) size(BW,1)];
end
x = find(BW(:,1));  
if ~isempty(x)
    inboundary = [inboundary; 1 x(1); 1 x(end)];
end
x = find(BW(:,end));  
if ~isempty(x)
    inboundary = [inboundary;  size(BW,2) x(1); size(BW,2) x(end) ];
end
inboundary = unique(inboundary,'rows');