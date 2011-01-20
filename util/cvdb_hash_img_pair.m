function h = cvdb_hash_img_pair(img1, img2)
    h1 = hash(img1(:),'SHA-256');
    h2 = hash(img2(:),'SHA-256');
    h = cvdb_img_hash_xor(h1,h2);