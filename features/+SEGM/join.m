function segm = join(segm1,segm2)
segm = segm1 + ((segm2 + 2)*max(segm1(:)) + 1);
segm = SPIXEL.renumber(segm);

segm = segm.*uint32(~(segm1 == 0 | segm2 == 0));

[x y] = find(segm == 0);
valid = y < size(segm,2);
x = x(valid); y = y(valid);
indxy = sub2ind(size(segm),x,y);
segm(indxy) = segm(indxy + size(segm,1));

[x y] = find(segm == 0);
valid = x < size(segm,1);
x = x(valid); y = y(valid);
indxy = sub2ind(size(segm),x,y);
segm(indxy) = segm(indxy + 1);
