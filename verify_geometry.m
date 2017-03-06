function G_sv = verify_geometry(G_app,cs)
G_inl0 = G_app.*cs;
G_inl0(G_inl0==0) = nan;
G_sv = findgroups(G_inl0);
