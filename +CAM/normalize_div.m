function q = normalize_div(q, A)
    sc = A(1,1);
    q = q / (sc^2);
end