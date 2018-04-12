mex -O -I/usr/include/opencv -L/usr/local/lib -L/usr/lib -lopencv_core -lopencv_highgui -c seeds2.cpp

mex -O mexSEEDS.cpp -I/usr/include/opencv  -L/usr/lib -lopencv_core -lopencv_highgui seeds2.o
