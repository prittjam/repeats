#include "mex.h"
#include <stdio.h>
#include <stdlib.h>

#include <vector>
#include <string>

#include "seeds2.h"

#include <cv.h>
#include <highgui.h>
#include <fstream>

#include "helper.h"

using namespace std;

void mexFunction(int		nlhs, 		/* number of expected outputs */
				 mxArray		*plhs[],	/* mxArray output pointer array */
				 int			nrhs, 		/* number of inputs */
				 const mxArray	*prhs[]		/* mxArray input pointer array */)
{

    char* input_file1;
    if (nrhs != 2 )
	{
		mexErrMsgTxt ("Usage : <image> <number_of_superpixels>\n");
		return;
	}
    

    int NR_SUPERPIXELS = (int) *mxGetPr(prhs[1]);

  int numlabels = 10;
  int width(0), height(0), channels(0);

  char *G_pt =(char *) mxGetPr(prhs[0]) ;
  
  const int*  dimensions = mxGetDimensions(prhs[0]) ;
    width  = dimensions[0] ;
   height = dimensions[1] ;
    channels = dimensions[2] ;
   int sz = height*width;

  
    
  UINT* ubuff = new UINT[sz];
  UINT* ubuff2 = new UINT[sz];
  UINT* dbuff = new UINT[sz];
  UINT pValue;
  UINT pdValue;
  char c;
  UINT r,g,b,dx,dy;
  int idx = 0;
  for(int j=0;j<width;j++)
    for(int i=0;i<height;i++)
      {
        if(channels == 3)
          {
            // image is assumed to have data in BGR order
            b = G_pt[i+j*height + 0*sz];//((uchar*)(img->imageData + img->widthStep*(j)))[(i)*img->nChannels];
            g = G_pt[i+j*height + 2*sz];//((uchar*)(img->imageData + img->widthStep*(j)))[(i)*img->nChannels+1];
            r = G_pt[i+j*height + 1*sz];//((uchar*)(img->imageData + img->widthStep*(j)))[(i)*img->nChannels+2];
            pValue = b | (g << 8) | (r << 16);
          }
        else 
          {
            c = G_pt[i+j*height ];//((uchar*)(img->imageData + img->widthStep*(j)))[(i)*img->nChannels];
            pValue = c | (c << 8) | (c << 16);
          }        
        ubuff[idx] = pValue;
        ubuff2[idx] = pValue;
        idx++;
      }


int NR_BINS = 5; // Number of bins in each histogram channel

SEEDS seeds(width, height, 3, NR_BINS);

// SEEDS INITIALIZE
int nr_superpixels = NR_SUPERPIXELS;

int seed_width = 3; int seed_height = 4; int nr_levels = 4;
if (width >= height)
{
	if (nr_superpixels == 600) {seed_width = 2; seed_height = 2; nr_levels = 4;}
	if (nr_superpixels == 400) {seed_width = 3; seed_height = 2; nr_levels = 4;}
	if (nr_superpixels == 266) {seed_width = 3; seed_height = 3; nr_levels = 4;}
	if (nr_superpixels == 200) {seed_width = 3; seed_height = 4; nr_levels = 4;}
	if (nr_superpixels == 150) {seed_width = 2; seed_height = 2; nr_levels = 5;}
	if (nr_superpixels == 100) {seed_width = 3; seed_height = 2; nr_levels = 5;}
	if (nr_superpixels == 50)  {seed_width = 3; seed_height = 4; nr_levels = 5;}
	if (nr_superpixels == 25)  {seed_width = 3; seed_height = 2; nr_levels = 6;}
	if (nr_superpixels == 17)  {seed_width = 3; seed_height = 3; nr_levels = 6;}
	if (nr_superpixels == 12)  {seed_width = 3; seed_height = 4; nr_levels = 6;}
	if (nr_superpixels == 9)  {seed_width = 2; seed_height = 2; nr_levels = 7;}
	if (nr_superpixels == 6)  {seed_width = 3; seed_height = 2; nr_levels = 7;}
}
else
{
	if (nr_superpixels == 600) {seed_width = 2; seed_height = 2; nr_levels = 4;}
	if (nr_superpixels == 400) {seed_width = 2; seed_height = 3; nr_levels = 4;}
	if (nr_superpixels == 266) {seed_width = 3; seed_height = 3; nr_levels = 4;}
	if (nr_superpixels == 200) {seed_width = 4; seed_height = 3; nr_levels = 4;}
	if (nr_superpixels == 150) {seed_width = 2; seed_height = 2; nr_levels = 5;}
	if (nr_superpixels == 100) {seed_width = 2; seed_height = 3; nr_levels = 5;}
	if (nr_superpixels == 50)  {seed_width = 4; seed_height = 3; nr_levels = 5;}
	if (nr_superpixels == 25)  {seed_width = 2; seed_height = 3; nr_levels = 6;}
	if (nr_superpixels == 17)  {seed_width = 3; seed_height = 3; nr_levels = 6;}
	if (nr_superpixels == 12)  {seed_width = 4; seed_height = 3; nr_levels = 6;}
	if (nr_superpixels == 9)  {seed_width = 2; seed_height = 2; nr_levels = 7;}
	if (nr_superpixels == 6)  {seed_width = 2; seed_height = 3; nr_levels = 7;}
}
seeds.initialize(seed_width, seed_height, nr_levels);

seeds.update_image_ycbcr(ubuff);



    seeds.iterate();
    
    plhs[0] = mxCreateNumericMatrix( width,height ,mxINT32_CLASS , mxREAL);
     int* out = (int*)mxGetData(plhs[0]);
    
    int k=0;
    for(int j=0;j<width;j++){
        for(int i=0;i<height;i++){
            out[k]=(int) seeds.labels[nr_levels-1][k++];
        }
    }
        
    delete[] ubuff;


    return;

}
