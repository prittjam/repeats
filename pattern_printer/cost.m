function err = theloss(x,cspond,Gm,q,cc,Hinf,Rtij)
Hinv = inv(Hinf);
invRtij = multinv(Rtij);
xp = PT.renormI(blkdiag(Hinf,Hinf,Hinf)*PT.ru_div(x,cc,q));
ut_j =  PT.rd_div(PT.renormI(PT.mtimesx(multiprod(Hinv,Rtij(:,:,Gm)), ...
                                        xp(:,cspond(1,:)))),cc,q);
ut_i =  PT.rd_div(PT.renormI(PT.mtimesx(multiprod(Hinv,invRtij(:,:,Gm)), ...
                                        xp(:,cspond(2,:)))),cc,q);
err = [ut_j-x(:,cspond(2,:)); ...
       ut_i-x(:,cspond(1,:))];