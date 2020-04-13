function cam = make_lens(cam, q)
    cam.q = q / (sum(2*cam.cc)^2);
end