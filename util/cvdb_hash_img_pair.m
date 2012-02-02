function h = cvdb_hash_img_pair(img1, img2)
    h1 = cvdb_hash_img(img1);
    h2 = cvdb_hash_img(img2);
    h = cvdb_hash_xor(h1,h2);