classdef syscfg
    properties 
        genmap
        upgmap
        descmap
    end

    methods
        function this = syscfg()
            if (exist('extrema') == 3)
                tst = DR.CFG.mserp();
                this.genmap = containers.Map({'DR.CFG.mserp','DR.CFG.mserm','DR.CFG.hessian_affine'}, ...
                                            {'make_extrema','make_extrema','make_hessian_affine'});
                this.upgmap = containers.Map({'DR.CFG.mserp:DR.CFG.laf', 'DR.CFG.mserm:DR.CFG.laf','double:DR.CFG.noop'}, ...
                                            {'make_mser_to_laf','make_mser_to_laf','make_noop'});
                this.descmap = ...
                    containers.Map({'DR.CFG.laf:DR.CFG.sift', ...
                                    'DR.CFG.hessian_affine:DR.CFG.sift'}, ...
                                   {'make_affpt_to_sift','make_affpt_to_sift'});
            else
                throw(MException('','Cannot find feature mex'));
            end
        end

        function gens = get_gens(this,cfg_list)
            gen_str = arrayfun(@(x) values(this.genmap,x), ...
                               arrayfun(@(x) class(x),cfg_list,'UniformOutput',false), ...
                               'UniformOutput',false);
            tmp = cellfun(@(x) feval(str2func(x{:})),gen_str,'UniformOutput',false);
            gens = [tmp{:}];
        end

        function upgs = get_upgrades(this,upg_cfg_list)
            upg_str = arrayfun(@(x) values(this.upgmap,x), ...
                               arrayfun(@(x) [class(x.prev) ':' class(x)],upg_cfg_list, ...
                                        'UniformOutput',false), ...
                               'UniformOutput',false);
            tmp = cellfun(@(x) feval(str2func(x{:})),upg_str,'UniformOutput',false);
            upgs = [tmp{:}];
        end

        function descriptors = get_descriptors(this,desc_cfg_list)
            desc_str = arrayfun(@(x) values(this.descmap,x), ...
                               arrayfun(@(x) [class(x.prev) ':' class(x)], ...
                                        desc_cfg_list, ...
                                        'UniformOutput',false), ...
                               'UniformOutput',false);
            tmp = cellfun(@(x) feval(str2func(x{:})), ...
                          desc_str,'UniformOutput',false);
            descriptors = [tmp{:}];
        end
    end
end

function extrema = make_extrema()
    extrema = DR.extrema();
end

function extrema = make_hessian_affine()
    extrema = DR.affpts();
end

function mser_to_laf = make_mser_to_laf()
    mser_to_laf = DR.mser_to_laf();
end

function affpt_to_sift = make_affpt_to_sift()
    affpt_to_sift = DR.affpt_to_sift();
end

function noop = make_noop()
    noop = DR.noop();
end