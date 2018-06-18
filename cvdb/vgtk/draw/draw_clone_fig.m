function hh2 = draw_clone_fig(hh1)
hh2=figure;
objects=allchild(hh1);
copyobj(get(hh1,'children'),hh2);
