function cfg = scene_make_dr_cfg(tp,detector_cfg)
global DR

clear cfg

switch tp
  case 'mser'
    cfg.subtype.tbl = {'intp', 'intm'};    
    cfg.subtype.id  = [1 2];    
    cfg.subgenid    = [1 2];
    cfg.upgrade     = [1 1];
    
  case 'haff2_na'
    cfg.subgenid   = 9;
    cfg.upgrade    = 0;    
end

DR.current     = unique(cat(2,cfg.subgenid,DR.current));
[~,ia]         = intersect(DR.current,cfg.subgenid);
DR.upgrade(ia) = cfg.upgrade;

% === mandatory part (in the most cases stays unchanged) === %
cfg.verbose                = 0;
cfg.master_isfinished      = false;
cfg.min_chunk_size         = 10;
cfg.mypath                 = fileparts(mfilename('fullpath'));
% === end of mandatory part === %

% database for storing configurations
cfg.confdb.schema = 'config';
cfg.confdb.user   = 'perdom1';
cfg.confdb.pass   = '';

% configure data access
cfg.imagedb_cluster = 'cmpgrid_cassandra';

cfg.storage.db_root = '/mnt/fry';
cfg.storage.list = 'imagelist';
cfg.storage.check = 'cass_imagecheck';
cfg.storage.get = 'cass_imageget';
cfg.storage.put = 'cass_imageput';
cfg.storage.remove = 'cass_imageremove';
cfg.storage.tostr = 'item2str';
cfg.storage.retry_count = 25;

cfg.detector = detector_cfg;
cfg.detector.name = tp;

% hash for detector/descriptor configuration
cfg.dhash = cfg2hash(cfg.detector);
cfg.storage = translate_interfaces(cfg.storage);