% Generated using GBSolver generator v1.1 Copyright Martin Bujnak,
% Zuzana Kukelova, Tomas Pajdla CTU Prague 2008.
% 
% Please refer to the following paper, when using this code :
%     Kukelova Z., Bujnak M., Pajdla T., Automatic Generator of Minimal Problem Solvers,
%     ECCV 2008, Marseille, France, October 12-18, 2008


function [k1 k2 b] = H5r1r2_3var_c(g3, g4, g5, g6, g7, cc)


    g31 = g3(1);
    g32 = g3(2); 
    g33 = g3(3);
    g34 = g3(4);
    g35 = g3(5); 
    g36 = g3(6);

    g41 = g4(1);
    g42 = g4(2); 
    g43 = g4(3);
    g44 = g4(4);
    g45 = g4(5); 
    g46 = g4(6);
    
    g51 = g5(1);
    g52 = g5(2); 
    g53 = g5(3);
    g54 = g5(4);
    g55 = g5(5); 
    g56 = g5(6);
    
    g61 = g6(1);
    g62 = g6(2); 
    g63 = g6(3);
    g64 = g6(4);
    g65 = g6(5); 
    g66 = g6(6);
    
    g71 = g7(1);
    g72 = g7(2); 
    g73 = g7(3);
    g74 = g7(4);
    g75 = g7(5); 
    g76 = g7(6);
    
	% precalculate polynomial equations coefficients
	c(1) = g31;
	c(2) = g32;
	c(3) = g33;
	c(4) = cc*g32;
	c(5) = -g41;
	c(6) = g35-g42;
	c(7) = -g43;
	c(8) = -cc*g42+g36;
	c(9) = -g45;
	c(10) = -g46;
	c(11) = g72;
	c(12) = cc*g72;
	c(13) = -g51+g75;
	c(14) = -g52;
	c(15) = g76-g53;
	c(16) = -cc*g52;
	c(17) = -g55;
	c(18) = -g56;
	c(19) = g72;
	c(20) = cc*g72;
	c(21) = -g62+g75;
	c(22) = -g64+g76;
	c(23) = -g65;
	c(24) = -g66;

	M = zeros(16, 21);
	ci = [27, 53, 84, 129];
	M(ci) = c(1);

	ci = [43, 69, 100, 145];
	M(ci) = c(2);

	ci = [59, 117, 132, 193];
	M(ci) = c(3);

	ci = [75, 148, 209];
	M(ci) = c(4);

	ci = [91, 133, 164, 225];
	M(ci) = c(5);

	ci = [107, 149, 180, 241];
	M(ci) = c(6);

	ci = [139, 197, 228, 273];
	M(ci) = c(7);

	ci = [155, 213, 244, 289];
	M(ci) = c(8);

	ci = [187, 245, 260, 305];
	M(ci) = c(9);

	ci = [251, 293, 308, 321];
	M(ci) = c(10);

	ci = [13, 28, 55, 86, 130];
	M(ci) = c(11);

	ci = [60, 119, 134, 194];
	M(ci) = c(12);

	ci = [61, 92, 135, 166, 226];
	M(ci) = c(13);

	ci = [77, 108, 151, 182, 242];
	M(ci) = c(14);

	ci = [125, 140, 199, 230, 274];
	M(ci) = c(15);

	ci = [156, 215, 246, 290];
	M(ci) = c(16);

	ci = [157, 188, 247, 262, 306];
	M(ci) = c(17);

	ci = [221, 252, 295, 310, 322];
	M(ci) = c(18);

	ci = [16, 31, 46, 58, 73, 104, 147];
	M(ci) = c(19);

	ci = [63, 78, 122, 152, 211];
	M(ci) = c(20);

	ci = [64, 95, 110, 138, 153, 184, 243];
	M(ci) = c(21);

	ci = [128, 143, 158, 202, 217, 248, 291];
	M(ci) = c(22);

	ci = [144, 175, 190, 234, 249, 264, 307];
	M(ci) = c(23);

	ci = [208, 239, 254, 282, 297, 312, 323];
	M(ci) = c(24);


	Mr = gj(M);  % replace me with a MEX

	A = zeros(5);
	amcols = [21 20 19 18 17];
	A(1, 3) = 1;
	A(2, :) = -Mr(16, amcols);
	A(3, :) = -Mr(14, amcols);
	A(4, :) = -Mr(13, amcols);
	A(5, :) = -Mr(12, amcols);

	[V D] = eig(A);
	sol =  V([4, 3, 2],:)./(ones(3, 1)*V(1,:));

	if (find(isnan(sol(:))) > 0)
		
		k1 = [];
		k2 = [];
		b = [];
	else
		
		I = find(not(imag( sol(1,:) )));
		k1 = sol(1,I);
		k2 = sol(2,I);
		b = sol(3,I);
	end
end
