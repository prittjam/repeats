# Rectification from Coplanar Repeats
This framework rectifies imaged coplanar repeated patterns. Minimal solvers derived from constraints induced by coplanar repeated patterns are used in a LO-RANSAC-based robust-estimation framework. Affine-covariant features are extracted from the image for input to the solvers. Affine-covariant features are highly repeatable on the same imaged scene texture with respect to significant changes of viewpoint and illumination. In particular, the Maximally-Stable Extremal Region and Hesssian-Affine detectors are used. Affine frames are labeled as repeated texture based on the similarity of their appearance, which is given by the RootSIFT embedding of the image patch local to the affine frame. The RootSIFT descriptors are agglomeratively clustered, which establishes tentative correspondences among the connected components linked by the
clustering. Each appearance cluster has some proportion of its members that correspond to affine frames that give
the geometry of imaged repeated scene content, which are the inliers of that appearance cluster. The remaining affine
frames are the outliers.

LO-RANSAC samples pairs of affine frames from the appearance cluster, which are inputted to a minimal solvers. Each pair of affine frames across all appearance clusters has an equi-probable chance of being drawn.
The consensus with the minimal sample is measured by the number of pairs of affine frames within appearance groups
that are consistent with the hypothesized model normalized by the size of each respective group. A non-linear optimizer is used as the local optimization step of the LO-RANSAC estimator, which estimates a generative model of the iamged coplanar repeated pattern. 

## Download and Run 
To start using repeats, 
```
bash
git clone https://github.com/prittjam/repeats
cd repeats
matlab -nosplash -nodesktop -r demo
```

## Structure
- [`features`](tbd) - MATLAB wrappers for the feature detectors
- [`solvers`](tbd) - minimal solvers proposed in the papers mentioned under usage 
- [`vgtk`](tbd) - the visual geometry toolkit, a dependency implementing useful functions for projective geometry
- [`ransac`](tbd) - implementation of LO-RANSAC
- [`pattern-printer`](tbd) - constructs the generative model of the imaged coplanar repeated pattern
- [`scene-sim`](tbd) - makes synthetic scenes containing coplanar repeated patterns
- [`eccv18`](tbd) - reproduce synthetic experiments from the paper [Rectification from Radially-Distorted Scales](TBD)
- [`external`](tbd) - contains dependencies from various authors and sources
- [`mex`](tbd) - contains mex binaries for the feature detectors (Linux only)

## Usage Example
The MATLAB file [demo.m](TBD) constructs 4 RANSAC-based estimators from minimal solvers proposed in the following papers: 
1. "[Rectification from Radially-Distorted Scales](TBD)" 
  * a minimal solver that jointly estimates radial lens distortion and affine rectification from 3 corrrespondences of 2 coplanar affine-covariant regions, denoted in [demo.m](TBD) as H222_eccv18 and
  * a minimal solver that estimates affine rectification from 2 correspondences of 2 coplanar affine-covariant regions, denoted in [demo.m](TBD) as H22_eccv18,

2. "[Radially Distorted Conjugate Translations](https://arxiv.org/abs/1711.11339)"
  * a minimal solver that jointly estimates radial lens distortion and affine rectification from 2 independent radially-distorted conjugate translations, denoted in [demo.m](TBD) as H22_cvpr18, and

3. "[Detection, Rectification and Segmentation of Coplanar Repeated Patterns](http://cmp.felk.cvut.cz/~prittjam/doc/cvpr14.pdf)"
  * a minimial solver that estimates affine rectification from the change-of-scale of affine-covariant regions from the image to a rectified imaged scene plane, denoted in [demo.m](TBD) as H22_cvpr14.

In addition, for all solvers, the estimator attempts an upgrade to a metric rectification using the upgrade proposed in 
"[Detection, Rectification and Segmentation of Coplanar Repeated Patterns](http://cmp.felk.cvut.cz/~prittjam/doc/cvpr14.pdf)".

The solvers are run on the images in the [img] subdirectory and the results are placed in the [res]. 

### Input
* image with a scene plane containing some coplanar repeated pattern
+ optional .mat specifying a bounding box that defines the region in the image to be rectified

### Output 
*
*

## Images
<img src="imgs/pattern1b.jpg" alt="Drawing" height="50" width="100"/>
![](imgs/pattern1b.jpg =150x100)
![](imgs/pattern24w.jpg =150x100)


## Feature Detection Parameters

## RANSAC Parameters
1. [RepeatSampler.m](TBD)
  * `min_trial_count`, minimum number of RANSAC trials
  * `max_trial_count`, maximum number of RANSAC trials
  * `max_num_retries`, maximum number of retries to find a valid sampling of the measurements
2. [RepeatEval.m](TBD)
  * `extentT`, the threshold of ratio of extent lengths of affine frames which defines inliers and outliers. 
 
## Pattern Printer Parameters



## Citations
Please cite us if you use this code:

* Rectification, and Segmentation of Coplanar Repeated Patterns
```
@inproceedings{DBLP:conf/cvpr/PrittsCM14,
  author    = {James Pritts and
               Ondrej Chum and
               Jiri Matas},
  title     = {Rectification, and Segmentation of Coplanar Repeated Patterns},
  booktitle = {2014 {IEEE} Conference on Computer Vision and Pattern Recognition,
               {CVPR} 2014, Columbus, OH, USA, June 23-28, 2014},
  pages     = {2973--2980},
  year      = {2014},
  crossref  = {DBLP:conf/cvpr/2014},
  url       = {https://doi.org/10.1109/CVPR.2014.380},
  doi       = {10.1109/CVPR.2014.380},
  timestamp = {Thu, 15 Jun 2017 21:35:56 +0200},
  biburl    = {https://dblp.org/rec/bib/conf/cvpr/PrittsCM14},
  bibsource = {dblp computer science bibliography, https://dblp.org}
}
```
* Radially-Distorted Conjugate Translations
```
@article{DBLP:journals/corr/abs-1711-11339,
  author    = {James Pritts and
               Zuzana Kukelova and
               Viktor Larsson and
               Ondrej Chum},
  title     = {Radially-Distorted Conjugate Translations},
  journal   = {CoRR},
  volume    = {abs/1711.11339},
  year      = {2017},
  url       = {http://arxiv.org/abs/1711.11339},
  archivePrefix = {arXiv},
  eprint    = {1711.11339},
  timestamp = {Mon, 04 Dec 2017 18:34:59 +0100},
  biburl    = {https://dblp.org/rec/bib/journals/corr/abs-1711-11339},
  bibsource = {dblp computer science bibliography, https://dblp.org}
}
```
