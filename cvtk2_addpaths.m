[cvtk_base_path, name, ext] = fileparts(mfilename('fullpath'));

addpath([cvtk_base_path '/eg']);
addpath([cvtk_base_path '/line']);
addpath([cvtk_base_path '/pt']);
addpath([cvtk_base_path '/rnsc']);
addpath([cvtk_base_path '/scene']);
addpath([cvtk_base_path '/ao']);

addpath([cvtk_base_path '/vendor/wbs/matlab/utils']);
addpath([cvtk_base_path '/vendor/wbs/matlab/utils/json']);
addpath([cvtk_base_path '/vendor/wbs/matlab/utils/uniaccess']);

addpath([cvtk_base_path '/vendor/wbs/wbs-demo']);
addpath([cvtk_base_path '/vendor/wbs/wbs-demo/mex']);

javaaddpath('/home.stud/qqmikula/lib/mysql-connector-java-5.1.6-bin.jar');
javaaddpath('/home.stud/qqmikula/lib/imagedb/imagedb.jar');
javaaddpath('/home.stud/qqmikula/lib/imtools/imtools.jar');

% wbs demo init
setpaths