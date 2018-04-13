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
The MATLAB file demo.m constructs RANSAC-based estimators from minimal solvers proposed in the following papers, 
1. "[Rectification from Radially-Distorted Scales](TBD)" 
..* a minimal solver that jointly estimates radial lens distortion and affine rectification from 3 corrrespondences of 2 coplanar affine-covariant regions, denoted in demo.m as 
> H222_eccv18

..* a minimal solver that estimates affine rectification from 2 correspondences of 2 coplanar affine-covariant regions, denoted in demo.m as 
> H222_eccv18

2. "[Radially Distorted Conjugate Translations](https://arxiv.org/abs/1711.11339)"
..* a minimal solver that jointly estimates radial lens distortion and affine rectification from 2 independent radially-distorted conjugate translations, denoted in demo.m as 
> H22_cvpr18

3. "[Detection, Rectification and Segmentation of Coplanar Repeated Patterns](http://cmp.felk.cvut.cz/~prittjam/doc/cvpr14.pdf)"
..* a minimial solver that estimates affine rectification from the change-of-scale of affine-covariant regions from the image to rectified imaged scene plane, denoted in demo.m as
> H22_cvpr14

In addition, for all solvers, the estimator attempts an upgrage to metric rectification using the upgrade proposed in 
"[Detection, Rectification and Segmentation of Coplanar Repeated Patterns](http://cmp.felk.cvut.cz/~prittjam/doc/cvpr14.pdf)".

The MATLAB file demo.m constructs 4 RANSAC-based estimators from each of the minimal solvers enumerated above.



"(TBD)

We provide two examples, how to estimate affine shape with AffNet. 
First, on patch-column file, in [HPatches](https://github.com/hpatches/hpatches-benchmark) format, i.e. grayscale image with w = patchSize and h = nPatches * patchSize

```
cd examples/just_shape
python detect_affine_shape.py imgs/face.png out.txt
```

Out file format is upright affine frame a11 0 a21 a22


Second, AffNet inside pytorch implementation of Hessian-Affine

2000 is number of regions to detect.

```
cd examples/hesaffnet
python hesaffnet.py img/cat.png ells-affnet.txt 2000
python hesaffBaum.py img/cat.png ells-Baumberg.txt 2000
```

output ells-affnet.txt is [Oxford affine](http://www.robots.ox.ac.uk/~vgg/research/affine/) format 
```
1.0
128
x y a b c 
```

## Citation

Please cite us if you use this code:

```
@article{AffNet2017,
 author = {Dmytro Mishkin, Filip Radenovic, Jiri Matas},
    title = "{Learning Discriminative Affine Regions via Discriminability}",
     year = 2017,
    month = nov}
```

