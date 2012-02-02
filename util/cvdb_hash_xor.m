function h = cvdb_hash_xor(h1,h2)
X = uint32(zeros(1,4));

for i=1:4
    X(i) = bitxor(uint32(hex2dec(h1(8*(i-1)+1:8*i))), ...
                  uint32(hex2dec(h2(8*(i-1)+1:8*i))));
end

hh = dec2hex(X);
h = [hh(:)'];