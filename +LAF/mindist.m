function d2 = mindist(XI,XJ)
d0 = bsxfun(@minus,XI,XJ).^2;
d2 = min([sqrt([sum(d0(:,1:2),2) sum(d0(:,4:5),2) sum(d0(:,7: ...
                                                  8),2)])],[],2);