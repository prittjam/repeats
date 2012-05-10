function A = laf_make_A_from_3p(geom)
A = [geom(1:3)-geom(4:6) geom(7:9)-geom(4:6) geom(4:6)];