function desc_defs = desc_init()
global DR DESC;

desc_defs = [];

% input: DR representation one of:
%
%   trpt - translation invariant
%  trspt - translation and scale invariant
%  trrpt - translation and rotation invariant
%  simpt - similarity invariant
%  ellpt - affine invariant up to unknown rotation
%  affpt - affine invariant
%
% output: representation for matching method
%
%    patch - grayscale patch descriptor
% rgbpatch - rgb patch descriptor
%     sift - SIFT descriptor
%      dct - DCT descriptor with photometric coefficients
%    dctnp - DCT descriptor without photometric coefficients
% rotinvar - rotational invariant
%

desc_defs = desc_define_method(desc_defs,'Affine point -> SIFT', 'aff2sift', 'affpt', 'sift');
desc_defs = desc_define_method(desc_defs,'Affine point -> DCT' , 'aff2dct', 'affpt', 'dct');
desc_defs = desc_define_method(desc_defs,'Affine point -> LIOP' , 'aff2liop', 'affpt', 'liop');

desc_defs = desc_define_method(desc_defs,'Similarity point -> SIFT', 'sim2sift', 'simpt', 'sift');
desc_defs = desc_define_method(desc_defs,'Similarity point -> DCT' , 'sim2dct', 'simpt', 'dct');
desc_defs = desc_define_method(desc_defs,'Similarity point -> LIOP' , 'sim2liop', 'simpt', 'liop');

% define_desc_method('LAF -> LAF',            'laf2laf', 'lafs', 'laf');
% define_desc_method('RLE -> rot. invar',     'rle2rotinvar', 'rle', 'rotinvar');
% define_desc_method('Ell. -> rot. invar',    'ell2rotinvar', 'ellipse',  'rotinvar');
% define_desc_method('RLE -> LAF', 'rle2laf', 'rle', 'laf');
% define_desc_method('RLE -> LAF orient.',    'rle2laf2', 'rle', 'laf2');
% define_desc_method('RLE -> LAF geom.',      'rle2laf', 'rle', 'lafg');
% define_desc_method('Ell. -> LAF',           'ell2laf', 'ellipse', 'laf');
% define_desc_method('Key. -> SIFT',          'key2sift', 'keypoint', 'sift');
% define_desc_method('RLE -> SIFT',           'rle2sift', 'rle', 'sift'); 
% define_desc_method('Ell. -> SIFT',          'ell2sift', 'ellipse', 'sift'); 
% define_desc_method('RLE -> PCA',            'rle2pca', 'rle', 'pca'); 
% define_desc_method('Ell. -> PCA',           'ell2pca', 'ellipse', 'pca'); 
% define_desc_method('Ell+SIFT. -> SIFT',     'ellsift2sift', 'ellsift', 'sift'); 
% define_desc_method('RLE -> GRAD',           'rle2grads', 'rle', 'grads'); 
% define_desc_method('Ell. -> GRAD',          'ell2grads', 'ellipse', 'grads'); 

% define_desc_method('LOOP -> LAF',           'loop2laf', 'loop', 'laf');
% define_desc_method('LOOP -> rot. invar',    'loop2rotinvar', 'loop', 'rotinvar');
% define_desc_method('LOOP -> SIFT',          'loop2sift', 'loop', 'sift');

% define_desc_method('Point -> SIFT', 'point2sift', 'point', 'sift');

%DESC.valid = zeros(num_matchalgs, num_drs, num_imgs);
%DESC.data = cell(num_matchalgs, num_drs, num_imgs);
%DESC.desc2dr = cell(num_matchalgs, num_drs, num_imgs);
