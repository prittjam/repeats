function [tc_cfg] = cvdb_make_tc_cfg(cfg)
tc_cfg.detectors = cfg.detectors;
tc_cfg.descriptors = cfg.descriptors;
tc_cfg.tc = cfg.tc;