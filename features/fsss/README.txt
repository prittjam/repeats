Fast Semantic Segmentation via Soft Segments
============================================

Author:

Relja Arandjelovic (relja@robots.ox.ac.uk)
Visual Geometry Group,
Department of Engineering Science
University of Oxford

Copyright 2014, all rights reserved.

Release: v1.0.0



Overview
-----------------------------

This code is an implementation of the Fast Semantic Segmentation via
Soft Segments (FSSS) method described in the paper:

    R. Arandjelovic, A. Zisserman
    Visual vocabulary with a semantic twist
    Asian Conference on Computer Vision, 2014
http://www.robots.ox.ac.uk/~vgg/publications/2014/arandjelovic14/arandjelovic14.pdf

The supplementary material contains more details:
http://www.robots.ox.ac.uk/∼vgg/software/fast_semantic_segmentation/arandjelovic14_supplementary.pdf

To cite this work, please use:

@InProceedings{arandjelovic14,
  author       = "Arandjelovi\'c, R. and Zisserman, A.",
  title        = "Visual vocabulary with a semantic twist",
  booktitle    = "Asian Conference on Computer Vision",
  year         = "2014",
}



Requirements
-----------------------------

The code has only been tested in Linux, though it is possible it will work in
Windows / OSX.

The following dependencies must be installed:

* Matlab
* VLFeat (http://www.vlfeat.org/)
* Yael (https://gforge.inria.fr/projects/yael/)
* Liblinear (http://www.csie.ntu.edu.tw/~cjlin/liblinear/)
* Generalized Boundary Detection (https://sites.google.com/site/gbdetector/)

After installing all the dependencies, update setup.m with the relevant paths.

Additional data is required to test the code on the Oxford Building dataset,
or the Stanford background dataset:

* Oxford Buildings (http://www.robots.ox.ac.uk/~vgg/data/oxbuildings/)
* Stanford background (http://dags.stanford.edu/projects/scenedataset.html)

If one wishes to train the model for segmenting the Oxford Buildings dataset
(a pre-trained model is already provided), additional data is required,
as described in the accompanying paper:

* Paris Buildings (http://www.robots.ox.ac.uk/~vgg/data/parisbuildings/)
* Sculptures 6k (http://www.robots.ox.ac.uk/~vgg/data/sculptures6k/)
* Extra annotations for these two (http://www.robots.ox.ac.uk/~vgg/data/data-various.html)

Please update the getPaths.m with all the paths to the respective datasets.



Usage
-----------------------------

Executing allOx5k or allStBg from Matlab performs training, testing and
segmentation of the entire Oxford buildings and Stanford background datasets,
respectively.

If the vocabulary files (for the HSV colour and RootSIFT) exist,
vocabulary generation is skipped; the relevant files are:
data/dicts_parisculpt.mat
and
data/dicts_stbg.mat
for the Oxford buildings and Stanford background, respectively.

If the model files (model_parisculpt.mat and data/model_stbg.mat) exist,
model training and testing is skipped.

All these precomputed files are provided with the code, so if training/testing
is required they should be removed.

The performances are slightly different than the ones reported in the paper
due to small bug fixes. Paper reports 78.0% on Stanford background and 91.6%
on ParisSculpt360. This code achieves 78.1% and 91.3%, respectively.

The core functions are:

* inferLabels
Inputs are: image filename, RootSIFT and HSV vocabularies, liblinear model,
alpha, beta, lam(=lambda), confThr(=confidence threshold).
Outputs are: individual pixel labels, pixel-wise confidences, and segmented out
images fit for display.

* compDict, getTrainSoftFeats and svmCross
These compute vocabularies for RootSIFT and HSV, extract segment features from
training images, and then search for best parameters via cross validation.



Version History
-----------------------------

 * 31 October 2014 - 1.0.0 - Initial release
