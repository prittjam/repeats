function orsa = orsa_precalc_eg_nfa(cfg,sz1,sz2)
ny1 = sz1(1);
nx1 = sz1(2);
ny2 = sz2(1);
nx2 = sz2(2);

N1 = log10(2)+0.5*log10(nx1^2+ny1^2)-log10(nx1)-log10(ny1);
N2 = log10(2)+0.5*log10(nx2^2+ny2^2)-log10(nx2)-log10(ny2);

orsa = cfg.orsa;
orsa.logalpha0 = [N1 N2];
orsa.loge0 = log10(orsa.num_solutions)+log10(orsa.tcCount-orsa.k);
orsa.logcombi_n = orsa_make_logcombi_n(orsa.tcCount);
orsa.logcombi_k = orsa_make_logcombi_k(orsa.tcCount,orsa.k);
orsa.max_tsq = 10*cfg.tsq;