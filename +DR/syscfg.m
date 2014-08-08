classdef syscfg
    properties 
        genmap
        upgmap
        descmap
    end

    methods
        function this = syscfg()
            if (exist('extrema') == 3)
                tst = DR.mserp_cfg();
                this.genmap = containers.Map({'DR.mserp_cfg','DR.mserm_cfg'}, ...
                                            {'make_extrema','make_extrema'});
                this.upgmap = containers.Map({'DR.mserp_cfg:DR.laf_cfg','DR.mserm_cfg:DR.laf_cfg'}, ...
                                            {'make_mser_to_laf','make_mser_to_laf'});
                this.descmap = containers.Map('DR.laf_cfg:DR.sift_cfg','make_laf_to_sift');
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

function mser_to_laf = make_mser_to_laf()
    mser_to_laf = DR.mser_to_laf();
end

function laf_to_sift = make_laf_to_sift()
    laf_to_sift = DR.laf_to_sift();
end