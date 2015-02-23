function [img,cid,url] = get_img(varargin)
    uid = helpers.vl_argparse(varargin);
    im = [];
    if isfield(uid,'cid')
        cid = uid.cid;
        im = get_image_cass(uid.cid);
    elseif isfield(uid,'url')
        im = get_image_cass_url(uid.url);
        
        if isempty(im) & isfield(uid,'url')
            im = get_image_url(uid.url);
    end	
    im = DR.img(im,cid,url);


function [im,url] = get_image_cass(cid);
    db = imagedb;
    is = db.check('image',cid,'raw');
    im = [];
    if is
        img = db.select_img(cid);
    end
    
    sql = sqldb;
    sql.open();
    url = sql.get_img_url(cid);

function [im,cid] = get_image_url(url);
    sql = sqldb;
    sql.open();
    cid = sql.get_img_cid(url);
    if ~isempty(cid)
        db = imagedb;
        is = db.check('image',cid,'raw');
        im = [];
        if is
            s = db.select('image',cid,'raw');
            im = readim(s);
        end
        
        if isempty(im)
            filecontents
            im = imread(url);
        end
    end



