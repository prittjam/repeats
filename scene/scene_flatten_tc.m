function m2 = scene_flatten_tc(tc,dr1,dr2)
m1 = [tc(:).m];
gid1 = [dr1(:).gid];
gid2 = [dr2(:).gid];
m2 = [gid1(m1(1,:)); ...
      gid2(m1(2,:))];