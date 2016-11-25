function [H,H2] = H_from_2e(C1,C2)
[H,H2]=HG.icpr12.hg_2elin2(C1(:,:,1), C1(:,:,2), C2(:,:,1), C2(:,:,2));
%H=HG.icpr12.hg_nelin(C1,C2);