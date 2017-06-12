function [] = draw_scene(gca,x,cam)
figure;
plot(x(1,:),x(2,:),'b.');
axis ij;
axis equal
axis([0.5 cam.nx 0.5 cam.ny]); 
