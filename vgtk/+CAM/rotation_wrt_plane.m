function [R, UVW] = rotation_wrt_plane(UVW)
    % We assume CS of the scene plane is (x>, y^, z=0(us))
    % The following conditions should be satisfied
    % UVW * [1;0;0] = U(1) > 0
    % UVW * [0;1;0] = V(2) < 0
    % UVW * [0;0;1] = W(3) < 0
    % det|UVW| > 0

    UVW(:,1) = sign(UVW(1,1)) * UVW(:,1);
    UVW(:,2) = - sign(UVW(2,2)) * UVW(:,2);
    UVW(:,3) = - sign(UVW(3,3)) * UVW(:,3);

    if det(UVW) < 0
        UVW(:,1:2) = [UVW(:,2) UVW(:,1)];
        UVW(:,1:2) = sign(UVW(1,1)) * UVW(:,1:2);
    end

    R = UVW ./ sqrt(sum(UVW.^2));
end