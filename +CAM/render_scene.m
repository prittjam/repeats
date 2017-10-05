function [] = render_scene(P,X)
[K,R,c] = CAM.P_to_KRc(P);

look_right = R(1,:);
look_down = R(2,:);
look_at = R(3,:);
R = [look_right; look_down; look_at];
P2 = K*[R -R*c];

figure;
hold on;
plot3(X(1,:),X(2,:),X(3,:),'b.');
hold on;line([c(1) c(1)+20*look_right(1)], [c(2) c(2)+20*look_right(2)] ,[c(3) c(3)+20*look_right(3)],'color','r');hold off;
hold on;line([c(1) c(1)+20*look_at(1)], [c(2) c(2)+20*look_at(2)] ,[c(3) c(3)+20*look_at(3)],'color','b');hold off;
%)],'color','g');hold off;
hold on;line([c(1) c(1)+20*look_down(1)], [c(2) c(2)+20*look_down(2)] ,[c(3) c(3)+20*look_down(3)],'color','g');hold off;
cameratoolbar; 
axis equal;
