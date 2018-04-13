# Rectification and Undistortion from Coplanar Repeats



## Datasets and Training
To start using repeats, :

```
bash
git clone https://github.com/prittjam/repeats
cd repeats
matlab -nosplash -nodesktop -r demo
```

## Usage example
The MATLAB file [demo.m](TBD) constructs RANSAC-based estimators from minimal solvers proposed in the following papers: 
1. "[Rectification from Radially-Distorted Scales](TBD)" 
  * a minimal solver that jointly estimates radial lens distortion and affine rectification from 3 corrrespondences of 2 coplanar affine-covariant regions, denoted in demo.m as H222_eccv18 and
  * a minimal solver that estimates affine rectification from 2 correspondences of 2 coplanar affine-covariant regions, denoted in demo.m as H22_eccv18,

2. "[Radially Distorted Conjugate Translations](https://arxiv.org/abs/1711.11339)"
  * a minimal solver that jointly estimates radial lens distortion and affine rectification from 2 independent radially-distorted conjugate translations, denoted in demo.m as H22_cvpr18, and

3. "[Detection, Rectification and Segmentation of Coplanar Repeated Patterns](http://cmp.felk.cvut.cz/~prittjam/doc/cvpr14.pdf)"
  * a minimial solver that estimates affine rectification from the change-of-scale of affine-covariant regions from the image to a rectified imaged scene plane, denoted in demo.m as H22_cvpr14.

In addition, for all solvers, the estimator attempts an upgrage to a metric rectification using the upgrade proposed in 
"[Detection, Rectification and Segmentation of Coplanar Repeated Patterns](http://cmp.felk.cvut.cz/~prittjam/doc/cvpr14.pdf)".

The MATLAB file [demo.m](TBD) constructs 4 RANSAC-based estimators from each of the minimal solvers enumerated above.

"(TBD)

We provide two examples, how to estimate affine shape with AffNet. 
First, on patch-column file, in [HPatches](https://github.com/hpatches/hpatches-benchmark) format, i.e. grayscale image with w = patchSize and h = nPatches * patchSize

```
cd examples/just_shape
python detect_affine_shape.py imgs/face.png out.txt
```

## Estimator parameters

1. [RepeatSampler.m](TBD)
  * min_trial_count, minimum number of RANSAC trials
  * max_trial_count, maximum number of RANSAC trials
  * max_num_retries, maximum number of retries to find a valid sampling of the measurements
2. [RepeatEval.m](TBD)
  * extentT, the threshold of ratio of extent lengths of affine frames which defines inliers and outliers. 

## Citations

Please cite us if you use this code:

```
@article{AffNet2017,
 author = {Dmytro Mishkin, Filip Radenovic, Jiri Matas},
    title = "{Learning Discriminative Affine Regions via Discriminability}",
     year = 2017,
    month = nov}
```

