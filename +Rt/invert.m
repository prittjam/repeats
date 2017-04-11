function Rt = invert(Rt)
    Rt(1,:) = -Rt(1,:);
    Rt(2:3,:) = PT.apply_rigid_xforms(-1*Rt(2:3,:),Rt(1,:), ...
                                      zeros(2,size(Rt,2))); 
