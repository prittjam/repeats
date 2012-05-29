[cvtk_base_path, name, ext] = fileparts(mfilename('fullpath'));

addpath([cvtk_base_path '/hg']);
addpath([cvtk_base_path '/eg']);
addpath([cvtk_base_path '/line']);
addpath([cvtk_base_path '/pt']);
addpath([cvtk_base_path '/rnsc']);
addpath([cvtk_base_path '/scene']);
addpath([cvtk_base_path '/ao']);
addpath([cvtk_base_path '/draw']);
addpath([cvtk_base_path '/cam']);
addpath([cvtk_base_path '/util']);
addpath([cvtk_base_path '/laf']);

%addpath([src_base_path '/wbs/wbs-demo']);
%
%javaaddpath('/home.stud/qqmikula/lib/mysql-connector-java-5.1.6-bin.jar');
%javaaddpath('/home.stud/qqmikula/lib/imagedb/imagedb.jar');
%javaaddpath('/home.stud/qqmikula/lib/imtools/imtools.jar');
%
%% wbs demo init
%old_pth = cd([src_base_path '/wbs/wbs-demo']);
%setpaths
%cd(old_pth);