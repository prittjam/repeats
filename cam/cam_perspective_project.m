function u = cam_perspective_project(x)
u = bsxfun(@rdivide,x(1:2,:),x(3,:));