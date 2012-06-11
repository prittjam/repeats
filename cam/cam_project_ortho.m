function u = cam_ortho_project(X)
u = [X(1,:);X(2,:);ones(1,size(X,2))];