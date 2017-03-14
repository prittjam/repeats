function Rt = invert(Rt)
    Rt(1,:) = -Rt(1,:);
    Rt(2:3,:) = PT.apply_rigid_xforms(-1*Rt(2:3,:),Rt(1,:), ...
                                      zeros(2,size(Rt,2))); 
    
%    invRt = struct('theta',mat2cell(-[Rt(:).theta],1,ones(1,numel(Rt))), ...
%                   't',mat2cell(t,2,ones(1,size(t,2)))); 
