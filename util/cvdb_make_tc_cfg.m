function [tc_cfg, tc_cfg_hash, tc_cfg_str] = cvdb_make_tc_cfg(cfg)
tc_cfg.detectors = cfg.detectors;
tc_cfg.descriptors = cfg.descriptors;
tc_cfg.tc = cfg.tc;

[tc_cfg_hash tc_cfg_str]  = cfg2hash(tc_cfg);