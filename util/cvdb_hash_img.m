function h = cvdb_hash_img(img)
    h = cvdb_stringify_hash(hash(uint8(img(:)),'SHA-256')); 
