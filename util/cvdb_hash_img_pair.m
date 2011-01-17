function h = cvdb_hash_img_pair(image_1, image_2)
    h1 = hash(image_1(:),'SHA-256');
    h2 = hash(image_2(:),'SHA-256');
    h = cvdb_image_hash_xor(h1,h2);
end