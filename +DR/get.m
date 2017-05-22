function [fdr,res] = get_dr(img,cid_cache,varargin)
fdr = [];
res = [];

min_size = img.area/640/480*4;
min_mser_scale = 20;
min_haff_scale = 50;

cfg.type = 'all';
cfg.reflection = 1;

[cfg,~] = cmp_argparse(cfg,varargin{:});
switch cfg.type 
  case 'mser'
    dr_mask = [1 2];
  case 'haff'
    dr_mask = 3;
  case 'all'
    dr_mask = [1 2 3];
end

cfg.mser_options = {'min_size', min_size, ...
                    'nms_method', 3, ...
                    'min_areadiff', 5, ...
                    'min_margin', 10, ...
                    'max_area', 0.2 } ;
cfg.laf_options={ 'minSize', min_size, ...
                  'suppressOverlap', 0.2, ...
                  'outputFormat', 1, ...
                  'lafConstructsToUse_LAF__LAF_2TP_CONC' , 0, ...
                  'lafConstructsToUse_LAF__LAF_CG_BT' , 0, ...
                  'lafConstructsToUse_LAF__LAF_CCG_BT' , 0 };

cfg.sift_mser_options = {'desc_factor', 2.1 };
cfg.sift_haff_options = {'desc_factor', 3*sqrt(3) };

cfg.haff_options = { };

dr_chains = { { MSER.CFG.Mserp(cfg.mser_options{:}) ...
                LAF.CFG.Laf(cfg.laf_options{:}) ...
                SIFT.CFG.Sift(cfg.sift_mser_options{:}) ...
                COVDET.CFG.DistinctAffPt(min_mser_scale)  } ...

              { MSER.CFG.Mserm(cfg.mser_options{:}) ...
                LAF.CFG.Laf(cfg.laf_options{:}) ...
                SIFT.CFG.Sift(cfg.sift_mser_options{:})  ...
                COVDET.CFG.DistinctAffPt(min_mser_scale)  } ...

              { COVDET.CFG.HessianAffine(cfg.haff_options{:}) ...
                SIFT.CFG.Sift(cfg.sift_haff_options{:})  ...
                COVDET.CFG.DistinctAffPt(min_haff_scale) }};  

dr_chains = dr_chains(dr_mask);
cid_cache.add_dependency('ReflectImg',[]);

key_list = cid_cache.add_chains(dr_chains);

if cfg.reflection
    key_list = [key_list cid_cache.add_chains(dr_chains, ...
                                              'parents','ReflectImg')];
end

last_keys = cellfun(@(x) x(end),key_list);
cid_cache.add_dependency('vl_dr',[],'parents',last_keys);

if nargout == 1    
    fdr = cid_cache.get('dr','vl_dr');
end

if isempty(fdr) 
    [res_list,~,name_list] = cid_cache.get_chains(dr_chains,'',@extract,img);
    if cfg.reflection
        rimg = img.transform(@IMG.reflect);
        [res_list2,~,name_list2] = ...
            cid_cache.get_chains(dr_chains,'ReflectImg',@extract,rimg);
        res_list2 = LAF.reflect(res_list2,img.width);
        res_list = [res_list; res_list2];
        name_list = [name_list;name_list2];
    end
    dr = cellfun(@(x) x(end),res_list);
    dr_names = cellfun(@(x) x(end),name_list);
    fdr = cid_cache.get('dr','vl_dr',@combine_dr,dr,dr_names);
end

fdr = fdr(randperm(numel(fdr)));
