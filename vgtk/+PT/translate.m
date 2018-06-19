function v = translate(u,du)
v = u;
v(1:2,:) = u(1:2,:)+du(1:2,:);
